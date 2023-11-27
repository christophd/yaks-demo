Feature: Food Market Cloud Service

  Background:
    Given URL: citrus:env('FOOD_MARKET_APP_URL','http://localhost:8080')
    Given variables
      | food-market.url        | citrus:env('FOOD_MARKET_APP_URL','http://localhost:8080') |
      | aws.s3.bucketNameOrArn | bookings     |
      | aws.s3.key             | booking.json |
    Given Disable auto removal of Kamelet resources
    Given Disable auto removal of Testcontainers resources

  Scenario: Start infrastructure
    # Start AWS S3 container
    Given Enable service S3
    Given start LocalStack container

    # Create S3 client
    Given New global Camel context
    Given load to Camel registry amazonS3Client.groovy

  Scenario: Verify AWS S3 event
    # Create Camel K integration
    Given load Pipe aws-s3-booking-source.yaml
    And Pipe aws-s3-booking-source is available
    Then Camel K integration aws-s3-booking-source should print started in
    # Verify Kamelet source
    Given Camel exchange message header CamelAwsS3Key="${aws.s3.key}"
    And Camel exchange body: {"client": "client_aws", "product": "Apple", "amount": 10, "price": 0.59}
    Then send Camel exchange to("aws2-s3://${aws.s3.bucketNameOrArn}?amazonS3Client=#amazonS3Client")

  Scenario: Stop infrastructure
    # Remove Camel K resources
    Given delete Pipe aws-s3-booking-source
    # Stop LocalStack container
    Given stop LocalStack container
