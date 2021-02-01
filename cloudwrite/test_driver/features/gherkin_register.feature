Feature: Gherkin_sample
  Sample test using gherkin

  Scenario Outline: Login
    When I tap the "home_register_button_key" button
    Then I expect the widget "register_screen_key" to be present within 3 second
    When I fill the "register_email_field_key" field with <email>
    And I fill the "register_username_field_key" field with <username>
    And I fill the "register_password_field_key" field with <password>
    And I tap the "register_form_submit_button" button
    Then I expect the widget "login_screen_key" to be present within 5 second

    Examples:
      | email                        | username   | password           |
      | "gherkin@gherkin.gherkin"    | "gherkin"  | "gherkinpassword"  |
      | "cucumber@cucumber.cucumber" | "cucumber" | "cucumberpassword" |
