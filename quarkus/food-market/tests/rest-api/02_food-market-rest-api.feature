Feature: Food Market REST API

  Background:
    Given URL: citrus:env('FOOD_MARKET_APP_URL','http://localhost:8080')
    Given variables
      | id      | citrus:randomNumber(5) |
      | product | citrus:randomEnumValue(Cherry,Apple,Pineapple,Kiwi) |

  Scenario: Booking and matching supply
    # Send Http booking request
    Given HTTP request body: citrus:readFile('booking.json')
    And HTTP request header Content-Type="application/json"
    When send POST /api/bookings
    Then verify HTTP response expression: $.id="@variable(bookingId)@"
    Then verify HTTP response expression: $.status="PENDING"
    Then receive HTTP 201 CREATED

    # Create matching supply
    Given HTTP request body: citrus:readFile('supply.json')
    And HTTP request header Content-Type="application/json"
    When send POST /api/supplies
    Then receive HTTP 201 CREATED
    Then sleep 1000 ms

    # Verify booking completed
    When send GET /api/bookings/${bookingId}
    Then verify HTTP response expression: $.status="COMPLETED"
    And receive HTTP 200 OK
