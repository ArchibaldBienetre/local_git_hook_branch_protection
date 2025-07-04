#!/bin/bash

# Use this as local pre-push hook to prevent accidental pushes to main, master, develop
# To override, add the " --no-verify" flag to your push command.
#
# To associate it with _all_ your git repos: 
# * Create a directory "${HOME}/.githooks"
# mkdir "${HOME}/.githooks"
# * Set that directory as your hooks directory:
# git config --global core.hooksPath "${HOME}/.githooks"
# * Move this file into your hooks directory, and rename it to "pre-push" (or, set a symbolic link "pre-push" in your git hooks directory)
# cp git_hook_fail_if_on_protected_branch.sh "${HOME}/.githooks/pre-push

# strict mode
# https://web.archive.org/web/20250114155712/https://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

echo "### GIT 'pre-push' hook: Checking branch name... ###"
local_branch=$(git rev-parse --abbrev-ref HEAD)

protected_branch_regex="^(main|master|develop)$"

if [[ "${local_branch}" =~ ${protected_branch_regex} ]]
then
    echo "### FAILED 'pre-push' hook: Trying to push to a protected branch: '${local_branch}'. Add ' --no-verify' flag if you are absolutely sure."
    exit 1
fi

echo "### DONE 'pre-push' hook: Branch name '${local_branch}' is OK. ###"
exit 0
