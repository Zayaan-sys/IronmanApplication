const { Router } = require("express");
const { supabase } = require("../db");

const router = Router();

// GET /plans/active
router.get("/active", async (req, res) => {
  try {
    const { data: plan, error: planErr } = await supabase
      .from("plans")
      .select("*")
      .eq("is_active", true)
      .limit(1)
      .single();

    if (planErr?.code === "PGRST116") return res.json(null);
    if (planErr) throw planErr;

    const { data: weeks, error: weeksErr } = await supabase
      .from("plan_weeks")
      .select("*, planned_sessions(*)")
      .eq("plan_id", plan.id)
      .order("week_number", { ascending: true });

    if (weeksErr) throw weeksErr;
    res.json({ ...plan, weeks });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// GET /plans/dashboard
router.get("/dashboard", async (req, res) => {
  try {
    const { data: plan, error: planErr } = await supabase
      .from("plans")
      .select("*")
      .eq("is_active", true)
      .limit(1)
      .single();

    if (planErr?.code === "PGRST116") return res.json(null);
    if (planErr) throw planErr;

    const today = new Date();
    const currentWeekNum = Math.max(
      1,
      Math.ceil((today - new Date(plan.start_date)) / (7 * 86400000))
    );

    const { data: weeks, error: weeksErr } = await supabase
      .from("plan_weeks")
      .select("*, planned_sessions(*)")
      .eq("plan_id", plan.id)
      .eq("week_number", currentWeekNum);

    if (weeksErr) throw weeksErr;

    // Weekly session summary aggregated in JS
    const monday = new Date(today);
    monday.setDate(today.getDate() - ((today.getDay() + 6) % 7));
    const weekStart = monday.toISOString().split("T")[0];

    const { data: sessions, error: sessErr } = await supabase
      .from("sessions")
      .select("discipline, distance_km, duration_seconds")
      .gte("session_date", weekStart);

    if (sessErr) throw sessErr;

    const summary = {};
    for (const s of sessions) {
      if (!summary[s.discipline]) {
        summary[s.discipline] = { discipline: s.discipline, total_distance_km: 0, total_duration_seconds: 0 };
      }
      summary[s.discipline].total_distance_km += parseFloat(s.distance_km ?? 0);
      summary[s.discipline].total_duration_seconds += parseInt(s.duration_seconds ?? 0);
    }

    res.json({
      plan: { ...plan, current_week: currentWeekNum },
      current_week: weeks?.[0] ?? null,
      weekly_summary: Object.values(summary),
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// POST /plans
router.post("/", async (req, res) => {
  const { name, race_name, race_date, total_weeks, start_date } = req.body;
  if (!name || !total_weeks || !start_date) {
    return res.status(400).json({ error: "name, total_weeks, and start_date are required" });
  }

  try {
    await supabase.from("plans").update({ is_active: false }).neq("id", "00000000-0000-0000-0000-000000000000");

    const { data, error } = await supabase
      .from("plans")
      .insert({ name, race_name, race_date, total_weeks, start_date })
      .select()
      .single();
    if (error) throw error;
    res.status(201).json(data);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// POST /plans/:planId/weeks
router.post("/:planId/weeks", async (req, res) => {
  const { week_number, phase, target_hours, notes } = req.body;
  if (!week_number || !phase) {
    return res.status(400).json({ error: "week_number and phase are required" });
  }

  try {
    const { data, error } = await supabase
      .from("plan_weeks")
      .insert({ plan_id: req.params.planId, week_number, phase, target_hours, notes })
      .select()
      .single();
    if (error) throw error;
    res.status(201).json(data);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// POST /plans/weeks/:weekId/sessions
router.post("/weeks/:weekId/sessions", async (req, res) => {
  const { day_of_week, discipline, title, description, target_distance_km, target_duration_seconds, training_zone } = req.body;
  if (!day_of_week || !discipline) {
    return res.status(400).json({ error: "day_of_week and discipline are required" });
  }

  try {
    const { data, error } = await supabase
      .from("planned_sessions")
      .insert({ plan_week_id: req.params.weekId, day_of_week, discipline, title, description, target_distance_km, target_duration_seconds, training_zone })
      .select()
      .single();
    if (error) throw error;
    res.status(201).json(data);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
