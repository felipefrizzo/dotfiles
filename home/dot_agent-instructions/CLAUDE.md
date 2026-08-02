# Claude Code instructions

Claude-Code-specific routing on top of the tool-agnostic rules below.

@AGENTS.md

## Model routing

Default model: Sonnet.

Use Haiku for:

- simple boilerplate
- documentation edits
- formatting-only changes
- trivial test generation
- summarizing logs or diffs

Use Sonnet for:

- normal implementation
- refactoring
- test writing
- debugging with clear failure signals
- code review

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

Never use Opus for routine edits, formatting, boilerplate, or broad exploration.
Minimize output tokens. Prefer concise plans, diffs, and test results.

Git operation routing (see AGENTS.md) maps to Haiku for the routine ops list,
Sonnet for the escalation cases -- never Opus for Git operations unless the
Git state is complex or risky.

## Subagent model routing

The main session's model is fixed at session start. Subagents (`Agent(...)`
tool) are the only place inside a running session where the model can
actually be chosen, so always pass an explicit `model:` override on every
subagent spawn -- never rely on inheritance from the main session.

Pick `model:` from the task phase, mirroring the rules above:

- `model: "haiku"` -- doc edits, formatting, boilerplate scaffolding, trivial test generation, log/diff summarization, simple file lookups, routine Git operations (status, diff, add, commit, push, conventional commit message drafting from a reviewed diff), simple branch naming.
- `model: "sonnet"` -- normal implementation, refactoring, test writing, debugging with clear failure signals, code review, broad codebase exploration (Explore agent), most general-purpose research.
- `model: "opus"` -- complex architecture decisions, hard debugging after Sonnet has already failed, large ambiguous refactors, security-sensitive reasoning, cross-system design tradeoffs. Before spawning an Opus subagent, state in the spawning message: (1) why Sonnet is insufficient, (2) what evidence justifies escalation, (3) the bounded task for Opus.

Special cases:

- `claude-code-guide` agent -> Haiku (doc/reference lookups).
- `Explore` agent -> Sonnet by default; Haiku only for a single trivial file lookup.
- `Plan` / `senior-architect` work -> Sonnet; Opus only when tradeoffs are genuinely cross-system.
- Git operations delegated to subagents -> Haiku unless the state is complex (merge conflicts, history rewrite, commit splitting, large/risky diffs) -> then Sonnet.

When unsure between two tiers, pick the cheaper one and escalate only on failure. Never default to Opus for routine work.

### Delegation-first workflow

The main session's model is whatever the session was launched on. To honor
the routing rules above *inside* a running session, prefer delegating to a
subagent over doing the work on the main thread whenever a cheaper model
would suffice.

On every user request, before acting:

1. **Classify the task phase** (planning, implementation, refactor, debug, review, doc edit, Git op, exploration, architecture).
2. **Pick the target model** per the routing rules above.
3. **If the target model is cheaper than the main-session model**, delegate the work to an `Agent(...)` call with explicit `model:` set to the target. Brief the subagent self-containedly (it doesn't see this conversation).
4. **Stay on the main thread only when** the request is trivial conversational (greeting, clarifying question, single-sentence answer), the main session is already on the correct tier, or the task is small enough that the delegation overhead exceeds the savings (rule of thumb: < ~3 tool calls of work).
5. **Compose for mixed tasks**: delegate the parts that fit a cheaper model (e.g. doc edit, Git ops, scaffolding) even when the harder parts stay on the main thread. Don't bundle everything onto the main model just because one piece needs it.

When delegating, name the agent type (`Explore`, `general-purpose`, `claude-code-guide`, `Plan`, etc.) and the `model:` together. Treat the choice of agent type and the choice of model as two independent decisions.

@RTK.md
