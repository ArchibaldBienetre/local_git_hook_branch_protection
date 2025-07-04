Describe "gitHookFailIfOnProtectedBranch.sh"
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
      It "fails on branch 'main'"
        export BRANCH_NAME="main"
        When I run script "../gitHookFailIfOnProtectedBranch.sh"
        The status should be failure
        The output should include "### FAILED 'pre-push' hook: Trying to push to a protected branch: main."
      End
      It "fails on branch 'master'"
        export BRANCH_NAME="master"
        When I run script "../gitHookFailIfOnProtectedBranch.sh"
        The status should be failure
        The output should include "### FAILED 'pre-push' hook: Trying to push to a protected branch: master."
      End
      It "fails on branch 'develop'"
        export BRANCH_NAME="develop"
        When I run script "../gitHookFailIfOnProtectedBranch.sh"
        The status should be failure
        The output should include "### FAILED 'pre-push' hook: Trying to push to a protected branch: develop."
      End
    End

    Describe "On unprotected branch"
      It "succeeds on branch 'other'"
        export BRANCH_NAME="other"
        When I run script "../gitHookFailIfOnProtectedBranch.sh"
        The status should be success
        The output should include "### DONE 'pre-push' hook: Branch name other is OK. ###"
      End
      It "succeeds on branch 'release'"
        export BRANCH_NAME="release"
        When I run script "../gitHookFailIfOnProtectedBranch.sh"
        The status should be success
        The output should include "### DONE 'pre-push' hook: Branch name release is OK. ###"
      End
      It "succeeds on branch 'hotfix/1.2.3'"
        export BRANCH_NAME="hotfix/1.2.3"
        When I run script "../gitHookFailIfOnProtectedBranch.sh"
        The status should be success
        The output should include "### DONE 'pre-push' hook: Branch name hotfix/1.2.3 is OK. ###"
      End
      It "succeeds on branch 'feature/JIRA-12345-my-feature-branch'"
        export BRANCH_NAME="feature/JIRA-12345-my-feature-branch"
        When I run script "../gitHookFailIfOnProtectedBranch.sh"
        The status should be success
        The output should include "### DONE 'pre-push' hook: Branch name feature/JIRA-12345-my-feature-branch is OK. ###"
      End
    End
  End
End