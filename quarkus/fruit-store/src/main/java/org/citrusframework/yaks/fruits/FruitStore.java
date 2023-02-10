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

import java.math.BigDecimal;
import java.util.Arrays;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.Set;
import java.util.concurrent.atomic.AtomicLong;
import javax.inject.Singleton;

/**
 * @author Christoph Deppisch
 */
@Singleton
public class FruitStore {

    private final Set<Fruit> fruits = Collections.newSetFromMap(Collections.synchronizedMap(new LinkedHashMap<>()));

    private final AtomicLong idSequence = new AtomicLong(1000);

    public FruitStore() {
        Category pome = new Category(1, "pome");
        Category tropical = new Category(2, "tropical");
        Category berry = new Category(3, "berry");

        Fruit apple = new Fruit(nextId(), "Apple", "Winter fruit");
        apple.category = pome;
        apple.tags = Arrays.asList("winter", "juicy");
        apple.nutrition = new Nutrition(52, 10);
        apple.price = new BigDecimal("1.59");
        apple.status = Fruit.Status.AVAILABLE;
        add(apple);

        Fruit pineapple = new Fruit(nextId(),"Pineapple", "Tropical fruit");
        pineapple.tags = Arrays.asList("cocktail");
        pineapple.category = tropical;
        pineapple.nutrition = new Nutrition(50, 9);
        pineapple.price = new BigDecimal("1.99");
        add(pineapple);

        Fruit strawberry = new Fruit(nextId(),"Strawberry", "Delicious");
        strawberry.tags = Arrays.asList("summer", "smoothie");
        strawberry.category = berry;
        strawberry.status= Fruit.Status.SOLD;
        strawberry.nutrition = new Nutrition(29, 5);
        strawberry.price = new BigDecimal("2.55");
        add(strawberry);
    }

    public Long nextId() {
        return idSequence.getAndIncrement();
    }

    public void add(Fruit fruit) {
        fruits.add(fruit);
    }

    public Set<Fruit> list() {
        return fruits;
    }

    public boolean remove(Long id) {
        return fruits.removeIf(existing -> existing.id.equals(id));
    }
}
