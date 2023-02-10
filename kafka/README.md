# YAKS Kafka Demo

The test shows how to interact with Kafka messaging.
The Camel K integration provides a REST API for clients and performs content based routing of incoming requests producing messages on different Kafka topics.
The YAKS test invokes the different REST API operations and verifies the Kafka messages and the HTTP responses.

# Test Scenario

![test-scenario](test-scenario.png)

# Run YAKS tests

You can run the test with:

```shell script
$ yaks run test/fruit-service.feature --local
```

When running on Kubernetes/Openshift make sure that you are connected to your namespace on that cluster and run:

```shell script
$ yaks run test/fruit-service.feature
```

Happy testing!
