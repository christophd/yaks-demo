Feature: Fruit Store Open API

  Background:
    Given OpenAPI specification: openapi.json
    Given OpenAPI URL: yaks:env('FRUIT_SERVICE_URL','http://localhost:8080')

  Scenario: Create infrastructure
    # Create Camel K integration
    When load Camel K integration FruitService.java with configuration
      | name    | fruit-service |
      | traits  | openapi.configmaps=[fruit-service-api] |
    Then Camel K integration fruit-service should print Started getFruits

  Scenario: addFruit
    When invoke operation: addFruit
    Then verify operation result: 201 CREATED

  Scenario: getFruit
    Given variable id is "1000"
    When invoke operation: getFruitById
    Then verify operation result: 200 OK

  Scenario: fruitNotFound
    Given variable id is "0"
    When invoke operation: getFruitById
    Then verify operation result: 404 NOT_FOUND

  Scenario: invalidFruitId
    Given variable id is "xxx"
    When invoke operation: getFruitById
    Then verify operation result: 400 BAD_REQUEST

  Scenario: Remove infrastructure
    # Remove Camel K resources
    Given delete Camel K integration fruit-service
