#!/bin/zsh
set -eu

# Guard against empty compaudit output: BSD xargs (macOS) runs the command
# once even with no input, which would fail with a "missing operand" error
# and mark this run_once_ script as failed forever on an already-clean system.
insecure_dirs=("${(@f)$(compaudit)}")
if (( ${#insecure_dirs[@]} > 0 )); then
  chmod g-w,o-w "${insecure_dirs[@]}"
fi
