Feature: Camel K Fruit Store

  Background:
    Given Knative broker url: http://broker-ingress.knative-eventing.yaks-demo/default
    Given Knative event consumer timeout is 20000 ms
    Given URL: http://fruit-service.yaks-demo

  Scenario: Create infrastructure
    Given create Knative channel fruits
    # Create Knative event consumer service
    Given create Knative event consumer service fruit-events
    Given subscribe service fruit-events to Knative channel fruits
    Given create Knative trigger fruit-event-trigger on channel fruits with filter on attributes
      | type   | org.citrusframework.yaks.fruits |
      | source | https://github.com/citrusframework/yaks |

    # Create Camel K integration
    When load Camel K integration fruit-service.groovy
    Then Camel K integration fruit-service should print Started route1 (platform-http:///fruits)

  Scenario: Verify fruit service
    Given Knative service "fruit-events"
    # Invoke Camel K service
    Given HTTP request body
    """
    {
      "id": 1000,
      "name": "Pineapple",
      "category":{
        "id": "1",
        "name":"tropical"
      },
      "nutrition":{
        "calories": 50,
        "sugar": 9
      },
      "status": "AVAILABLE",
      "price": 1.59,
      "tags": ["sweet"]
    }
    """
    And HTTP request header Content-Type="application/json"
    When send POST /fruits
    Then receive HTTP 202 ACCEPTED

    # Verify Knative event
    Then expect Knative event data: yaks:readFile('pineapple.json')
    And receive Knative event
    | specversion | 1.0                                     |
    | type        | org.citrusframework.yaks.fruits         |
    | source      | https://github.com/citrusframework/yaks |
    | subject     | medium-sugar                            |
    | id          | @ignore@                                |
    | time        | @matchesDatePattern('yyyy-MM-dd'T'HH:mm:ss')@ |

  Scenario: Remove infrastructure
    # Remove Camel K resources
    Given delete Camel K integration fruit-service
    # Remove Knative resources
    Given delete Knative channel fruits
