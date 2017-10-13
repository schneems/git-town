Feature: Git checkout history is preserved when the current and previous branch don't change

  As a developer running `git checkout -` after running a Git Town command
  I want to end up on the expected previous branch
  So that Git Town supports my productive use of the Git checkout history


  Scenario: kill
    Given my repository has feature branches named "previous", "current", and "victim"
    And I am on the "current" branch with "previous" as the previous Git branch
    When I run `git-town kill victim`
    Then my repository is still on the "current" branch
    And my previous Git branch is still "previous"


  Scenario: new-pull-request
    Given my repository has feature branches named "previous" and "current"
    And I have "open" installed
    And my remote origin is "https://github.com/Originate/git-town.git"
    And I am on the "current" branch with "previous" as the previous Git branch
    When I run `git-town new-pull-request`
    Then my repository is still on the "current" branch
    And my previous Git branch is still "previous"


  Scenario: prune-branches
    Given my repository has feature branches named "previous" and "current"
    And the following commit exists in my repository
      | BRANCH   | LOCATION | FILE NAME     | FILE CONTENT     |
      | previous | local    | previous_file | previous content |
      | current  | local    | current_file  | current content  |
    And I am on the "current" branch with "previous" as the previous Git branch
    When I run `git-town prune-branches`
    Then my repository is still on the "current" branch
    And my previous Git branch is still "previous"


  Scenario: repo
    Given my repository has feature branches named "previous" and "current"
    And I have "open" installed
    And my remote origin is "https://github.com/Originate/git-town.git"
    And I am on the "current" branch with "previous" as the previous Git branch
    When I run `git-town repo`
    Then my repository is still on the "current" branch
    And my previous Git branch is still "previous"


  Scenario: ship
    Given my repository has feature branches named "previous", "current", and "feature"
    And the following commit exists in my repository
      | BRANCH  | LOCATION | FILE NAME    | FILE CONTENT    |
      | feature | remote   | feature_file | feature content |
    And I am on the "current" branch with "previous" as the previous Git branch
    When I run `git-town ship feature -m "feature done"`
    Then my repository is still on the "current" branch
    And my previous Git branch is still "previous"


  Scenario: sync
    Given my repository has feature branches named "previous" and "current"
    And I am on the "current" branch with "previous" as the previous Git branch
    When I run `git-town sync`
    Then my repository is still on the "current" branch
    And my previous Git branch is still "previous"
