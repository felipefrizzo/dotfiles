# Agent instructions

Tool-agnostic rules, shared across every AI coding agent (Claude Code, Codex,
Copilot CLI, ...). Claude-Code-specific routing (model tiers, subagent
spawning) lives in `CLAUDE.md`, which imports this file.

## Skill routing

Before starting any non-trivial task, classify the task phase and use the
matching skill if it's installed for this agent:

- Planning / PRD / requirements -> `prd` skill, then `senior-architect` for design.
- Architecture / design decisions -> `senior-architect` skill.
- Go implementation -> `golang-pro` skill.
- Python implementation -> `python-pro` skill.
- Review / PR quality -> `code-review` skill.
- Debugging -> `diagnosing-bugs` skill.
- Verification / test-first work -> `tdd` skill.

If the required skill is unavailable for this agent, say so before continuing
instead of silently skipping it.

Do not implement before selecting the task phase, relevant skills, files to
inspect, and verification plan.

For mixed tasks, use skills in sequence:

1. planning/architecture
2. language-specific implementation
3. verification
4. review

## Git operation routing

Use the fastest/cheapest model tier this agent has available for routine Git
operations:

- git status
- git diff --stat
- git add
- git commit
- git push
- creating simple branch names
- writing conventional commit messages from an already-reviewed diff

Escalate to the default/main tier only when:
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

## RTK CLI

`rtk` is a token-optimized CLI proxy (60-90% savings on dev operations). See
`RTK.md` for the command reference. On Claude Code it's auto-loaded via
`CLAUDE.md`'s `@RTK.md` import and commands are auto-rewritten by a hook; on
other agents, invoke `rtk` directly (e.g. `rtk gain`, `rtk discover`) and open
`RTK.md` manually when needed -- there's no automatic hook rewrite outside
Claude Code.

# graphify

- **graphify** - any input to knowledge graph. Trigger: `/graphify`

When the user types `/graphify`, use the installed graphify skill or
instructions before doing anything else.
