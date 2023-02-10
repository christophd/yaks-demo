Feature: Fruit Store API

  Background:
    Given URL: http://localhost:8080/api

  Scenario: addFruit
    And HTTP request header Content-Type="application/json"
    And HTTP request body
    """
    {
      "name": "Banana",
      "description": "citrus:randomString(10)",
      "category":{
        "id": 2,
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
    When send POST /fruits
    Then receive HTTP 201 CREATED

  Scenario: getFruit
    Given variable id is "1001"
    And HTTP request header Content-Type is "application/json"
    When send GET /fruits/${id}
    Then verify HTTP response header Content-Type="application/json"
    And verify HTTP response body
    """
    {
      "id": ${id},
      "name": "Pineapple",
      "description": "@ignore@",
      "category":{
        "id": 2,
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

  Scenario: fruitNotFound
    When send GET /fruits/0
    Then receive HTTP 404 NOT_FOUND

  Scenario: invalidFruitId
    Given send GET /fruits/xxx
    Then receive HTTP 400 BAD_REQUEST
