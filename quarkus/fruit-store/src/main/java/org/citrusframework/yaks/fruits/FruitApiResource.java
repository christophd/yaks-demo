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

import java.util.Optional;
import java.util.Set;
import java.util.regex.Pattern;
import javax.inject.Inject;
import javax.ws.rs.Consumes;
import javax.ws.rs.DELETE;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import org.eclipse.microprofile.openapi.annotations.Operation;
import org.eclipse.microprofile.reactive.messaging.Channel;
import org.eclipse.microprofile.reactive.messaging.Emitter;
import org.eclipse.microprofile.rest.client.inject.RestClient;

@Path("/api/fruits")
@Produces(MediaType.APPLICATION_JSON)
public class FruitApiResource {

    @Inject
    FruitStore store;

    @Inject
    @Channel("fruit-events")
    Emitter<Fruit> fruitEventsEmitter;

    @Inject
    @RestClient
    FoodMarketClient marketClient;

    @GET
    @Operation(operationId = "listFruits")
    public Set<Fruit> list() {
        return store.list();
    }

    @POST
    @Operation(operationId = "addFruit")
    @Consumes(MediaType.APPLICATION_JSON)
    public Response add(Fruit fruit) {
        if (fruit.id == null) {
            fruit.id = store.nextId();
        } else if (store.list().stream().anyMatch(f -> f.id.equals(fruit.id))) {
            throw new IllegalArgumentException(String.format("Fruit with id '%s' already exists", fruit.id));
        }

        fruitEventsEmitter.send(fruit);
        return Response.status(Response.Status.CREATED)
                .entity(fruit).build();
    }

    @GET
    @Path("/{id}")
    @Operation(operationId = "getFruitById")
    public Response find(@PathParam("id") String id) {
        if (!Pattern.compile("\\d+").matcher(id).matches()) {
            return Response.status(Response.Status.BAD_REQUEST).build();
        }

        Optional<Fruit> found = store.list().stream()
                .filter(fruit -> fruit.id.toString().equals(id))
                .findFirst();

        if (found.isPresent()) {
            return Response.ok(found.get()).build();
        }

        return Response.status(Response.Status.NOT_FOUND).build();
    }

    @GET
    @Path("/price/{id}")
    @Operation(operationId = "getPriceUpdate")
    public Response updatePrice(@PathParam("id") String id) {
        Response response = find(id);

        if (response.getEntity() != null) {
            Fruit fruit = (Fruit) response.getEntity();
            Price price = marketClient.getPrice(fruit.name.toLowerCase());
            fruit.price = price.value;
            return Response.ok(fruit).build();
        }

        return response;
    }

    @GET
    @Path("/nutrition/{id}")
    @Operation(operationId = "getNutrition")
    public Response getNutrition(@PathParam("id") String id) {
        Response response = find(id);

        if (response.getEntity() != null) {
            Fruit fruit = (Fruit) response.getEntity();
            fruit.nutrition = marketClient.getNutrition(fruit.name.toLowerCase());
            return Response.ok(fruit).build();
        }

        return response;
    }

    @DELETE
    @Path("/{id}")
    @Operation(operationId = "deleteFruit")
    public Response delete(@PathParam("id") String id) {
        if (!Pattern.compile("\\d+").matcher(id).matches()) {
            return Response.status(Response.Status.BAD_REQUEST).build();
        }

        if (store.remove(Long.parseLong(id))) {
            return Response.noContent().build();
        }

        return Response.status(Response.Status.NOT_FOUND).build();
    }
}
