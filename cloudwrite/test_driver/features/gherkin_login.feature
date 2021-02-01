Feature: Gherkin_sample
  Sample test using gherkin

  Scenario Outline: Login
    When I tap the "home_login_button_key" button
    Then I expect the widget "login_screen_key" to be present within 3 second
    When I fill the "login_username_field_key" field with <username>
    And I fill the "login_password_field_key" field with <password>
    And I tap the "login_button_key" button
    Then I expect the widget "notes_screen_key" to be present within 5 second
    When I tap the "notes_logout_button_key" button
    Then I expect the widget "home_screen_key" to be present within 5 second

    Examples:
      | username   | password           |
      | "gherkin"  | "gherkinpassword"  |
      | "cucumber" | "cucumberpassword" |

  Scenario: Navigate to login custom step
    When I press the "home_login_button_key" button
    Then I should see the "login_screen_key" page
