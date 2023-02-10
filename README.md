# YAKS Demo

This represents the YAKS demo for Cloud-native BDD testing. 

The demo shows how to test services with [Open API](https://www.openapis.org/) specifications using Cloud Native BDD testing. 
The System Under Test (SUT) in this sample is a Camel K integration that exposes a Http REST Open API service. The automated integration tests
written with [YAKS](https://github.com/citrusframework/yaks) use the Open API specification to perform contract driven testing. 

You can run the YAKS tests locally and inside a Kubernetes/OpenShift cluster.

# Setup

The tests use the YAKS command line interface that you may download here: [YAKS releases on GitHub](https://github.com/citrusframework/yaks/tags).
Once the YAKS CLI is installed you can run the tests via `yaks run` command.

## Local setup

When running the tests locally you also need [JBang](https://www.jbang.dev/) installed.
Also, you will need a proper Docker environment on your local machine as the tests use [Testcontainers](https://www.testcontainers.org/) 
as infrastructure (e.g. for running Kafka, AWS S3 Localstack, ...).

## Remote setup

When running tests on a Kubernetes cluster this demo assumes that you already have an Kubernetes/OpenShift cluster up and running and have access to it. 
Please install the following operators on your cluster (in this order):
- [Knative operator](https://operatorhub.io/operator/knative-operator) (only required for Knative tests)
- [Camel K operator](https://operatorhub.io/operator/camel-k) 
- [YAKS operator](https://operatorhub.io/operator/yaks)

# Run YAKS tests

The demo repository provides tests for different scenarios. 
Each of them is represented in a subdirectory holding both System under test and test cases to execute:

- [openapi](openapi)
- [aws-s3](aws-s3)
- [kafka](kafka)
- [knative](knative)

In each of these directories you will find one or more `.feature` files that you can run with YAKS.
Usually the test also takes care on setting up the required test infrastructure (e.g. the System under test, Knative broker, Kafka, AWS S3, ...).

You can run the test with:

```shell script
$ yaks run test/fruit-service.feature --local
```

When running on Kubernetes/Openshift make sure that you are connected to your namespace on that cluster and run:

```shell script
$ yaks run test/fruit-service.feature
```

Happy testing!
