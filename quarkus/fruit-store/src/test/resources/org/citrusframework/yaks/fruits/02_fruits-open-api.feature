Feature: Fruit Store Open API

  Background:
    Given OpenAPI specification: http://localhost:8080/openapi

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
