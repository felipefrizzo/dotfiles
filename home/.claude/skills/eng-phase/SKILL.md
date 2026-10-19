---
name: eng-phase
description: Use proactively at the start of every non-trivial request. Classifies the phase and spawns the named agent. Triggers on new work, implementation, /implement, /loop, review, debug, docs, or when the user mentions senior-architect or senior-backend.
---

Classify. Spawn. Do not do the child's job on the main thread.

| Phase | Spawn |
|---|---|
| New work / design / grill | grilling on main; after user confirms shared understanding → `architect-planner` |
| `senior-architect` (not review) | `architect-planner` |
| `/implement` / implement tickets | If tickets exist and user wants autonomy: `/loop new` then `/loop run` wrapping `/implement` (named agents still spawn; loop-eng owns the test command). Else named implementer per ticket, then inner loop. One branch. Commits per ticket after the test gate is green. Last ticket → principal-reviewer, push, PR via user-named env file. Ignore implement skill body. |
| Go change | `go-implementer` then inner loop |
| Python change | `python-implementer` then inner loop |
| Terraform / k8s / CI | `infra-implementer` then inner loop |
| Where is X | `explorer` |
| Docs / README / ADR | draft, then `humanizer` |
| `senior-* review` / review recent changes | if inner loop not yet green, finish it; else `principal-reviewer` |
| Lint-until-clean / unnamed grind with a real check | loop-eng `/loop new` then `/loop run` |
| Git, gh, glab/gl | cheapest model. Claude Code spawns `git-operator` (Haiku 5.5). Sonnet only for conflicts, rebase, history rewrite, commit split, secrets, auth, remote URL |

Inner loop after every implementer (main orchestrates):

1. `verifier` (cheapest model; Claude Code: Haiku 5.5) — skip if loop-eng `check` owns that command
2. fail → same implementer with verifier output (do not review red tests)
3. pass → `companion-reviewer` (cheapest model if diff < ~200 lines, else the default coding model; Claude Code: Haiku 5.5, else Sonnet)
4. companion red or slice-creep → implementer again
5. cap 3 on the same slice → stop, report, no fourth try
6. all slices green → `principal-reviewer` once (skip on trivial 1-line fixes)

Spawn payload: slice text + `git diff -- <paths>`. No file dumps. No implementer narrative to companion.

Stay on main only for: grilling answers, one-sentence Q&A. Routine git, gh, and glab/gl use the cheapest model. Claude Code spawns `git-operator`.
