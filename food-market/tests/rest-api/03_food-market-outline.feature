Feature: Food Market Outline

  Background:
    Given URL: citrus:env('FOOD_MARKET_APP_URL','http://localhost:8080')

  Scenario: Health check
    Given wait for URL /api/bookings to return 200 OK

  Scenario Outline: Booking and matching supply
    # Send Http booking request
    Given HTTP request body: {"client": "client_<id>", "product": "<product>", "amount": <amount>, "price": <price>}
    And HTTP request header Content-Type="application/json"
    When send POST /api/bookings
    Then verify HTTP response expression: $.id="@variable(bookingId)@"
    Then verify HTTP response expression: $.status="PENDING"
    Then receive HTTP 201 CREATED

    # Create matching supply
    Given HTTP request body: {"supplier": "supplier_<id>", "product": "<product>", "amount": <amount>, "price": <price>}
    And HTTP request header Content-Type="application/json"
    When send POST /api/supplies
    Then receive HTTP 201 CREATED
    Then sleep 1000 ms

    # Verify booking completed
    When send GET /api/bookings/${bookingId}
    Then verify HTTP response expression: $.status="COMPLETED"
    And receive HTTP 200 OK

  Examples:
    | id   | product    | amount | price |
    | 1001 | Apple      | 10     | 1.59  |
    | 1002 | Pineapple  | 20     | 1.99  |
    | 1003 | Strawberry | 30     | 2.55  |
