Feature: Food Market UI

  Background:
    Given URL: citrus:env('FOOD_MARKET_APP_URL','http://localhost:8080')
    Given variable home_url="citrus:env('FOOD_MARKET_APP_URL','http://localhost:8080')/"

  Scenario: Start browser
    Given start browser
    Given user navigates to "${home_url}"
    Then browser page should display heading with tag-name="h1" having
      | text   | Food Market demo |

  Scenario: Booking form submit
    Given user navigates to "${home_url}"
    When user selects option "booking" on dropdown with id="type"
    Then sleep 500 ms
    When user enters text "browser_client" to input with id="name"
    Then sleep 500 ms
    When user selects option "Strawberry" on dropdown with id="product"
    Then sleep 500 ms
    When user enters text "10" to input with id="amount"
    Then sleep 500 ms
    When user enters text "3.99" to input with id="price"
    Then sleep 500 ms
    When user selects option "PENDING" on dropdown with id="status"
    Then sleep 500 ms
    And user clicks button with id="save"
    Then sleep 1000 ms

  Scenario: Supply form submit
    Given user navigates to "${home_url}"
    When user selects option "supply" on dropdown with id="type"
    Then sleep 500 ms
    When user enters text "browser_supplier" to input with id="name"
    Then sleep 500 ms
    When user selects option "Strawberry" on dropdown with id="product"
    Then sleep 500 ms
    When user enters text "10" to input with id="amount"
    Then sleep 500 ms
    When user enters text "3.99" to input with id="price"
    Then sleep 500 ms
    When user selects option "AVAILABLE" on dropdown with id="status"
    Then sleep 500 ms
    And user clicks button with id="save"
    Then sleep 1000 ms

  Scenario: Stop browser
    Then stop browser
