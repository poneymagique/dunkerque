Feature: Test version endpoint

  Scenario: Without authentication
    Given I send a "GET" request to "/v2/"
    Then the response status code should be 401
    And the header "Docker-Distribution-Api-Version" should contain "registry/2.0"
    And the header "WWW-Authenticate" should contain "Basic"
    And 0 queries have been run

  @reset-schema
  Scenario: With valid credentials
    Given I have users:
      | username | password |
      | test     | test     |
      | test_KO  | 12345    |
    When I set basic authentication with "test" and "test"
    And I send a "GET" request to "/v2/"
    Then the response status code should be 200
    Then the header "Docker-Distribution-Api-Version" should contain "registry/2.0"
    And 1 queries have been run

  Scenario: With bad credentials
    Given I set basic authentication with "test_KO" and "test1234"
    And I send a "GET" request to "/v2/"
    Then the response status code should be 401
    Then the header "Docker-Distribution-Api-Version" should contain "registry/2.0"
    And 1 queries have been run
