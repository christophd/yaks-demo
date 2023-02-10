Feature: Fruit Store Event

  Background:
    Given URL: http://localhost:8080/

  Scenario: create fruit event
    Given variable id is "citrus:randomNumber(5)"
    Given HTTP request headers
    | Accept         | application/json |
    | Content-Type   | application/json |
    | Ce-Specversion | 1.0              |
    | Ce-Id          | ${id}            |
    | Ce-Type        | high-sugar       |
    | Ce-Source      | https://github.com/citrusframework/yaks |
    | Ce-Subject     | Banana           |
    | Ce-Time        | citrus:currentDate('yyyy-MM-dd'T'HH:mm:ssXXX') |
    And HTTP request body
    """
    {
      "id": "${id}",
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
      "price": 1.05,
      "status": "PENDING",
      "tags": ["sweet"]
    }
    """
    When send POST
    Then receive HTTP 201 CREATED
