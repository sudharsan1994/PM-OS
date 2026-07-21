-- v1.95 — Claude Executor queue columns
-- Applied to Supabase project vjbmbopacigotjdogxqg via MCP on 2026-07-19
-- (migration name: add_claude_executor_queue_columns)
-- Safe to re-run.

alter table tasks
  add column if not exists claude_status text,   -- queued | running | done | needs_input | failed
  add column if not exists claude_result text,   -- Claude's output / review comments / draft / questions
  add column if not exists claude_error text,     -- failure reason (only when claude_status='failed')
  add column if not exists claude_run_at timestamptz;  -- when the executor last picked it up
