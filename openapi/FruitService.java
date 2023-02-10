/*
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements. See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

// camel-k: language=java
// camel-k: open-api=openapi.json

import java.util.LinkedHashMap;
import java.util.Locale;
import java.util.Map;
import java.util.Optional;
import java.util.concurrent.atomic.AtomicLong;
import java.util.stream.Collectors;

import org.apache.camel.Exchange;
import org.apache.camel.builder.RouteBuilder;

public class FruitService extends RouteBuilder {

    private final Map<Long, String> fruits = new LinkedHashMap<>();

    private final AtomicLong idSequence = new AtomicLong(1000);

    public FruitService() {
        fruits.put(idSequence.get(), "{\"id\": " + idSequence.getAndIncrement() + ",\"name\": \"Apple\",\"description\": \"Delicious\",\"category\":{\"id\": 2,\"name\":\"pome\"},\"nutrition\":{\"calories\": 52,\"sugar\": 10},\"status\": \"AVAILABLE\",\"price\":1.59,\"tags\": [\"winter\",\"juicy\"]}");
        fruits.put(idSequence.get(), "{\"id\": " + idSequence.getAndIncrement() + ",\"name\": \"Pineapple\",\"description\": \"Delicious\",\"category\":{\"id\": 1,\"name\":\"tropical\"},\"nutrition\":{\"calories\": 50,\"sugar\": 9},\"status\": \"PENDING\",\"price\":1.99,\"tags\": [\"cocktail\"]}");
        fruits.put(idSequence.get(), "{\"id\": " + idSequence.getAndIncrement() + ",\"name\": \"Strawberry\",\"description\": \"Delicious\",\"category\":{\"id\": 3,\"name\":\"berry\"},\"nutrition\":{\"calories\": 29,\"sugar\": 5},\"status\": \"SOLD\",\"price\":2.55,\"tags\": [\"red\"]}");
    }

    @Override
    public void configure() throws Exception {
        // All endpoints starting from "direct:..." reference an operationId defined
        // in the "openapi.json" file.

        // Health check
        from("direct:health")
            .to("log:info")
            .removeHeaders("*")
            .setHeader("Content-Type", constant("application/json"))
            .setBody().constant("{\"status\": \"UP\"}");

        // Accept new fruits
        from("direct:addFruit")
            .to("log:info")
            .removeHeaders("*")
            .process(this::addFruit);

        // Get all fruits
        from("direct:getFruits")
            .to("log:info")
            .removeHeaders("*")
            .setHeader("Content-Type", constant("application/json"))
            .process(this::getFruits);

        // Get fruit
        from("direct:getFruitById")
            .to("log:info")
            .process(this::getFruitById)
            .setHeader("Content-Type", constant("application/json"));
    }

    public void addFruit(Exchange exchange) {
        String fruit = exchange.getIn().getBody(String.class);
        if (fruit != null) {
            fruits.put(idSequence.getAndIncrement(), fruit);
            exchange.getIn().setHeader(Exchange.HTTP_RESPONSE_CODE, 201);
        } else {
            exchange.getIn().setHeader(Exchange.HTTP_RESPONSE_CODE, 400);
        }
    }

    public void getFruits(Exchange exchange) {
        exchange.getIn().setBody(String.format("[%s]", fruits.values().stream().collect(Collectors.joining(", "))));
        exchange.getIn().setHeader(Exchange.HTTP_RESPONSE_CODE, 200);
    }

    public void getFruitById(Exchange exchange) {
        try {
            Long id = exchange.getIn().getHeader("id", Long.class);
            exchange.getIn().removeHeaders("*");

            String fruit = fruits.get(id);

            if (fruit != null) {
                exchange.getIn().setBody(fruit);
                exchange.getIn().setHeader(Exchange.HTTP_RESPONSE_CODE, 200);
            } else {
                exchange.getIn().setHeader(Exchange.HTTP_RESPONSE_CODE, 404);
            }
        } catch (Exception e) {
            exchange.getIn().setHeader(Exchange.HTTP_RESPONSE_CODE, 400);
        }
    }
}
