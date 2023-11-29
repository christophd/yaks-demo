Feature: Food Market REST API

  Background:
    Given URL: citrus:env('FOOD_MARKET_APP_URL','http://localhost:8080')

  Scenario: Health check
    Given wait for URL /api/bookings to return 200 OK

  Scenario: Booking and matching supply
    # Send Http booking request
    Given HTTP request body: {"client": "client_1000", "product": "Orange", "amount": 10, "price": 1.59}
    And HTTP request header Content-Type="application/json"
    When send POST /api/bookings
    Then verify HTTP response body
    """
      {
        "id": "@variable(bookingId)@",
        "client": "client_1000",
        "product": {
          "name":"Orange",
          "description":"Juicy fruit",
          "id": "@ignore@"
        },
        "amount": 10,
        "price": 1.59,
        "status": "PENDING"
      }
    """
    Then receive HTTP 201 CREATED

    # Create matching supply
    Given HTTP request body: {"supplier": "supplier_1000", "product": "Orange", "amount": 10, "price": 1.49}
    And HTTP request header Content-Type="application/json"
    When send POST /api/supplies
    Then receive HTTP 201 CREATED
    Then sleep 1000 ms

    # Verify booking completed
    When send GET /api/bookings/${bookingId}
    Then verify HTTP response expression: $.status="COMPLETED"
    And receive HTTP 200 OK
