@require(com.consol.citrus:citrus-validation-hamcrest:@citrus.version@)
Feature: Fruit Store Open API dictionary

  Background:
    Given OpenAPI specification: openapi.json
    Given OpenAPI URL: yaks:env('FRUIT_SERVICE_URL','http://localhost:8080')
    Given OpenAPI inbound dictionary
      | $.name          | @assertThat(anyOf(is(Banana),is(Kiwi),is(Orange),is(Watermelon),is(Apple),is(Pineapple),is(Strawberry)))@ |
      | $.category.name | @assertThat(anyOf(is(tropical),is(pome),is(berry),is(melon)))@ |
    Given OpenAPI outbound dictionary
      | $.name          | citrus:randomEnumValue('Orange','Kiwi','Watermelon') |
      | $.category.name | citrus:randomEnumValue('tropical', 'berry', 'melon') |

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

  Scenario: Remove infrastructure
    # Remove Camel K resources
    Given delete Camel K integration fruit-service
