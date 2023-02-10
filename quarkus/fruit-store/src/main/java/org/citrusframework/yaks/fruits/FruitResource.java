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

package org.citrusframework.yaks.fruits;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import javax.inject.Inject;
import javax.ws.rs.Consumes;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.HttpHeaders;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import io.cloudevents.CloudEvent;
import io.cloudevents.v1.AttributesImpl;
import io.cloudevents.v1.http.Unmarshallers;
import io.quarkus.qute.Template;
import io.quarkus.qute.TemplateInstance;
import org.eclipse.microprofile.reactive.messaging.Channel;
import org.eclipse.microprofile.reactive.messaging.Emitter;
import org.jboss.logging.Logger;
import org.reactivestreams.Publisher;

/**
 * @author Christoph Deppisch
 */
@Path("/")
public class FruitResource {

    private final Logger logger = Logger.getLogger(FruitResource.class);

    @Inject
    Template index;

    @Inject
    @Channel("fruit-events")
    Emitter<Fruit> fruitEventsEmitter;

    @Inject
    @Channel("fruit-events-stream")
    Publisher<String> fruitEvents;

    @Inject
    FruitStore store;

    @Inject
    ObjectMapper mapper;

    @GET
    @Produces(MediaType.TEXT_HTML)
    public TemplateInstance index() {
        Logger.getLogger("FRUITS").info(store.list());
        return index.data("fruits", store.list());
    }

    @GET
    @Path("/fruits")
    @Produces(MediaType.SERVER_SENT_EVENTS)
    public Publisher<String> fruitProcessor() {
        return fruitEvents;
    }

    @POST
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response fruitsHandler(@Context HttpHeaders httpHeaders, String cloudEvent) {
        Map<String, Object> headers = new HashMap<>();
        httpHeaders.getRequestHeaders().forEach((k, v) -> headers.put(k, v.get(0)));

        logger.info("Headers:" + headers);
        logger.info("Data:" + cloudEvent);

        try {
            Fruit fruit = mapper.readValue(cloudEvent, Fruit.class);

            CloudEvent<AttributesImpl, Map> event = Unmarshallers
                    .binary(Map.class)
                    .withHeaders(() -> headers)
                    .withPayload(() -> cloudEvent)
                    .unmarshal();

            AttributesImpl attrs = event.getAttributes();
            logger.info("Attributes:" + attrs);
            logger.info("Extensions:" + event.getExtensions());

            if (fruit.id == null) {
                fruit.id = Long.parseLong(attrs.getId());
            }

            if (fruit.tags == null) {
                fruit.tags = new ArrayList<>();
            }
            fruit.tags.add(attrs.getType());

            fruit.name = attrs.getSubject().orElse(fruit.name);

            fruitEventsEmitter.send(fruit);

            return Response.status(Response.Status.CREATED).build();
        } catch (JsonProcessingException e) {
            logger.error(e);
            return Response.serverError().entity(e.getMessage()).build();
        }
    }
}
