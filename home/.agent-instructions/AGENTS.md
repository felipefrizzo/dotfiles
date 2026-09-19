# Agent instructions

Tool-agnostic rules, shared across every AI coding agent (Claude Code, Codex,
Copilot CLI, Cursor, ...). Claude-Code-specific model tiers live in `CLAUDE.md`,
which imports this file.

## Engineering principles

- Choose the simplest implementation that fully meets the current
  requirement. Avoid speculative abstractions, configuration, or indirection
  for needs that don't exist yet.
- Grow the system in layers: get the smallest end-to-end version working,
  then add each new capability on top of a product that already works.
  Never trade a working product for unfinished complexity.
- Lean on dependencies already in the project before writing your own
  implementation or adding a package. Don't assume a library lacks a
  capability without checking its docs/types first.
- Default to no comments, in any language. Self-explanatory naming and
  structure is the bar, not commentary. Unexported/private functions and
  internal helpers should never carry explanatory comments -- if one seems
  needed, that's a signal to rename or restructure, not to document the
  confusion. Only write a comment when it captures a non-obvious WHY (a
  hidden constraint, a workaround for a specific bug, a subtle invariant)
  that naming and structure genuinely cannot express. Public/exported APIs
  may carry doc comments where the language convention expects them (e.g.
  Go exported identifiers, public library entry points). This applies to
  every agent and every delegated/subagent task, not just the main
  session -- when delegating implementation work, carry this rule into the
  subagent prompt explicitly, since subagents don't inherit memory.

## Isolation-first

Main thread orchestrates. It does not do noisy work.

Main may: grill, pick the next agent, ask a decision, report the contract, stop.

Main must not: read large files, dump grep, run test suites, apply multi-file
edits, paste diffs into the reply.

Stay on main only for grilling (needs user answers), one-sentence Q&A, or
3-command git. Isolation first, then cheapest model that can do the child job.

Load `eng-phase` at the start of every non-trivial request (model-invoked).

## Aliases

Marketplace `senior-*` skill folders are gone. The names still work:

- `senior-architect` during planning / design → `architect-planner`
- `senior-architect review` / `senior-backend review` / `senior-* review` /
  "review recent changes" → `principal-reviewer`
- `senior-backend` implement → `python-implementer` or `go-implementer`
  from the files in the diff
- `/implement` → named implementer inner loop + git contract below.
  Ignore the mattpocock skill body (tests on main, `/code-review`, commit
  from the skill).

## Skill / agent routing

Classify the phase, then spawn. Do not implement on the main thread.

1. New work / design / grilling → `grilling` on main. After the user confirms
   shared understanding → spawn `architect-planner`. Do not wait for `/to-spec`.
2. Go → `go-implementer` (`golang-pro` + `use-modern-go`). Then inner loop.
3. Python → `python-implementer` (`python-pro`; `fastapi-expert` if FastAPI).
   Then inner loop.
4. Terraform / k8s / CI → `infra-implementer`. Then inner loop.
5. "Where is X" → `explorer` (path:line contract, not an essay).
6. Docs / READMEs / ADRs / user-facing prose → `humanizer` after the draft.
   Not for source comments.
7. Debug → `diagnosing-bugs` (via explorer + implementer inner loop as needed).
8. Open-ended machine-checkable grind → loop-eng (`/loop new` then `/loop run`).
   Not the inner loop. Not `loop-me`. Not Cursor `/loop`.

If a required skill is unavailable, say so before continuing.

Medium/large implementation without an assertive plan (locked decisions, exact
files, verifier command, first slice): implementers refuse.

Trivial 1-line known-path fix: skip grilling and `architect-planner`. Still run
verifier + companion. Skip principal.

Carry the no-comment rule in every implementer spawn prompt.

## `/implement` contract

Slash `/implement` after plan/spec/tickets. Main orchestrates. Implementers
do not git.

1. **One branch** from `master`/`main` for the whole ticket set. Reuse the
   branch if this work already has one. Do not open a branch per ticket.
2. **One ticket at a time.** Matching named implementer (one slice) → inner
   loop. Implementer may load `tdd` at the plan's seams. Verifier owns
   typecheck/tests. Companion per slice. Cap 3.
3. **Commit per ticket** on main thread, only after the test gate is green
   and companion has no red. Conventional commit. Do not commit a red
   slice. Do not squash tickets together. Do not commit the env file,
   secrets, or unrelated junk. Inside loop-eng: defer all commits until
   `run_loop.mjs check` is `success`, then one commit per ticket by that
   ticket's paths. Committing on a failing full-suite check makes a clean
   tree look like no-progress.
4. Next ticket on the same branch.
5. After the last ticket (or loop success): `principal-reviewer` (skip on a
   1-line fix). Then `git push -u` and `gh pr create`.
6. **GitHub token:** `set -a; . <env-file the user named>; set +a`. Prefer
   `GH_TOKEN`, else `GITHUB_TOKEN`. Never print, echo, or log the file.
   Never commit it. Never copy it into the repo. If the path was not given
   this session, stop and ask. On `gh` auth failure: stop; do not change
   git remotes.

`/code-review` after `/implement` → `principal-reviewer`, not the mattpocock
review skill on main.

## Implement inner loop

Maker and checker are different agents. Implementer does not review itself.
Companion does not edit. Verifier does not design. Verifier owns lint/tests;
implementer does not re-run the suite.

After every implementer spawn:

1. Spawn `verifier` (Haiku). Fail → same implementer with the verifier output.
   Do not review red tests.
2. Pass → spawn `companion-reviewer` (Haiku if diff under ~50 lines, else
   Sonnet). Red or slice-creep → implementer again. Yellow: fix if cheap,
   else record and continue.
3. Repeat until companion has no red and verifier passes, or **cap 3** on
   the same slice.
4. Cap hit → stop. Report last fail. No fourth attempt.
5. All slices green → spawn `principal-reviewer` once (Standards + Spec vs
   the assertive plan; `security-audit` if auth/input/secrets/cloud IAM).
6. Principal red → one more inner-loop pass, then principal again. Second
   principal red → escalate to the user.

Spawn payload: slice text + `git diff -- <paths>`. No file dumps. No
implementer narrative to companion.

Main reports: slice name, iteration count, verifier pass/fail, companion
totals, principal summary. Path +N/-N only. No diffs, no test logs.
Claude Code: `/ide` for hunks.

When loop-eng wraps `/implement`, skip the verifier subagent. The script
owns that command. Still spawn implementer + companion. Still no file dumps.

## loop-eng after tickets

Human stays in: grill, plan, `/to-spec`, `/to-tickets`. After tickets exist,
`/loop new` then `/loop run` may own the rest. The loop does **not** replace
named agents. Each act still classifies via `eng-phase` and spawns.

LOOP_SPEC (must `lint_spec.mjs` exit 0):

- **Goal** — remaining tickets executed per `/implement` (one branch, named
  implementers, companion, commit-per-ticket after success, PR after
  principal).
- **Verification** — the assertive plan's one command. Not "looks done".
- **Termination** — success = verify 0; max iterations default `3 * ticket
  count` (min 8); no-progress = 2 identical verify + unchanged working tree.
- **Scope** — plan file list. Forbidden: env/token files, `terraform apply`,
  editing tests only to force a pass.
- **Escalation** — companion red after 3 acts on the same ticket; principal
  second red; secrets; apply. Stop, wait.

Do not run a second test grind on the same command (no verifier subagent +
loop-eng `check` both driving `go test`). Do not `/loop` grilling or "make
it better" with no machine check. Do not mix `loop-me` or Cursor `/loop`
with this.

## Three loops — do not mix

- `loop-me` — grill a human workflow spec into `workflows/*.md`. Not coding.
- Cursor `/loop` — timer to re-run a prompt (CI watch, deploy poll). Not coding.
- loop-eng — autonomous coding loop. After tickets, wraps `/implement`.
  Also valid alone for lint-until-clean. Commands: `/loop init|new|harden|verify|run|status`.
  CLI: `loop-verify`, `loop-run`, `loop-audit`, `loop-cost`.

## Token budget

Isolation protects main context; it does not cut the bill. Spend less:

- Tests once (verifier). Fail output: first failing names + last ~30 lines.
- Children get diffs and slice text, not `cat` of whole files.
- Haiku: verifier, one-file lookup, conventional commit from a reviewed diff,
  companion under ~50 lines. Sonnet: implementers, larger companion, principal,
  architect-planner. Opus: only after Sonnet failed, with why / evidence /
  bounded task. Never Opus for Explore or Git.
- No subagent for 3-command git. Cap 3. Skip principal on 1-line fixes.
- Skill bodies stay on disk. Follow "load when" tables. Do not paste SKILL.md.
- Shell through `rtk` when available. Affected-package tests, not `./...`
  unless risk requires the full suite.
- Unrelated next task → `/clear` or a new chat, not compact-and-continue.
- Caveman on main replies only. Code in files stays normal.

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
- a git/SSH auth failure occurs or a remote URL/protocol change is being considered

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

### Git remote / auth safety

Never change a remote's protocol (`ssh://`/`git@...` <-> `https://`) or URL to
work around an auth failure. That's a silent security-relevant change, not a
fix -- it can bypass SSH-agent-based auth (e.g. 1Password SSH agent gating
the key with a passphrase prompt) and switch to a different credential path
entirely. Treat `git remote set-url`, editing `.git/config`'s remote section,
or editing `~/.ssh/config` as requiring explicit user approval every time,
regardless of task phase or model tier.

On a git auth failure (SSH handshake fails, agent has no identities, HTTPS
prompts for credentials, etc.):
1. Retry once as-is -- SSH agent locks/timeouts are often transient (e.g.
   1Password needs to be unlocked or the prompt approved).
2. If it fails again, stop. Report the exact error. Ask the user to
   unlock/approve the agent or fix auth -- do not change transport, do not
   disable host key checking, do not attempt to read, print, or export any
   SSH key, passphrase, or credential to make it succeed.

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
