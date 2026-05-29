-- Run this in your Supabase SQL Editor to set up the database schema

-- Training sessions logged by the user
CREATE TABLE IF NOT EXISTS sessions (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id     UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  discipline  TEXT NOT NULL CHECK (discipline IN ('swim', 'bike', 'run', 'strength')),
  title       TEXT,
  session_date DATE NOT NULL DEFAULT CURRENT_DATE,
  duration_seconds INT,          -- total duration in seconds
  distance_km NUMERIC(6, 2),
  avg_hr      INT,
  avg_pace    TEXT,              -- stored as "mm:ss/km" or "km/h"
  training_zone INT CHECK (training_zone BETWEEN 1 AND 5),
  feeling     INT CHECK (feeling BETWEEN 0 AND 4),  -- 0=drained 4=epic
  notes       TEXT,
  plan_week   INT,               -- which plan week this belongs to
  planned_session_id UUID,       -- optional link to a planned session
  created_at  TIMESTAMPTZ DEFAULT NOW()
);

-- Training plan (one active plan per user)
CREATE TABLE IF NOT EXISTS plans (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id     UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  name        TEXT NOT NULL,
  race_name   TEXT,
  race_date   DATE,
  total_weeks INT NOT NULL,
  start_date  DATE NOT NULL,
  is_active   BOOLEAN DEFAULT TRUE,
  created_at  TIMESTAMPTZ DEFAULT NOW()
);

-- Individual weeks within a plan
CREATE TABLE IF NOT EXISTS plan_weeks (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  plan_id     UUID NOT NULL REFERENCES plans(id) ON DELETE CASCADE,
  week_number INT NOT NULL,
  phase       TEXT NOT NULL,    -- e.g. 'Base Building', 'Build 1', 'Taper'
  target_hours NUMERIC(4, 1),
  notes       TEXT
);

-- Planned sessions within a week
CREATE TABLE IF NOT EXISTS planned_sessions (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  plan_week_id UUID NOT NULL REFERENCES plan_weeks(id) ON DELETE CASCADE,
  day_of_week TEXT NOT NULL CHECK (day_of_week IN ('Mon','Tue','Wed','Thu','Fri','Sat','Sun')),
  discipline  TEXT NOT NULL CHECK (discipline IN ('swim', 'bike', 'run', 'strength', 'rest')),
  title       TEXT,
  description TEXT,
  target_distance_km NUMERIC(6, 2),
  target_duration_seconds INT,
  training_zone INT CHECK (training_zone BETWEEN 1 AND 5)
);

-- Row-level security — users can only see their own data
ALTER TABLE sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE plans ENABLE ROW LEVEL SECURITY;
ALTER TABLE plan_weeks ENABLE ROW LEVEL SECURITY;
ALTER TABLE planned_sessions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "users see own sessions" ON sessions
  FOR ALL USING (auth.uid() = user_id);

CREATE POLICY "users see own plans" ON plans
  FOR ALL USING (auth.uid() = user_id);

CREATE POLICY "users see own plan weeks" ON plan_weeks
  FOR ALL USING (
    plan_id IN (SELECT id FROM plans WHERE user_id = auth.uid())
  );

CREATE POLICY "users see own planned sessions" ON planned_sessions
  FOR ALL USING (
    plan_week_id IN (
      SELECT pw.id FROM plan_weeks pw
      JOIN plans p ON pw.plan_id = p.id
      WHERE p.user_id = auth.uid()
    )
  );
