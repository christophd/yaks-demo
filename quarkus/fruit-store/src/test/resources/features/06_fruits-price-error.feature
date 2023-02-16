Feature: Fruit price error

  Background:
    Given OpenAPI specification: http://localhost:8080/q/openapi
    Given variable id is "1002"
    Given variable key is "strawberry"
    Given HTTP server "food-market-service"
    And HTTP server listening on port 8081
    And OpenAPI request fork mode is enabled
    And start HTTP server

  Scenario: getPriceUpdateError
    When invoke operation: getPriceUpdate
    Then receive GET /market/fruits/price/${key}
    And send HTTP 500 INTERNAL_SERVER_ERROR
    Then verify operation result: 500 INTERNAL_SERVER_ERROR
