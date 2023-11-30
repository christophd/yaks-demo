Feature: Food Market Eventing

  Background:
    Given URL: citrus:env('FOOD_MARKET_APP_URL','http://localhost:8080')
    Given Kafka connection
      | url           | citrus:env('KAFKA_BOOTSTRAP_SERVERS','localhost:9092') |
      | topic         | shipping             |
      | consumerGroup | food-market-eventing |
      | offsetReset   | latest               |
    Given Kafka consumer timeout is 60000 ms
    Given purge endpoint yaks-kafka-endpoint

  Scenario: Verify Kafka events via Http
    # Send Http booking request
    Given HTTP request body: { "client": "client_http", "product": "Cherry", "amount": 10, "price": 1.29}
    And HTTP request header Content-Type="application/json"
    When send POST /api/bookings
    # Send Http supply request
    Given HTTP request body: { "supplier": "supplier_http", "product": "Cherry", "amount": 10, "price": 1.29}
    And HTTP request header Content-Type="application/json"
    When send POST /api/supplies
    Then receive HTTP 201 CREATED
    # Expect Kafka shipping event
    Then expect Kafka message with body
"""
  {
    "client": "client_http",
    "product": "Cherry",
    "amount": 10,
    "address": "@ignore@"
  }
"""

  Scenario: Verify Kafka events
    # Produce Kafka booking event
    Given Kafka topic: bookings
    When send Kafka message with body: { "client": "client_kafka", "product": "Banana", "amount": 10, "price": 1.29}
    # Produce Kafka supply event
    Given Kafka topic: supplies
    When send Kafka message with body: { "supplier": "supplier_kafka", "product": "Banana", "amount": 10, "price": 1.29}
    # Expect Kafka shipping event
    Given Kafka topic: shipping
    Then expect Kafka message with body
"""
  {
    "client": "client_kafka",
    "product": "Banana",
    "amount": 10,
    "address": "@ignore@"
  }
"""
