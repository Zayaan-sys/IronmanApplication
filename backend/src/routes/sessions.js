const { Router } = require("express");
const { supabase } = require("../db");

const router = Router();

const DISCIPLINES = new Set(["swim", "bike", "run", "strength"]);

function toOptionalNumber(value) {
  if (value === undefined || value === null || value === "") return undefined;
  const number = Number(value);
  return Number.isFinite(number) ? number : undefined;
}

// GET /sessions
router.get("/", async (req, res) => {
  try {
    const { data, error } = await supabase
      .from("sessions")
      .select("*")
      .order("session_date", { ascending: false })
      .order("created_at", { ascending: false });
    if (error) throw error;
    res.json(data);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// GET /sessions/week/:weekNum
router.get("/week/:weekNum", async (req, res) => {
  try {
    const { data, error } = await supabase
      .from("sessions")
      .select("*")
      .eq("plan_week", req.params.weekNum)
      .order("session_date", { ascending: true });
    if (error) throw error;
    res.json(data);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// GET /sessions/summary — weekly totals per discipline
router.get("/summary", async (req, res) => {
  try {
    const today = new Date();
    const monday = new Date(today);
    monday.setDate(today.getDate() - ((today.getDay() + 6) % 7));
    const weekStart = monday.toISOString().split("T")[0];

    const { data, error } = await supabase
      .from("sessions")
      .select("discipline, distance_km, duration_seconds")
      .gte("session_date", weekStart);
    if (error) throw error;

    const summary = {};
    for (const s of data) {
      if (!summary[s.discipline]) {
        summary[s.discipline] = {
          discipline: s.discipline,
          session_count: 0,
          total_distance_km: 0,
          total_duration_seconds: 0,
        };
      }
      summary[s.discipline].session_count++;
      summary[s.discipline].total_distance_km += parseFloat(s.distance_km ?? 0);
      summary[s.discipline].total_duration_seconds += parseInt(s.duration_seconds ?? 0);
    }

    res.json(Object.values(summary));
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// POST /sessions
router.post("/", async (req, res) => {
  const {
    discipline, title, session_date, duration_seconds, distance_km,
    avg_hr, avg_pace, training_zone, feeling, notes, plan_week, planned_session_id,
  } = req.body;

  if (!discipline) return res.status(400).json({ error: "discipline is required" });
  if (!DISCIPLINES.has(discipline)) {
    return res.status(400).json({ error: "discipline must be swim, bike, run, or strength" });
  }

  const zone = toOptionalNumber(training_zone);
  const feel = toOptionalNumber(feeling);
  if (zone !== undefined && (zone < 1 || zone > 5)) {
    return res.status(400).json({ error: "training_zone must be between 1 and 5" });
  }
  if (feel !== undefined && (feel < 0 || feel > 4)) {
    return res.status(400).json({ error: "feeling must be between 0 and 4" });
  }

  try {
    const { data, error } = await supabase
      .from("sessions")
      .insert({
        discipline, title,
        session_date: session_date || new Date().toISOString().split("T")[0],
        duration_seconds: toOptionalNumber(duration_seconds),
        distance_km: toOptionalNumber(distance_km),
        avg_hr: toOptionalNumber(avg_hr),
        avg_pace,
        training_zone: zone,
        feeling: feel,
        notes,
        plan_week: toOptionalNumber(plan_week),
        planned_session_id,
      })
      .select()
      .single();
    if (error) throw error;
    res.status(201).json(data);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// PATCH /sessions/:id
router.patch("/:id", async (req, res) => {
  const allowed = ["title", "duration_seconds", "distance_km", "avg_hr", "avg_pace", "training_zone", "feeling", "notes"];
  const updates = Object.fromEntries(
    allowed.filter(f => req.body[f] !== undefined).map(f => [f, req.body[f]])
  );

  if (Object.keys(updates).length === 0) {
    return res.status(400).json({ error: "No fields to update" });
  }

  try {
    const { data, error } = await supabase
      .from("sessions")
      .update(updates)
      .eq("id", req.params.id)
      .select()
      .single();
    if (error) throw error;
    if (!data) return res.status(404).json({ error: "Session not found" });
    res.json(data);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// DELETE /sessions/:id
router.delete("/:id", async (req, res) => {
  try {
    const { error } = await supabase
      .from("sessions")
      .delete()
      .eq("id", req.params.id);
    if (error) throw error;
    res.json({ success: true });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
