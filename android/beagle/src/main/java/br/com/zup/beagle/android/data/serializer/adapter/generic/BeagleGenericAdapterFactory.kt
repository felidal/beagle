/*
 * Copyright 2020 ZUP IT SERVICOS EM TECNOLOGIA E INOVACAO SA
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package br.com.zup.beagle.android.data.serializer.adapter.generic

import com.squareup.moshi.JsonAdapter
import com.squareup.moshi.JsonReader
import com.squareup.moshi.JsonWriter
import com.squareup.moshi.Moshi
import java.lang.reflect.Type

@Suppress("UNREACHABLE_CODE")
class BeagleGenericAdapterFactory : JsonAdapter.Factory {

    override fun create(type: Type, annotations: MutableSet<out Annotation>, moshi: Moshi): JsonAdapter<*>? {
        val genericAdapter = TypeAdapterResolverImpl().getAdapter(type)
        val adapter = moshi.adapter(genericAdapter::class.java)
        return TypeAdapter<Type>(adapter, TypeAdapterResolverImpl().getAdapter(type))
    }

    private  class TypeAdapter<T>(
        private val adapter: JsonAdapter<out BeagleTypeAdapter<*>>,
        private val beagleTypeAdapter: BeagleTypeAdapter<*>
    ) : JsonAdapter<T>() {

        override fun fromJson(reader: JsonReader) = beagleTypeAdapter.fromJson(reader.peekJson().readJsonValue().toString()) as T
        override fun toJson(writer: JsonWriter, value: T?) {
            writer.value(beagleTypeAdapter.toJson(value))
        }
    }
}