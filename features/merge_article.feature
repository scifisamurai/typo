Feature: Merge Articles
  As a blog administrator
  In order to group similar content
  I want to be able to merge articles on my blog

  Background:
    Given the blog is set up
    And the publisher has been created
    And the "Star Trek" article has been created by "admin" with "Kirk" body text
    And "Bob" has commented on "Star Trek" with "Star Trek comment"
    And the "Star Trek 2" article has been created by "publisher" with "Sisko" body text
    And "Mark" has commented on "Star Trek 2" with "Star Trek 2 comment"

  Scenario: A non-admin cannot merge two articles
    Given I am logged into the admin panel as a publisher
    And I am on the all articles page
    When I follow "Edit"
    Then I should see "Error, you are not allowed to perform this action"

  Scenario: When articles are merged, the merged article should contain the text of both previous articles
    Given I am logged into the admin panel
    And I am on the all articles page
    Then I should see "Star Trek"
    And I should see "Star Trek 2"
    When I follow "Star Trek"
    Then I should not see "Error, you are not allowed to perform this action"
    And I should see "Merge Articles"
    When I fill in "merge_with" with "4"
    And I press "Merge"
    Then I should not see "Star Trek 2"
    When I follow "Star Trek"
    And I follow "Preview"
    Then I should see "Sisko"
    And I should see "Kirk"

  Scenario: When articles are merged, the merged article should have one author (either one of the authors of the two original articles)
    Given I am logged into the admin panel
    And I am on the all articles page
    Then I should see "Star Trek"
    And I should see "Star Trek 2"
    When I follow "Star Trek"
    And I fill in "merge_with" with "4"
    And I press "Merge"
    Then "Star Trek" should have either "admin" or "publisher" as the author
  
  Scenario: Comments on each of the two original articles need to all carry over and point to the new, merged article
    Given I am logged into the admin panel
    And I am on the all articles page
    Then I should see "Star Trek"
    And I should see "Star Trek 2"
    When I follow "Star Trek"
    And I fill in "merge_with" with "4"
    And I press "Merge"
    Then I should not see "Star Trek 2"
    When I follow "Star Trek"
    And I follow "Preview"
    Then I should see "Star Trek comment" 
    And I should see "Star Trek 2 comment"
   
