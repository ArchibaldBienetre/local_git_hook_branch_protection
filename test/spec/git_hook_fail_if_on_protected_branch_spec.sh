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
End