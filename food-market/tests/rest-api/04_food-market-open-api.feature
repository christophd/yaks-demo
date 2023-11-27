Feature: Food Market Open API

  Background:
    Given OpenAPI specification: citrus:env('FOOD_MARKET_APP_URL','http://localhost:8080')/q/openapi
    Given OpenAPI URL: citrus:env('FOOD_MARKET_APP_URL','http://localhost:8080')
    Given OpenAPI outbound dictionary
      | $.product       | citrus:randomEnumValue('Mango','Peach','Banana') |
      | $.amount        | citrus:randomNumber(2)        |
      | $.price         | 2.citrus:randomNumber(2,true) |

  Scenario: Add random Booking
    When invoke operation: addBooking
    Then verify operation result: 201 CREATED

  Scenario: Booking NotFound
    Given variable id is "0"
    When invoke operation: getBookingById
    Then verify operation result: 404 NOT_FOUND

  Scenario: Invalid BookingId
    Given variable id is "xxx"
    When invoke operation: getBookingById
    Then verify operation result: 400 BAD_REQUEST

  Scenario: Add random Supply
    When invoke operation: addSupply
    Then verify operation result: 201 CREATED

  Scenario: Supply NotFound
    Given variable id is "0"
    When invoke operation: getSupplyById
    Then verify operation result: 404 NOT_FOUND

  Scenario: Invalid SupplyId
    Given variable id is "xxx"
    When invoke operation: getSupplyById
    Then verify operation result: 400 BAD_REQUEST
