# Claude Code instructions

Claude-Code-specific routing on top of the tool-agnostic rules below.

@AGENTS.md

## Model routing

Default model: Sonnet.

Use Haiku for:

- verifier (lint + tests)
- companion-reviewer when the diff is under ~50 lines
- simple boilerplate
- documentation edits
- formatting-only changes
- trivial test generation
- summarizing logs or diffs
- one-file lookups
- routine Git operations (see AGENTS.md)

Use Sonnet for:

- implementers (Go / Python / IaC)
- companion-reviewer on larger diffs
- principal-reviewer
- architect-planner
- explorer (broad)
- refactoring
- debugging with clear failure signals

Use Opus only for:

- complex architecture decisions
- hard debugging after Sonnet fails
- large ambiguous refactors
- security-sensitive reasoning
- cross-system design tradeoffs

Before escalating to Opus, state:

1. why Sonnet is insufficient
2. what evidence justifies escalation
3. expected bounded task for Opus

Never use Opus for routine edits, formatting, boilerplate, Git, or Explore.
Never use Opus for verifier.

Git operation routing (see AGENTS.md) maps to Haiku for the routine ops list,
Sonnet for the escalation cases -- never Opus for Git unless the Git state is
complex or risky.

## Subagent model routing

The main session's model is fixed at session start. Subagents (`Agent(...)`)
are the only place inside a running session where the model can actually be
chosen, so always pass an explicit `model:` override on every spawn -- never
rely on inheritance.

Use the named agents in `~/.claude/agents/` when they match:

- `go-implementer` / `python-implementer` / `infra-implementer` → sonnet
- `explorer` → sonnet (haiku for a single trivial file lookup)
- `architect-planner` → sonnet
- `companion-reviewer` → haiku if diff < ~50 lines, else sonnet
- `principal-reviewer` → sonnet
- `verifier` → haiku

Special cases:

- `claude-code-guide` → haiku
- built-in `Explore` → sonnet default; haiku for one-file lookup. Prefer the
  named `explorer` agent (compressed contract).
- Git delegated to a subagent → haiku unless complex (conflicts, history
  rewrite, commit splitting, large/risky diffs) → then sonnet. Prefer main
  thread for 3-command git; do not spawn.

When unsure between two tiers, pick the cheaper one and escalate only on
failure. Never default to Opus for routine work.

### Isolation-first workflow

On every user request, before acting:

1. Classify via `eng-phase` (planning, implementation, explore, review, docs,
   Git, loop-eng).
2. Spawn the named agent with explicit `model:`. Brief it self-containedly
   (slice text + `git diff -- <paths>`). No file dumps.
3. Implementation is never "done" after the implementer returns. Run the
   inner loop in AGENTS.md (verifier → companion → cap 3 → principal).
4. Stay on the main thread only for grilling, one-sentence Q&A, or 3-command
   git.

Main transcript: path +N/-N, verifier pass/fail, companion totals, principal
summary. Use `/ide` so hunks open in the editor, not the TUI. Do not restate
diffs in prose.

@RTK.md
