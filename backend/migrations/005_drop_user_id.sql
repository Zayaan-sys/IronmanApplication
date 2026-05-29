-- Migration 005: Remove user_id from plans and sessions
-- Run this if you created the tables using the old schema.sql (which had user_id).
-- After this, re-run 004_seed_ironman_wales_plan.sql.

ALTER TABLE plans    DROP COLUMN IF EXISTS user_id CASCADE;
ALTER TABLE sessions DROP COLUMN IF EXISTS user_id CASCADE;

-- Also disable RLS since there are no longer any user-based policies needed
ALTER TABLE sessions         DISABLE ROW LEVEL SECURITY;
ALTER TABLE plans            DISABLE ROW LEVEL SECURITY;
ALTER TABLE plan_weeks       DISABLE ROW LEVEL SECURITY;
ALTER TABLE planned_sessions DISABLE ROW LEVEL SECURITY;

-- Drop the old RLS policies if they exist
DROP POLICY IF EXISTS "users see own sessions"          ON sessions;
DROP POLICY IF EXISTS "users see own plans"             ON plans;
DROP POLICY IF EXISTS "users see own plan weeks"        ON plan_weeks;
DROP POLICY IF EXISTS "users see own planned sessions"  ON planned_sessions;
