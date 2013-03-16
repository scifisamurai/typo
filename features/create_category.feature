Feature:  
  As a blog administrator
  In order to group similar content
  I want to be able to create categories 

  Background:
    Given the blog is set up
    And the publisher has been created

  Scenario: When I am logged in as an admin, I should be able to click the categories link and create a new category
    Given I am logged into the admin panel
    When I follow "Categories"
    Then I should see "Your category slug"
   
