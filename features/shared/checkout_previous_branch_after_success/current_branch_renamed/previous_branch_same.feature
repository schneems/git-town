Feature: Git checkout history is preserved when renaming the current branch

  (see ../same_current_branch/previous_branch_same.feature)


  Scenario: rename-branch
    Given my repository has feature branches named "previous" and "current"
    And I am on the "current" branch with "previous" as the previous Git branch
    When I run `git-town rename-branch current current-new`
    Then my repository ends up on the "current-new" branch
    And my previous Git branch is still "previous"
