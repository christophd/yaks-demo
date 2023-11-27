/*
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.citrusframework.yaks.fruits;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import io.smallrye.reactive.messaging.annotations.Broadcast;
import io.smallrye.reactive.messaging.annotations.Merge;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import org.citrusframework.yaks.fruits.model.Fruit;
import org.eclipse.microprofile.reactive.messaging.Incoming;
import org.eclipse.microprofile.reactive.messaging.Outgoing;
import org.jboss.logging.Logger;

/**
 * @author Christoph Deppisch
 */
@ApplicationScoped
public class FruitsEventProcessor {

    private final Logger logger = Logger.getLogger(FruitsEventProcessor.class);

    @Inject
    FruitStore store;

    @Inject
    ObjectMapper mapper;

    @Incoming("fruit-events")
    @Outgoing("fruit-events-stream")
    @Merge
    @Broadcast
    public String processEvent(Fruit fruit) throws JsonProcessingException {
        logger.info("Processing fruit id:" + fruit.id);

        store.add(fruit);

        return mapper.writeValueAsString(fruit);
    }
}
