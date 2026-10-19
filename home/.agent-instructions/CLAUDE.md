# Claude Code instructions

Claude-Code-specific routing on top of the tool-agnostic rules below.

@AGENTS.md

## Model routing

Default model: Sonnet.

Pass `model: haiku`. The Agent tool rejects a versioned id such as `claude-haiku-5-5`. On the Anthropic API the alias is Haiku 5.5.

Spawn Haiku 5.5 for:

- `verifier`
- `explorer`
- `companion-reviewer` when the diff is under ~200 lines
- `git-operator` for routine `git`, `gh`, and `glab` / `gl`
- `claude-code-guide`
- boilerplate, documentation edits, formatting-only changes, trivial test generation
- summarizing logs or diffs
- debugging when the failure signal is already clear

Use Sonnet for:

- implementers (Go / Python / IaC)
- `companion-reviewer` when the diff is over ~200 lines
- `principal-reviewer`
- `architect-planner`
- `explorer` after a Haiku locate failed, or a hunt that crosses repos
- refactoring
- debugging when the failure signal is ambiguous
- `git` / `gh` / `glab` escalation: conflicts, rebase, history rewrite, commit split or squash, secrets, auth failure, remote URL change

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

Never use Opus for routine edits, formatting, boilerplate, Git, `gh`, `glab`, or Explore.
Never use Opus for verifier.

## Subagent model routing

The main session's model is fixed at session start. Subagents (`Agent(...)`)
are the only place inside a running session where the model can actually be
chosen, so always pass an explicit `model:` override on every spawn -- never
rely on inheritance. Pass `haiku`, not a versioned model id.

Use the named agents in `~/.claude/agents/` when they match:

- `go-implementer` / `python-implementer` / `infra-implementer` → sonnet
- `explorer` → `haiku` (sonnet after a failed locate or a cross-repo hunt)
- `architect-planner` → sonnet
- `companion-reviewer` → `haiku` if diff < ~200 lines, else sonnet
- `principal-reviewer` → sonnet
- `verifier` → `haiku`
- `git-operator` → `haiku`

Special cases:

- `claude-code-guide` → `haiku`
- built-in `Explore` → `haiku`. Prefer the named `explorer` agent.
- Routine `git`, `gh`, and `glab` / `gl` → `git-operator`. Sonnet only for the escalation list above.

When unsure between two tiers, pick the cheaper one and escalate only on
failure. Never default to Opus for routine work.

### Isolation-first workflow

On every user request, before acting:

1. Classify via `eng-phase` (planning, implementation, explore, review, docs,
   Git, loop-eng).
2. Spawn the named agent with explicit `model:`. Brief it self-containedly
   (slice text + `git diff -- <paths>`). No file dumps.
3. Implementation is never "done" after the implementer returns. Inner
   loop in AGENTS.md. After tickets, `/loop run` may wrap it; then skip
   the verifier subagent (the script owns the test command).
4. Stay on the main thread only for grilling and one-sentence Q&A. Routine
   `git`, `gh`, and `glab` / `gl` spawn `git-operator`. `/implement` uses
   the AGENTS.md contract, not the mattpocock skill body.

Main transcript: path +N/-N, verifier pass/fail, companion totals, principal
summary. Use `/ide` so hunks open in the editor, not the TUI. Do not restate
diffs in prose.

@RTK.md
