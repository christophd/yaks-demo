Feature: Fruit Store

  Background:
    Given URL: yaks:env('FRUIT_SERVICE_URL','http://localhost:8080')

  Scenario: Create infrastructure
    # Start Kafka container
    Given start Redpanda container

    # Create Camel K integration
    Given Camel K integration property file fruit-service.properties
    When load Camel K integration fruit-service.groovy
    Then Camel K integration fruit-service should print Started route1 (platform-http:///fruits)

  Scenario: Verify fruit service
    # Invoke Camel K service
    Given HTTP request body: yaks:readFile('pineapple.json')
    And HTTP request header Content-Type="application/json"
    When send POST /fruits
    Then receive HTTP 200 OK

    # Verify Kafka event
    Given Kafka connection
      | url | ${YAKS_TESTCONTAINERS_REDPANDA_LOCAL_BOOTSTRAP_SERVERS} |
    Given Kafka topic: medium-sugar
    Then expect Kafka message with body: yaks:readFile('pineapple.json')

  Scenario: Remove infrastructure
    # Remove Camel K resources
    Given delete Camel K integration fruit-service
    # Stop Kafka container
    Given stop Redpanda container
