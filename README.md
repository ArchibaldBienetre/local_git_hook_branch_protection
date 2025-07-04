# Git pre-push hook: fail if on a protected branch

Use this repository's [git_hook_fail_if_on_protected_branch.sh](./git_hook_fail_if_on_protected_branch.sh) as local pre-push hook 
in Git to prevent accidental pushes to `main`, `master`, `develop`.

This is obviously a workaround for those times where you can't just switch on branch protection (like, because 
you're a wage slave who has zero access privileges to change anything about the repos that they are code owners 
and commit leaders of, and work with on a daily basis. Random example :P )

## Installation

Install it any way you want, but the following  is what I suggest.

### Steps to associate the Git hook with _all_ your git repos

* Create a directory `${HOME}/.githooks`
```
mkdir "${HOME}/.githooks"
```
* Set that directory as your hooks directory:
```
git config --global core.hooksPath "${HOME}/.githooks"
```
* Move the script file into your hooks directory, and rename it to "pre-push" 
  * or, set a symbolic link "pre-push" in your git hooks directory
```
cp git_hook_fail_if_on_protected_branch.sh "${HOME}/.githooks/pre-push
```

## Override the Git hook

To override the git hook once for a single command, add the `--no-verify` flag to your push command.


