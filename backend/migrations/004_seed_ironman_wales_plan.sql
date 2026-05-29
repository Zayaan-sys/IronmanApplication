-- Migration 004: Seed – IRONMAN Wales 24-week training plan
-- Run this after migrations 001–003.
-- No user ID needed — single-device app.

DO $$
DECLARE
  v_plan_id UUID;
  v_week_id UUID;
BEGIN

  -- ── Create the plan ──────────────────────────────────────────────────────
  INSERT INTO plans (name, race_name, race_date, total_weeks, start_date, is_active)
  VALUES (
    'IRONMAN Wales 2026',
    'IRONMAN Wales',
    '2026-09-20',
    24,
    '2026-04-05',
    TRUE
  )
  RETURNING id INTO v_plan_id;

  -- ── Week 1 – Base Building ────────────────────────────────────────────────
  INSERT INTO plan_weeks (plan_id, week_number, phase, target_hours, notes)
  VALUES (v_plan_id, 1, 'Base Building', 8.0, 'Easy aerobic base. Keep HR in zone 2.')
  RETURNING id INTO v_week_id;

  INSERT INTO planned_sessions (plan_week_id, day_of_week, discipline, title, target_duration_seconds, target_distance_km, training_zone)
  VALUES
    (v_week_id, 'Mon', 'rest',     'Rest Day',              NULL,  NULL, NULL),
    (v_week_id, 'Tue', 'swim',     'Easy Swim',             3600,  2.0,  2),
    (v_week_id, 'Wed', 'run',      'Easy Run',              3600,  8.0,  2),
    (v_week_id, 'Thu', 'bike',     'Zone 2 Ride',           5400,  50.0, 2),
    (v_week_id, 'Fri', 'swim',     'Technique Swim',        3000,  1.5,  2),
    (v_week_id, 'Sat', 'run',      'Long Run',              5400,  14.0, 2),
    (v_week_id, 'Sun', 'bike',     'Long Easy Ride',        10800, 90.0, 2);

  -- ── Week 2 – Base Building ────────────────────────────────────────────────
  INSERT INTO plan_weeks (plan_id, week_number, phase, target_hours, notes)
  VALUES (v_plan_id, 2, 'Base Building', 9.0, 'Add 10% volume. Focus on swim technique.')
  RETURNING id INTO v_week_id;

  INSERT INTO planned_sessions (plan_week_id, day_of_week, discipline, title, target_duration_seconds, target_distance_km, training_zone)
  VALUES
    (v_week_id, 'Mon', 'rest',     'Rest Day',              NULL,  NULL, NULL),
    (v_week_id, 'Tue', 'swim',     'Endurance Swim',        3600,  2.5,  2),
    (v_week_id, 'Wed', 'run',      'Easy Run',              3600,  9.0,  2),
    (v_week_id, 'Thu', 'bike',     'Zone 2 Ride',           5400,  55.0, 2),
    (v_week_id, 'Fri', 'swim',     'Pull Set',              3000,  2.0,  2),
    (v_week_id, 'Sat', 'run',      'Long Run',              6300,  16.0, 2),
    (v_week_id, 'Sun', 'bike',     'Long Easy Ride',        12600, 105.0,2);

  -- ── Week 3 – Base Building ────────────────────────────────────────────────
  INSERT INTO plan_weeks (plan_id, week_number, phase, target_hours, notes)
  VALUES (v_plan_id, 3, 'Base Building', 10.0, 'Continue building. Include one brick session.')
  RETURNING id INTO v_week_id;

  INSERT INTO planned_sessions (plan_week_id, day_of_week, discipline, title, target_duration_seconds, target_distance_km, training_zone)
  VALUES
    (v_week_id, 'Mon', 'rest',     'Rest Day',              NULL,  NULL, NULL),
    (v_week_id, 'Tue', 'swim',     'Endurance Swim',        4200,  2.8,  2),
    (v_week_id, 'Wed', 'run',      'Easy Run',              3600,  10.0, 2),
    (v_week_id, 'Thu', 'bike',     'Zone 2 Ride',           6300,  60.0, 2),
    (v_week_id, 'Fri', 'swim',     'Kick + Pull',           3000,  2.0,  2),
    (v_week_id, 'Sat', 'bike',     'Brick Ride + Run',      7200,  70.0, 2),
    (v_week_id, 'Sun', 'run',      'Long Run',              6300,  18.0, 2);

  -- ── Week 4 – Recovery ─────────────────────────────────────────────────────
  INSERT INTO plan_weeks (plan_id, week_number, phase, target_hours, notes)
  VALUES (v_plan_id, 4, 'Recovery', 6.0, 'Cutback week. 40% volume reduction. Let adaptations set in.')
  RETURNING id INTO v_week_id;

  INSERT INTO planned_sessions (plan_week_id, day_of_week, discipline, title, target_duration_seconds, target_distance_km, training_zone)
  VALUES
    (v_week_id, 'Mon', 'rest',     'Rest Day',              NULL,  NULL, NULL),
    (v_week_id, 'Tue', 'swim',     'Easy Swim',             2400,  1.5,  1),
    (v_week_id, 'Wed', 'run',      'Easy Run',              2400,  6.0,  1),
    (v_week_id, 'Thu', 'bike',     'Recovery Spin',         3600,  40.0, 1),
    (v_week_id, 'Fri', 'rest',     'Rest Day',              NULL,  NULL, NULL),
    (v_week_id, 'Sat', 'run',      'Easy Long Run',         3600,  12.0, 1),
    (v_week_id, 'Sun', 'bike',     'Easy Ride',             7200,  65.0, 1);

  -- ── Week 5 – Build 1 ──────────────────────────────────────────────────────
  INSERT INTO plan_weeks (plan_id, week_number, phase, target_hours, notes)
  VALUES (v_plan_id, 5, 'Build 1', 11.0, 'Introduce threshold intervals on bike and run.')
  RETURNING id INTO v_week_id;

  INSERT INTO planned_sessions (plan_week_id, day_of_week, discipline, title, target_duration_seconds, target_distance_km, training_zone)
  VALUES
    (v_week_id, 'Mon', 'rest',     'Rest Day',              NULL,  NULL, NULL),
    (v_week_id, 'Tue', 'swim',     'Threshold Swim',        3600,  2.8,  4),
    (v_week_id, 'Wed', 'run',      'Tempo Run',             3600,  10.0, 4),
    (v_week_id, 'Thu', 'bike',     'Threshold Ride',        6300,  65.0, 4),
    (v_week_id, 'Fri', 'swim',     'Aerobic Swim',          3000,  2.0,  2),
    (v_week_id, 'Sat', 'bike',     'Long Ride + Run Brick', 10800, 100.0,3),
    (v_week_id, 'Sun', 'run',      'Long Run',              7200,  20.0, 2);

  -- ── Week 6 – Build 1 ──────────────────────────────────────────────────────
  INSERT INTO plan_weeks (plan_id, week_number, phase, target_hours, notes)
  VALUES (v_plan_id, 6, 'Build 1', 12.0, 'Race-pace intervals. Practice nutrition on long sessions.')
  RETURNING id INTO v_week_id;

  INSERT INTO planned_sessions (plan_week_id, day_of_week, discipline, title, target_duration_seconds, target_distance_km, training_zone)
  VALUES
    (v_week_id, 'Mon', 'rest',     'Rest Day',              NULL,  NULL, NULL),
    (v_week_id, 'Tue', 'swim',     'Race Pace Swim',        3600,  3.0,  4),
    (v_week_id, 'Wed', 'run',      'Interval Run',          3600,  11.0, 4),
    (v_week_id, 'Thu', 'bike',     'Race Pace Ride',        7200,  70.0, 4),
    (v_week_id, 'Fri', 'swim',     'Recovery Swim',         2400,  1.5,  1),
    (v_week_id, 'Sat', 'bike',     'Long Ride',             12600, 120.0,3),
    (v_week_id, 'Sun', 'run',      'Long Run',              7200,  21.0, 2);

  -- ── Week 7 – Build 1 ──────────────────────────────────────────────────────
  INSERT INTO plan_weeks (plan_id, week_number, phase, target_hours, notes)
  VALUES (v_plan_id, 7, 'Build 1', 13.0, 'Peak Build 1 week. Strong effort throughout.')
  RETURNING id INTO v_week_id;

  INSERT INTO planned_sessions (plan_week_id, day_of_week, discipline, title, target_duration_seconds, target_distance_km, training_zone)
  VALUES
    (v_week_id, 'Mon', 'strength', 'Strength & Core',       3600,  NULL, 2),
    (v_week_id, 'Tue', 'swim',     'Threshold Swim',        4200,  3.2,  4),
    (v_week_id, 'Wed', 'run',      'Tempo Run',             3600,  12.0, 4),
    (v_week_id, 'Thu', 'bike',     'Threshold Ride',        7200,  75.0, 4),
    (v_week_id, 'Fri', 'swim',     'Aerobic Swim',          3000,  2.0,  2),
    (v_week_id, 'Sat', 'bike',     'Long Brick',            12600, 130.0,3),
    (v_week_id, 'Sun', 'run',      'Long Run',              7800,  22.0, 2);

  -- ── Week 8 – Recovery ─────────────────────────────────────────────────────
  INSERT INTO plan_weeks (plan_id, week_number, phase, target_hours, notes)
  VALUES (v_plan_id, 8, 'Recovery', 7.0, 'Cutback week. Active recovery. Assess any niggles.')
  RETURNING id INTO v_week_id;

  INSERT INTO planned_sessions (plan_week_id, day_of_week, discipline, title, target_duration_seconds, target_distance_km, training_zone)
  VALUES
    (v_week_id, 'Mon', 'rest',     'Rest Day',              NULL,  NULL, NULL),
    (v_week_id, 'Tue', 'swim',     'Easy Swim',             2400,  1.5,  1),
    (v_week_id, 'Wed', 'run',      'Easy Run',              2400,  7.0,  1),
    (v_week_id, 'Thu', 'bike',     'Recovery Spin',         3600,  45.0, 1),
    (v_week_id, 'Fri', 'rest',     'Rest Day',              NULL,  NULL, NULL),
    (v_week_id, 'Sat', 'run',      'Easy Long Run',         4200,  14.0, 1),
    (v_week_id, 'Sun', 'bike',     'Easy Ride',             7200,  70.0, 1);

  -- ── Week 9 – Build 2 ──────────────────────────────────────────────────────
  INSERT INTO plan_weeks (plan_id, week_number, phase, target_hours, notes)
  VALUES (v_plan_id, 9, 'Build 2', 13.0, 'Second build block. Higher intensity on key sessions.')
  RETURNING id INTO v_week_id;

  INSERT INTO planned_sessions (plan_week_id, day_of_week, discipline, title, target_duration_seconds, target_distance_km, training_zone)
  VALUES
    (v_week_id, 'Mon', 'rest',     'Rest Day',              NULL,  NULL, NULL),
    (v_week_id, 'Tue', 'swim',     'VO2 Swim Sets',         4200,  3.2,  5),
    (v_week_id, 'Wed', 'run',      'Threshold Run',         3600,  12.0, 4),
    (v_week_id, 'Thu', 'bike',     'Over-Under Intervals',  7200,  75.0, 4),
    (v_week_id, 'Fri', 'swim',     'Aerobic Swim',          3000,  2.2,  2),
    (v_week_id, 'Sat', 'bike',     'Long Ride',             14400, 140.0,3),
    (v_week_id, 'Sun', 'run',      'Long Run',              8400,  24.0, 2);

  -- ── Week 10 – Build 2 ─────────────────────────────────────────────────────
  INSERT INTO plan_weeks (plan_id, week_number, phase, target_hours, notes)
  VALUES (v_plan_id, 10, 'Build 2', 14.0, 'Longest bike week. Practice race-day nutrition strategy.')
  RETURNING id INTO v_week_id;

  INSERT INTO planned_sessions (plan_week_id, day_of_week, discipline, title, target_duration_seconds, target_distance_km, training_zone)
  VALUES
    (v_week_id, 'Mon', 'strength', 'Strength & Core',       3600,  NULL, 2),
    (v_week_id, 'Tue', 'swim',     'Race Pace Swim',        4200,  3.5,  4),
    (v_week_id, 'Wed', 'run',      'Tempo Run',             3600,  13.0, 4),
    (v_week_id, 'Thu', 'bike',     'Race Pace Intervals',   7200,  80.0, 4),
    (v_week_id, 'Fri', 'swim',     'Easy Swim',             2400,  1.8,  1),
    (v_week_id, 'Sat', 'bike',     'Peak Long Ride',        18000, 160.0,3),
    (v_week_id, 'Sun', 'run',      'Long Run',              9000,  25.0, 2);

  -- ── Week 11 – Build 2 ─────────────────────────────────────────────────────
  INSERT INTO plan_weeks (plan_id, week_number, phase, target_hours, notes)
  VALUES (v_plan_id, 11, 'Build 2', 14.5, 'Peak training week. Simulate race conditions.')
  RETURNING id INTO v_week_id;

  INSERT INTO planned_sessions (plan_week_id, day_of_week, discipline, title, target_duration_seconds, target_distance_km, training_zone)
  VALUES
    (v_week_id, 'Mon', 'rest',     'Rest Day',              NULL,  NULL, NULL),
    (v_week_id, 'Tue', 'swim',     'Threshold Swim',        4800,  3.8,  4),
    (v_week_id, 'Wed', 'run',      'Tempo Run',             3600,  14.0, 4),
    (v_week_id, 'Thu', 'bike',     'Race Sim Ride',         10800, 100.0,4),
    (v_week_id, 'Fri', 'swim',     'Easy Swim',             2400,  1.8,  1),
    (v_week_id, 'Sat', 'bike',     'Long Brick',            16200, 150.0,3),
    (v_week_id, 'Sun', 'run',      'Long Run',              9000,  26.0, 2);

  -- ── Week 12 – Recovery ────────────────────────────────────────────────────
  INSERT INTO plan_weeks (plan_id, week_number, phase, target_hours, notes)
  VALUES (v_plan_id, 12, 'Recovery', 7.0, 'Cutback week. Absorb the Build 2 stimulus.')
  RETURNING id INTO v_week_id;

  INSERT INTO planned_sessions (plan_week_id, day_of_week, discipline, title, target_duration_seconds, target_distance_km, training_zone)
  VALUES
    (v_week_id, 'Mon', 'rest',     'Rest Day',              NULL,  NULL, NULL),
    (v_week_id, 'Tue', 'swim',     'Easy Swim',             2400,  1.5,  1),
    (v_week_id, 'Wed', 'run',      'Easy Run',              2400,  8.0,  1),
    (v_week_id, 'Thu', 'bike',     'Recovery Spin',         3600,  45.0, 1),
    (v_week_id, 'Fri', 'rest',     'Rest Day',              NULL,  NULL, NULL),
    (v_week_id, 'Sat', 'run',      'Easy Long Run',         4200,  16.0, 1),
    (v_week_id, 'Sun', 'bike',     'Easy Ride',             7200,  70.0, 1);

  -- ── Week 13 – Build 3 ─────────────────────────────────────────────────────
  INSERT INTO plan_weeks (plan_id, week_number, phase, target_hours, notes)
  VALUES (v_plan_id, 13, 'Build 3', 13.5, 'Build 3 begins. Race-specific intensity.')
  RETURNING id INTO v_week_id;

  INSERT INTO planned_sessions (plan_week_id, day_of_week, discipline, title, target_duration_seconds, target_distance_km, training_zone)
  VALUES
    (v_week_id, 'Mon', 'rest',     'Rest Day',        NULL,  NULL, NULL),
    (v_week_id, 'Tue', 'swim',     'Race Pace Swim',  4200,  3.5,  4),
    (v_week_id, 'Wed', 'run',      'Tempo Run',       3600,  13.0, 4),
    (v_week_id, 'Thu', 'bike',     'Race Intervals',  7200,  80.0, 4),
    (v_week_id, 'Fri', 'swim',     'Easy Swim',       2400,  1.8,  1),
    (v_week_id, 'Sat', 'bike',     'Long Ride',       14400, 140.0,3),
    (v_week_id, 'Sun', 'run',      'Long Run',        8400,  24.0, 2);

  -- ── Week 14 – Build 3 ─────────────────────────────────────────────────────
  INSERT INTO plan_weeks (plan_id, week_number, phase, target_hours, notes)
  VALUES (v_plan_id, 14, 'Build 3', 14.0, 'High volume race-specific work.')
  RETURNING id INTO v_week_id;

  INSERT INTO planned_sessions (plan_week_id, day_of_week, discipline, title, target_duration_seconds, target_distance_km, training_zone)
  VALUES
    (v_week_id, 'Mon', 'strength', 'Core Work',        3600,  NULL, 2),
    (v_week_id, 'Tue', 'swim',     'Threshold Swim',   4800,  3.8,  4),
    (v_week_id, 'Wed', 'run',      'Tempo Run',        3600,  14.0, 4),
    (v_week_id, 'Thu', 'bike',     'VO2 Bike',         7200,  80.0, 5),
    (v_week_id, 'Fri', 'swim',     'Easy Swim',        2400,  1.8,  1),
    (v_week_id, 'Sat', 'bike',     'Race Sim Brick',   18000, 160.0,4),
    (v_week_id, 'Sun', 'run',      'Long Run',         9000,  25.0, 2);

  -- ── Week 15 – Build 3 ─────────────────────────────────────────────────────
  INSERT INTO plan_weeks (plan_id, week_number, phase, target_hours, notes)
  VALUES (v_plan_id, 15, 'Build 3', 14.5, 'Longest training week of the plan.')
  RETURNING id INTO v_week_id;

  INSERT INTO planned_sessions (plan_week_id, day_of_week, discipline, title, target_duration_seconds, target_distance_km, training_zone)
  VALUES
    (v_week_id, 'Mon', 'rest',     'Rest Day',         NULL,  NULL, NULL),
    (v_week_id, 'Tue', 'swim',     'Race Pace Swim',   5400,  4.0,  4),
    (v_week_id, 'Wed', 'run',      'Threshold Run',    4200,  15.0, 4),
    (v_week_id, 'Thu', 'bike',     'Race Pace Ride',   10800, 100.0,4),
    (v_week_id, 'Fri', 'swim',     'Easy Swim',        2400,  1.8,  1),
    (v_week_id, 'Sat', 'bike',     'Peak Brick',       19800, 170.0,3),
    (v_week_id, 'Sun', 'run',      'Long Run',         9600,  27.0, 2);

  -- ── Week 16 – Recovery ────────────────────────────────────────────────────
  INSERT INTO plan_weeks (plan_id, week_number, phase, target_hours, notes)
  VALUES (v_plan_id, 16, 'Recovery', 7.0, 'Third recovery week. Let the big training weeks land.')
  RETURNING id INTO v_week_id;

  INSERT INTO planned_sessions (plan_week_id, day_of_week, discipline, title, target_duration_seconds, target_distance_km, training_zone)
  VALUES
    (v_week_id, 'Mon', 'rest',  'Rest Day',        NULL, NULL, NULL),
    (v_week_id, 'Tue', 'swim',  'Easy Swim',       2400, 1.5,  1),
    (v_week_id, 'Wed', 'run',   'Easy Run',        2400, 8.0,  1),
    (v_week_id, 'Thu', 'bike',  'Recovery Spin',   3600, 45.0, 1),
    (v_week_id, 'Fri', 'rest',  'Rest Day',        NULL, NULL, NULL),
    (v_week_id, 'Sat', 'run',   'Easy Long Run',   4200, 16.0, 1),
    (v_week_id, 'Sun', 'bike',  'Easy Ride',       7200, 70.0, 1);

  -- ── Week 17 – Sharpening ──────────────────────────────────────────────────
  INSERT INTO plan_weeks (plan_id, week_number, phase, target_hours, notes)
  VALUES (v_plan_id, 17, 'Sharpening', 12.0, 'Race-specific sharpening. Quality over quantity.')
  RETURNING id INTO v_week_id;

  INSERT INTO planned_sessions (plan_week_id, day_of_week, discipline, title, target_duration_seconds, target_distance_km, training_zone)
  VALUES
    (v_week_id, 'Mon', 'rest',     'Rest Day',          NULL,  NULL, NULL),
    (v_week_id, 'Tue', 'swim',     'Race Pace Swim',    4200,  3.8,  4),
    (v_week_id, 'Wed', 'run',      'Race Pace Run',     3600,  13.0, 4),
    (v_week_id, 'Thu', 'bike',     'Race Pace Ride',    7200,  80.0, 4),
    (v_week_id, 'Fri', 'swim',     'Easy Swim',         2400,  1.8,  1),
    (v_week_id, 'Sat', 'bike',     'Long Ride',         14400, 130.0,3),
    (v_week_id, 'Sun', 'run',      'Long Run',          8400,  22.0, 2);

  -- ── Week 18 – Sharpening ──────────────────────────────────────────────────
  INSERT INTO plan_weeks (plan_id, week_number, phase, target_hours, notes)
  VALUES (v_plan_id, 18, 'Sharpening', 11.0, 'Final big swim week. Confidence building.')
  RETURNING id INTO v_week_id;

  INSERT INTO planned_sessions (plan_week_id, day_of_week, discipline, title, target_duration_seconds, target_distance_km, training_zone)
  VALUES
    (v_week_id, 'Mon', 'rest',     'Rest Day',          NULL,  NULL, NULL),
    (v_week_id, 'Tue', 'swim',     'Open Water Sim',    5400,  4.0,  3),
    (v_week_id, 'Wed', 'run',      'Tempo Run',         3600,  12.0, 4),
    (v_week_id, 'Thu', 'bike',     'Race Sim Ride',     10800, 100.0,4),
    (v_week_id, 'Fri', 'swim',     'Easy Swim',         2400,  1.8,  1),
    (v_week_id, 'Sat', 'bike',     'Long Brick',        14400, 130.0,3),
    (v_week_id, 'Sun', 'run',      'Long Run',          7200,  20.0, 2);

  -- ── Week 19 – Sharpening ──────────────────────────────────────────────────
  INSERT INTO plan_weeks (plan_id, week_number, phase, target_hours, notes)
  VALUES (v_plan_id, 19, 'Sharpening', 10.0, 'Begin reducing volume. Race sharpness maintained.')
  RETURNING id INTO v_week_id;

  INSERT INTO planned_sessions (plan_week_id, day_of_week, discipline, title, target_duration_seconds, target_distance_km, training_zone)
  VALUES
    (v_week_id, 'Mon', 'rest',  'Rest Day',         NULL,  NULL, NULL),
    (v_week_id, 'Tue', 'swim',  'Threshold Swim',   3600,  3.2,  4),
    (v_week_id, 'Wed', 'run',   'Race Pace Run',    3000,  10.0, 4),
    (v_week_id, 'Thu', 'bike',  'Race Pace Ride',   5400,  65.0, 4),
    (v_week_id, 'Fri', 'swim',  'Easy Swim',        2400,  1.5,  1),
    (v_week_id, 'Sat', 'bike',  'Long Ride',        10800, 100.0,3),
    (v_week_id, 'Sun', 'run',   'Long Run',         6300,  18.0, 2);

  -- ── Week 20 – Sharpening ──────────────────────────────────────────────────
  INSERT INTO plan_weeks (plan_id, week_number, phase, target_hours, notes)
  VALUES (v_plan_id, 20, 'Sharpening', 9.0, 'Last hard week. Race rehearsal on Saturday.')
  RETURNING id INTO v_week_id;

  INSERT INTO planned_sessions (plan_week_id, day_of_week, discipline, title, target_duration_seconds, target_distance_km, training_zone)
  VALUES
    (v_week_id, 'Mon', 'rest',  'Rest Day',          NULL,  NULL, NULL),
    (v_week_id, 'Tue', 'swim',  'Race Pace Swim',    3600,  3.0,  4),
    (v_week_id, 'Wed', 'run',   'Tempo Run',         3000,  10.0, 4),
    (v_week_id, 'Thu', 'bike',  'Race Pace Ride',    5400,  60.0, 4),
    (v_week_id, 'Fri', 'swim',  'Easy Swim',         1800,  1.2,  1),
    (v_week_id, 'Sat', 'bike',  'Race Rehearsal',    21600, 180.0,4),
    (v_week_id, 'Sun', 'run',   'Race Rehearsal Run',5400,  15.0, 4);

  -- ── Week 21 – Taper ───────────────────────────────────────────────────────
  INSERT INTO plan_weeks (plan_id, week_number, phase, target_hours, notes)
  VALUES (v_plan_id, 21, 'Taper', 8.0, 'Taper begins. Reduce volume 30%. Keep race-pace efforts short.')
  RETURNING id INTO v_week_id;

  INSERT INTO planned_sessions (plan_week_id, day_of_week, discipline, title, target_duration_seconds, target_distance_km, training_zone)
  VALUES
    (v_week_id, 'Mon', 'rest',  'Rest Day',        NULL,  NULL, NULL),
    (v_week_id, 'Tue', 'swim',  'Race Pace Swim',  3000,  2.5,  4),
    (v_week_id, 'Wed', 'run',   'Race Pace Run',   2400,  9.0,  4),
    (v_week_id, 'Thu', 'bike',  'Race Pace Ride',  4200,  50.0, 4),
    (v_week_id, 'Fri', 'swim',  'Easy Swim',       1800,  1.2,  1),
    (v_week_id, 'Sat', 'bike',  'Long Ride',       9000,  90.0, 3),
    (v_week_id, 'Sun', 'run',   'Long Run',        5400,  16.0, 2);

  -- ── Week 22 – Taper ───────────────────────────────────────────────────────
  INSERT INTO plan_weeks (plan_id, week_number, phase, target_hours, notes)
  VALUES (v_plan_id, 22, 'Taper', 6.5, 'Deep taper. Volume drops sharply. Trust your training.')
  RETURNING id INTO v_week_id;

  INSERT INTO planned_sessions (plan_week_id, day_of_week, discipline, title, target_duration_seconds, target_distance_km, training_zone)
  VALUES
    (v_week_id, 'Mon', 'rest',  'Rest Day',        NULL,  NULL, NULL),
    (v_week_id, 'Tue', 'swim',  'Short Race Pace', 2400,  2.0,  4),
    (v_week_id, 'Wed', 'run',   'Easy Run',        1800,  7.0,  2),
    (v_week_id, 'Thu', 'bike',  'Race Pace Ride',  3600,  40.0, 4),
    (v_week_id, 'Fri', 'swim',  'Easy Swim',       1800,  1.2,  1),
    (v_week_id, 'Sat', 'bike',  'Moderate Ride',   7200,  70.0, 3),
    (v_week_id, 'Sun', 'run',   'Easy Long Run',   3600,  12.0, 2);

  -- ── Week 23 – Taper ───────────────────────────────────────────────────────
  INSERT INTO plan_weeks (plan_id, week_number, phase, target_hours, notes)
  VALUES (v_plan_id, 23, 'Taper', 4.5, 'Race week prep. Short sharp sessions. Finalise logistics.')
  RETURNING id INTO v_week_id;

  INSERT INTO planned_sessions (plan_week_id, day_of_week, discipline, title, target_duration_seconds, target_distance_km, training_zone)
  VALUES
    (v_week_id, 'Mon', 'rest',  'Rest Day',          NULL, NULL, NULL),
    (v_week_id, 'Tue', 'swim',  'Activation Swim',   2400, 1.8,  3),
    (v_week_id, 'Wed', 'run',   'Easy Short Run',    1800, 6.0,  2),
    (v_week_id, 'Thu', 'bike',  'Activation Ride',   3600, 35.0, 3),
    (v_week_id, 'Fri', 'swim',  'Easy Swim',         1200, 0.8,  1),
    (v_week_id, 'Sat', 'bike',  'Short Spin',        2400, 25.0, 2),
    (v_week_id, 'Sun', 'rest',  'Rest & Travel',     NULL, NULL, NULL);

  -- ── Week 24 – Race Week ───────────────────────────────────────────────────
  INSERT INTO plan_weeks (plan_id, week_number, phase, target_hours, notes)
  VALUES (v_plan_id, 24, 'Race Week', 2.0, 'RACE WEEK! Minimal movement. Stay off your feet. Race on Sunday.')
  RETURNING id INTO v_week_id;

  INSERT INTO planned_sessions (plan_week_id, day_of_week, discipline, title, target_duration_seconds, target_distance_km, training_zone)
  VALUES
    (v_week_id, 'Mon', 'rest',  'Rest Day',            NULL, NULL, NULL),
    (v_week_id, 'Tue', 'swim',  'Easy Shake Out',      1200, 0.8,  1),
    (v_week_id, 'Wed', 'run',   'Easy Jog',            1200, 4.0,  1),
    (v_week_id, 'Thu', 'bike',  'Short Spin',          1800, 20.0, 1),
    (v_week_id, 'Fri', 'rest',  'Registration & Rest', NULL, NULL, NULL),
    (v_week_id, 'Sat', 'rest',  'Athlete Briefing',    NULL, NULL, NULL),
    (v_week_id, 'Sun', 'bike',  'IRONMAN WALES',       NULL, 226.0,4);

END $$;
