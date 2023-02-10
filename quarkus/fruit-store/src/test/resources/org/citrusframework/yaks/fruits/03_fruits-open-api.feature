Feature: Fruit Store Open API dictionary

  Background:
    Given OpenAPI specification: http://localhost:8080/openapi
    Given OpenAPI inbound dictionary
      | $.name          | @assertThat(anyOf(is(Banana),is(Kiwi),is(Orange),is(Watermelon),is(Apple),is(Pineapple),is(Strawberry)))@ |
      | $.category.name | @assertThat(anyOf(is(tropical),is(pome),is(berry),is(melon)))@ |
    Given OpenAPI outbound dictionary
      | $.name          | citrus:randomEnumValue('Orange','Kiwi','Watermelon') |
      | $.category.name | citrus:randomEnumValue('tropical', 'berry', 'melon') |

  Scenario: addFruit
    When invoke operation: addFruit
    Then verify operation result: 201 CREATED

  Scenario: getFruit
    Given variable id is "1000"
    When invoke operation: getFruitById
    Then verify operation result: 200 OK
