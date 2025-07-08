# strict mode
# https://web.archive.org/web/20250114155712/https://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

Describe "git_hook_fail_if_on_protected_branch.sh"
  Describe "Unit tests with mocked git"

    # mock existing git command
    Mock git
      if [[ "$1" == "rev-parse" ]] && [[ "$2" == "--abbrev-ref" ]] && [[ "$3" == "HEAD" ]]; then
        echo "${BRANCH_NAME}"
      else
        echo "UNEXPECTED CALL to git command: $@" >&2
      fi
    End

    Describe "On protected branch"
      Parameters
        "main"
        "master"
        "develop"
      End
      Example "fails on branch '$1'"
        export BRANCH_NAME="$1"

        When I run script "../git_hook_fail_if_on_protected_branch.sh"

        The status should be failure
        The output should include "### FAILED 'pre-push' hook: Trying to push to a protected branch: '$1'."
      End
    End

    Describe "On unprotected branch"
      Parameters
        "other"
        "release"
        "hotfix/1.2.3"
        "feature/JIRA-12345-my-feature-branch"
      End
      Example "succeeds on branch '$1'"
        export BRANCH_NAME="$1"

        When I run script "../git_hook_fail_if_on_protected_branch.sh"

        The status should be success
        The output should include "### DONE 'pre-push' hook: Branch name '$1' is OK. ###"
      End
    End
  End

  Describe "Integration tests with real git"

    init_git() {

      # On CI's Ubuntu 22.04, the git version is too old and won't support "main" as the main branch nor the init.defaultBranch setting.
      # git config --global init.defaultBranch main

      # I can't use a bare repo for the "remote" repository, or I won't be able to create branches
      #git init --bare
      git init
      git config user.email "joe.test@example.com"
      git config user.name "Joe Test"
    }

    create_local_git_remote() {
      mkdir -p "${TEST_GIT_REMOTE_DIRECTORY}"
      cd "${TEST_GIT_REMOTE_DIRECTORY}"
      init_git
      git commit --allow-empty -m "initial"
    }

    create_temporary_git_repo_with_hook() {
      export TEST_GIT_REMOTE_DIRECTORY="${SHELLSPEC_TMPDIR}/test_git_repo_remote"
      create_local_git_remote

      export TEST_GIT_DIRECTORY="${SHELLSPEC_TMPDIR}/test_git_repo"
      mkdir -p "${TEST_GIT_DIRECTORY}"
      cd "${TEST_GIT_DIRECTORY}"
      init_git
      git commit --allow-empty -m "initial"
      git remote add origin "${TEST_GIT_REMOTE_DIRECTORY}"
      cp "${SHELLSPEC_PROJECT_ROOT}/../git_hook_fail_if_on_protected_branch.sh" "${TEST_GIT_DIRECTORY}/.git/hooks/pre-push"
    }

    push_to_develop() {
      cd "${TEST_GIT_DIRECTORY}"
      git checkout -b develop
      git push
    }

    push_to_feature_branch() {
      cd "${TEST_GIT_DIRECTORY}"
      git checkout -b 'feature/JIRA-12345-my-feature-branch'
      git push
    }

    delete_temporary_git_repo() {
      rm -rf "${TEST_GIT_DIRECTORY}"
      rm -rf "${TEST_GIT_REMOTE_DIRECTORY}"
    }

    Before create_temporary_git_repo_with_hook
    After delete_temporary_git_repo

    It "fails on protected branch 'develop'"

      When I run push_to_develop

      The status should be failure
      The output should include "### FAILED 'pre-push' hook: Trying to push to a protected branch: 'develop'."
      The error should include ""
    End
    It "succeeds on unprotected branch 'feature/JIRA-12345-my-feature-branch'"

      When I run push_to_feature_branch

      The status should be success
      The output should include "### DONE 'pre-push' hook: Branch name 'feature/JIRA-12345-my-feature-branch' is OK. ###"
      The error should include ""
    End
  End
End
