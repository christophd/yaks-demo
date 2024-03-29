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

package org.citrusframework.yaks.fruits.model;

import java.math.BigDecimal;
import java.util.List;

/**
 * @author Christoph Deppisch
 */
public class Fruit {

    public Long id;
    public String name;
    public String description;
    public Category category;
    public List<String> tags;
    public Status status = Status.PENDING;
    public Nutrition nutrition;
    public BigDecimal price = new BigDecimal("0.1");

    public Fruit() {
    }

    public Fruit(Long id, String name, String description) {
        this.id = id;
        this.name = name;
        this.description = description;
    }

    public enum Status {
        SOLD,
        PENDING,
        AVAILABLE
    }
}
