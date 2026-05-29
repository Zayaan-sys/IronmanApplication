-- Migration 003: Performance indexes
-- Run this third in Supabase SQL Editor

-- Dashboard: fetch all sessions for a user ordered by date
CREATE INDEX IF NOT EXISTS idx_sessions_user_date
  ON sessions (user_id, session_date DESC);

-- Weekly breakdown: filter sessions by user + plan week
CREATE INDEX IF NOT EXISTS idx_sessions_user_week
  ON sessions (user_id, plan_week);

-- Find a user's active plan quickly
CREATE INDEX IF NOT EXISTS idx_plans_user_active
  ON plans (user_id, is_active);

-- Load all weeks for a plan in order
CREATE INDEX IF NOT EXISTS idx_plan_weeks_plan_number
  ON plan_weeks (plan_id, week_number);

-- Load all planned sessions for a week
CREATE INDEX IF NOT EXISTS idx_planned_sessions_week
  ON planned_sessions (plan_week_id);
