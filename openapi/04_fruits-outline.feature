@require(com.consol.citrus:citrus-validation-hamcrest:@citrus.version@)
Feature: Fruit Store Outline

  Background:
    Given URL: yaks:env('FRUIT_SERVICE_URL','http://localhost:8080')

  Scenario: Create infrastructure
    # Create Camel K integration
    When load Camel K integration FruitService.java with configuration
      | name    | fruit-service |
      | traits  | openapi.configmaps=[fruit-service-api] |
    Then Camel K integration fruit-service should print Started getFruits

  Scenario Outline: getFruits <name>
    And HTTP request header Content-Type is "application/json"
    When send GET /api/fruits/<id>
    And verify HTTP response body
    """
    {
      "id": <id>,
      "name": "<name>",
      "description": "@ignore@",
      "category":{
        "id": "@isNumber()@",
        "name":"<category>"
      },
      "nutrition":{
        "calories": <calories>,
        "sugar": <sugar>
      },
      "status": "<status>",
      "price": <price>,
      "tags": "@assertThat(not(empty())@"
    }
    """
    Then receive HTTP 200 OK

  Examples:
    | id   | name       | category | price | calories | sugar | status    |
    | 1000 | Apple      | pome     | 1.59  | 52       | 10    | AVAILABLE |
    | 1001 | Pineapple  | tropical | 1.99  | 50       | 9     | PENDING   |
    | 1002 | Strawberry | berry    | 2.55  | 29       | 5     | SOLD      |

  Scenario: Remove infrastructure
    # Remove Camel K resources
    Given delete Camel K integration fruit-service
