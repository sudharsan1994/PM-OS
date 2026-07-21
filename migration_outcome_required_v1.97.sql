-- v1.97 — Conditional mandatory outcome
-- Applied to Supabase project vjbmbopacigotjdogxqg via MCP on 2026-07-20
-- (migration name: add_outcome_required_flag)
-- Safe to re-run.
--
-- outcome_required is nullable ON PURPOSE:
--   true  = must log an outcome + impact at completion (could move a customer / North Star)
--   false = optional (reactive or internal task) — just mark done
--   null  = not classified yet; the completion modal falls back to is_deep_work

alter table tasks add column if not exists outcome_required boolean;
