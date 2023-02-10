Feature: Fruit Store API

  Background:
    Given URL: yaks:env('FRUIT_SERVICE_URL','http://localhost:8080')

  Scenario: Create infrastructure
    # Create Camel K integration
    When load Camel K integration FruitService.java with configuration
      | name    | fruit-service |
      | traits  | openapi.configmaps=[fruit-service-api] |
    Then Camel K integration fruit-service should print Started getFruits

  Scenario: health check
    Given wait for GET on path /health to return 200 OK

  Scenario: getFruitById
    Given variable id is "1001"
    And HTTP request header Content-Type is "application/json"
    When send GET /api/fruits/${id}
    And verify HTTP response body
    """
    {
      "id": ${id},
      "name": "Pineapple",
      "description": "@ignore@",
      "category":{
        "id": 1,
        "name":"tropical"
      },
      "nutrition":{
        "calories": 50,
        "sugar": 9
      },
      "status": "PENDING",
      "price":1.99,
      "tags": ["cocktail"]
    }
    """
    Then receive HTTP 200 OK

  Scenario: addFruit
    Given HTTP request header Content-Type="application/json"
    And HTTP request body
    """
    {
      "id": "yaks:randomNumber(4)",
      "name": "Banana",
      "description": "yaks:randomString(10)",
      "category":{
        "id": 1,
        "name":"tropical"
      },
      "nutrition":{
        "calories": 97,
        "sugar": 14
      },
      "status": "PENDING",
      "tags": ["sweet"]
    }
    """
    When send POST /api/fruits
    Then receive HTTP 201 CREATED

  Scenario: fruitNotFound
    When send GET /api/fruits/0
    Then receive HTTP 404 NOT_FOUND

  Scenario: invalidFruitId
    Given send GET /api/fruits/xxx
    Then receive HTTP 400 BAD_REQUEST

  Scenario: Remove infrastructure
    # Remove Camel K resources
    Given delete Camel K integration fruit-service
