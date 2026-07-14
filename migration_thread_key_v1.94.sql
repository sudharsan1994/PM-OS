-- PM-OS v1.94 — thread-level dedup
-- Fixes: tasks the user deleted/marked-noise/delegated reappear when a NEW message
-- lands in the same thread. Root cause: dedup keyed only on the per-message source.
-- thread_key groups all messages of one conversation so the scanner can judge whether
-- a new message is a continuation of a dismissed thread (suppress) or a genuinely new ask.
--
-- Safe to run more than once (IF NOT EXISTS guards). Run in Supabase SQL editor.

ALTER TABLE tasks ADD COLUMN IF NOT EXISTS thread_key text;

-- Speeds up the import-time dedup lookup and the dismissed-threads export.
CREATE INDEX IF NOT EXISTS idx_tasks_thread_key ON tasks (thread_key);

-- Backfill Teams threads from existing sources so history is covered immediately.
-- Teams source shape: teams:///chats/<chatId>/messages/<messageId>
-- Extract <chatId> and store as 'teams-chat:<chatId>'. Email/other rows stay NULL
-- (no conversationId is recoverable from the stored Outlook web link — the scanner
-- fills thread_key going forward).
UPDATE tasks
SET thread_key = 'teams-chat:' || substring(source from 'chats/([^/]+)/messages')
WHERE thread_key IS NULL
  AND source LIKE 'teams:///chats/%/messages/%';
