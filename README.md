# Felipe Frizzo's dotfiles for OSx

This repository include all of my custom dotfiles.

This include the following step.

* install xcode-cli
* install homebrew
* install all applications from homebrew
* install atom plugins
* install external softwares
* run set OsX system defaults
* run set user defaults
* copy bash configurations to home user folder
* install latest updates from app store
* configure Dock with the applications
* link AI agent instructions (Claude Code / Codex / Copilot) to a single source
* install third-party agent skills
* install the caveman skill for every AI agent found on the machine
* install the iTerm2 dynamic profile

## Installation

Download

```shell
mkdir dotfiles
cd dotfiles
curl -#L http://github.com/felipefrizzo/dotfiles/tarball/master | tar -xvz --strip-components 1
chmod +x *.sh
sh setup.sh
cd ..
rm -rf dotfiles
```

Also run [`dotfiles-confidential`](https://github.com/felipefrizzo/dotfiles-confidential)'s
`setup.sh` for personal casks/formulas and `.ssh/config` that don't belong in a public repo.

## AI agent config (Claude Code / Codex / Copilot)

`setup.sh` tracks and restores:

* the hand-authored parts of `~/.claude/settings.json` and `~/.copilot/settings.json`
* a minimal `~/.codex/config.toml` fragment (`model`, `model_reasoning_effort`,
  `shell_environment_policy.inherit`) -- the rest of that file is written by the ChatGPT
  desktop app itself and regenerates from normal use, so it's intentionally not tracked
* `~/.agent-instructions/AGENTS.md` (tool-agnostic rules), symlinked into Codex's `AGENTS.md`
  and Copilot's `copilot-instructions.md` directly
* `~/.agent-instructions/CLAUDE.md` (Claude-Code-specific model/subagent routing, `@AGENTS.md`
  import), symlinked into `~/.claude/CLAUDE.md` -- only Claude Code supports `@file` imports, so
  Codex/Copilot get the shared file straight, Claude gets the shared file plus its own routing
* `~/.agent-instructions/RTK.md`, symlinked into both tools' `RTK.md` -- edit once, every tool
  sees it; the hook that auto-rewrites shell commands through `rtk` is Claude-Code-only, other
  tools invoke `rtk` directly
* third-party agent skills, via `home/skills-manifest.txt` (one `npx skills add <source>` per
  line, regenerate from `~/.agents/.skill-lock.json`)
* the [caveman](https://github.com/JuliusBrussee/caveman) skill, via its own installer

**Not tracked, ever:** API tokens/credentials of any kind. `GITHUB_TOKEN` and `JIRA_TOKEN` (used
by the `rtk` hook and Codex's shell environment policy) must be set up manually on each machine --
they are intentionally absent from every file this repo manages, public or confidential.
