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

## Git operation routing

Use the cheapest available model for routine Git operations:

- git status
- git diff --stat
- git add
- git commit
- git push
- creating simple branch names
- writing conventional commit messages from an already-reviewed diff

Use Haiku for these tasks when available.

Do not use Opus for Git operations unless the Git state is complex or risky.

Escalate to Sonnet only when:
- merge conflicts exist
- rebase/cherry-pick fails
- history rewriting is requested
- commit splitting/squashing is needed
- the diff is large and commit grouping requires judgment
- sensitive files/secrets may be involved

Before committing:
1. inspect git status
2. inspect staged diff summary
3. confirm no secrets, generated junk, or unrelated files
4. ensure verification already passed or explicitly note it did not

Before pushing:
1. confirm branch name
2. confirm remote
3. confirm commit exists
4. do not force-push unless explicitly requested

## Skill routing

Before starting any non-trivial task, classify the task phase:

- Planning / PRD / requirements -> use PRD planning skill and architecture skill.
- Architecture / design decisions -> use architecture skill.
- Go implementation -> use Golang skill.
- Python implementation -> use Python skill.
- Review / PR quality -> use code-review skill.
- Debugging -> use systematic-debugging skill.
- Verification -> use test/verification skill.

If the required skill is unavailable, say so before continuing.

Do not implement before selecting the task phase, relevant skills, files to inspect, and verification plan.

For mixed tasks, use skills in sequence:

1. planning/architecture
2. language-specific implementation
3. verification
4. review

## Token discipline

Use the cheapest sufficient process.

Default behavior:
- Do not print large file contents.
- Do not summarize obvious code.
- Do not explain every command.
- Do not produce long reasoning traces.
- Prefer diffs, file paths, and concise findings.
- Inspect targeted symbols/files before broad search.
- Run affected tests before full test suite when safe.
- Escalate verification only if affected tests pass or risk requires full suite.
- Stop after two repeated failures with the same root cause.
- Keep final response to changed files, verification result, and real risks.

For trivial changes, skip formal planning.
For small changes, use a compact plan.
For medium/large changes, use the full engineering loop.

## Subagent model routing

The main session's model is fixed at session start. Subagents (`Agent(...)` tool) are the only place inside a running session where the model can actually be chosen, so always pass an explicit `model:` override on every subagent spawn — never rely on inheritance from the main session.

Pick `model:` from the task phase, mirroring the rules above:

- `model: "haiku"` — doc edits, formatting, boilerplate scaffolding, trivial test generation, log/diff summarization, simple file lookups, routine Git operations (status, diff, add, commit, push, conventional commit message drafting from a reviewed diff), simple branch naming.
- `model: "sonnet"` — normal implementation, refactoring, test writing, debugging with clear failure signals, code review, broad codebase exploration (Explore agent), most general-purpose research.
- `model: "opus"` — complex architecture decisions, hard debugging after Sonnet has already failed, large ambiguous refactors, security-sensitive reasoning, cross-system design tradeoffs. Before spawning an Opus subagent, state in the spawning message: (1) why Sonnet is insufficient, (2) what evidence justifies escalation, (3) the bounded task for Opus.

Special cases:

- `claude-code-guide` agent → Haiku (doc/reference lookups).
- `Explore` agent → Sonnet by default; Haiku only for a single trivial file lookup.
- `Plan` / `senior-architect` work → Sonnet; Opus only when tradeoffs are genuinely cross-system.
- Git operations delegated to subagents → Haiku unless the state is complex (merge conflicts, history rewrite, commit splitting, large/risky diffs) → then Sonnet.

When unsure between two tiers, pick the cheaper one and escalate only on failure. Never default to Opus for routine work.

### Delegation-first workflow

The main session's model is whatever the session was launched on. To honor the routing rules above *inside* a running session, prefer delegating to a subagent over doing the work on the main thread whenever a cheaper model would suffice.

On every user request, before acting:

1. **Classify the task phase** (planning, implementation, refactor, debug, review, doc edit, Git op, exploration, architecture).
2. **Pick the target model** per the routing rules above.
3. **If the target model is cheaper than the main-session model**, delegate the work to an `Agent(...)` call with explicit `model:` set to the target. Brief the subagent self-containedly (it doesn't see this conversation).
4. **Stay on the main thread only when** the request is trivial conversational (greeting, clarifying question, single-sentence answer), the main session is already on the correct tier, or the task is small enough that the delegation overhead exceeds the savings (rule of thumb: < ~3 tool calls of work).
5. **Compose for mixed tasks**: delegate the parts that fit a cheaper model (e.g. doc edit, Git ops, scaffolding) even when the harder parts stay on the main thread. Don't bundle everything onto the main model just because one piece needs it.

When delegating, name the agent type (`Explore`, `general-purpose`, `claude-code-guide`, `Plan`, etc.) and the `model:` together. Treat the choice of agent type and the choice of model as two independent decisions.

@RTK.md
# graphify
- **graphify** - any input to knowledge graph. Trigger: `/graphify`
When the user types `/graphify`, use the installed graphify skill or instructions before doing anything else.
