-- Migration 001: Create core tables
-- Run this first in Supabase SQL Editor
-- Single-device app: no user_id or auth required

CREATE TABLE IF NOT EXISTS plans (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name        TEXT NOT NULL,
  race_name   TEXT,
  race_date   DATE,
  total_weeks INT NOT NULL,
  start_date  DATE NOT NULL,
  is_active   BOOLEAN DEFAULT TRUE,
  created_at  TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS plan_weeks (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  plan_id     UUID NOT NULL REFERENCES plans(id) ON DELETE CASCADE,
  week_number INT NOT NULL,
  phase       TEXT NOT NULL,
  target_hours NUMERIC(4, 1),
  notes       TEXT
);

CREATE TABLE IF NOT EXISTS planned_sessions (
  id                     UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  plan_week_id           UUID NOT NULL REFERENCES plan_weeks(id) ON DELETE CASCADE,
  day_of_week            TEXT NOT NULL CHECK (day_of_week IN ('Mon','Tue','Wed','Thu','Fri','Sat','Sun')),
  discipline             TEXT NOT NULL CHECK (discipline IN ('swim','bike','run','strength','rest')),
  title                  TEXT,
  description            TEXT,
  target_distance_km     NUMERIC(6, 2),
  target_duration_seconds INT,
  training_zone          INT CHECK (training_zone BETWEEN 1 AND 5)
);

CREATE TABLE IF NOT EXISTS sessions (
  id                 UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  discipline         TEXT NOT NULL CHECK (discipline IN ('swim','bike','run','strength')),
  title              TEXT,
  session_date       DATE NOT NULL DEFAULT CURRENT_DATE,
  duration_seconds   INT,
  distance_km        NUMERIC(6, 2),
  avg_hr             INT,
  avg_pace           TEXT,
  training_zone      INT CHECK (training_zone BETWEEN 1 AND 5),
  feeling            INT CHECK (feeling BETWEEN 0 AND 4),
  notes              TEXT,
  plan_week          INT,
  planned_session_id UUID REFERENCES planned_sessions(id) ON DELETE SET NULL,
  created_at         TIMESTAMPTZ DEFAULT NOW()
);
