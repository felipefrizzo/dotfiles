# Felipe Frizzo's dotfiles for OSx

This repository holds all of my custom dotfiles, managed with
[chezmoi](https://www.chezmoi.io).

`chezmoi apply` handles the following, in order:

* install Xcode CLI tools, Rosetta (Apple Silicon), oh-my-zsh (before dotfiles are written)
* apply every managed dotfile (`.zshrc`, `.gitconfig`, `.vimrc`, ..., AI agent config -- see below)
* install Homebrew, then every app/formula in the `Brewfile`
* set macOS system and user defaults
* install fonts, configure the Dock, install the iTerm2 dynamic profile
* install `mise`-managed toolchains (node/python/go/java)
* install third-party AI agent skills, the [caveman](https://github.com/JuliusBrussee/caveman)
  skill, and [graphify](https://pypi.org/project/graphifyy/)

`install-vscode-plugins.sh` (VS Code extensions) stays a manual, standalone step -- run it
yourself if/when you still use VS Code on the new machine.

## Installation

On a genuinely fresh machine nothing is installed yet, not even Homebrew, so don't lead with
`brew install chezmoi`. chezmoi's own install script has no dependencies -- it downloads the
binary straight from GitHub releases -- and can run `chezmoi init --apply` for you in the same
line:

```shell
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply felipefrizzo/dotfiles
```

That installs chezmoi to `~/.local/bin`, clones this repo to `~/.local/share/chezmoi`, then
applies it: runs the `run_once_before_*` scripts (Xcode CLT, Homebrew itself, oh-my-zsh), writes
every managed dotfile, then runs the `run_once_after_*` / `run_onchange_after_*` scripts (brew
bundle, macOS defaults, mise, AI skills, ...). Once chezmoi is installed, `brew install chezmoi`
also works to keep the binary itself updated later; re-running `chezmoi apply` only re-applies
dotfiles that changed and reruns `run_onchange_` scripts whose watched content (Brewfile, skills
manifest) changed -- everything else is skipped if unchanged.

Also run [`dotfiles-confidential`](https://github.com/felipefrizzo/dotfiles-confidential) the same
way, as an independent second chezmoi profile, for personal casks/formulas and `.ssh/config` that
don't belong in a public repo. It's a private repo, so `init` needs SSH access already working
(1Password's SSH agent set up and signed in) -- by this point chezmoi itself is already installed
from the step above, so just run `chezmoi` directly instead of the curl one-liner again:

```shell
chezmoi init --apply --config ~/.config/chezmoi-confidential/chezmoi.toml git@github.com:felipefrizzo/dotfiles-confidential.git
```

(Point `--config` at a second, throwaway config file so this doesn't collide with the public
profile's `~/.config/chezmoi/chezmoi.toml` -- both profiles apply to the same `$HOME` but own
disjoint files, so running both is safe.)

## Source layout

* `.chezmoiroot` points chezmoi at `home/` as the source root, so repo-root files
  (`README.md`, `LICENSE`, `install-vscode-plugins.sh`) aren't treated as dotfiles
* `home/.chezmoiignore` excludes `Brewfile`, `setup-dock.py`, `fonts/`, and `iterm/` from being
  applied as literal dotfiles -- they're helper files referenced by `run_` scripts via
  `{{ .chezmoi.sourceDir }}`, not targets themselves
* `home/run_once_before_*` / `home/run_once_after_*` / `home/run_onchange_after_*` are the
  scripted steps listed above; numeric prefixes control order within each group

## AI agent config (Claude Code / Codex / Copilot)

chezmoi tracks and restores:

* the hand-authored parts of `~/.claude/settings.json` and `~/.copilot/settings.json`, via
  `create_private_settings.json` (created once, never overwritten afterwards -- so the apps'
  own runtime writes to these files, e.g. session state or env tokens, survive re-applies;
  `private_` keeps them mode 0600)
* a minimal `~/.codex/config.toml` fragment (`model`, `model_reasoning_effort`,
  `shell_environment_policy.inherit`), via `create_private_config.toml` for the same reason --
  the rest of that file is written by the ChatGPT desktop app itself and regenerates from
  normal use, so it's intentionally not tracked
* `~/.agent-instructions/AGENTS.md` (tool-agnostic rules), symlinked (`symlink_*.tmpl`, using
  `{{ .chezmoi.homeDir }}` so the path is portable) into Codex's `AGENTS.md`, Copilot's
  `copilot-instructions.md`, and `~/.claude/AGENTS.md` directly
* `~/.agent-instructions/CLAUDE.md` (Claude-Code-specific model/subagent routing), symlinked
  into `~/.claude/CLAUDE.md`. It imports `@AGENTS.md`, which needs `~/.claude/AGENTS.md` to
  exist as a sibling file since `@file` import resolution isn't guaranteed to follow the
  symlink to its real path -- hence the separate `~/.claude/AGENTS.md` symlink above
* `~/.agent-instructions/RTK.md`, symlinked into both tools' `RTK.md` -- edit once, every tool
  sees it; the hook that auto-rewrites shell commands through `rtk` is Claude-Code-only, other
  tools invoke `rtk` directly
* third-party agent skills, via `home/skills-manifest.txt` (one `npx skills add <source>` per
  line, regenerate from `~/.agents/.skill-lock.json`) -- installed by a `run_onchange_after_`
  script, so editing the manifest and re-running `chezmoi apply` picks up new entries
* the [caveman](https://github.com/JuliusBrussee/caveman) skill, via its own installer
* [graphify](https://pypi.org/project/graphifyy/), via `uv tool install graphifyy` then
  `graphify install --platform claude|codex` -- the package ships its own skill file and
  installs it itself, so it's intentionally not hand-copied into this repo (would drift from
  whatever `graphifyy` ships on the next version bump)

**Not tracked, ever:** API tokens/credentials of any kind. `GITHUB_TOKEN` and `JIRA_TOKEN` (used
by the `rtk` hook and Codex's shell environment policy) must be set up manually on each machine --
they are intentionally absent from every file this repo manages, public or confidential.
