-- Migration 002: No RLS needed
-- This is a single-device app with no user accounts.
-- The backend connects via the service role key which bypasses RLS anyway.
-- No policies required.

-- If you later add multi-user support, this is where RLS policies would go.
SELECT 'No RLS configured — single-device app' AS info;
