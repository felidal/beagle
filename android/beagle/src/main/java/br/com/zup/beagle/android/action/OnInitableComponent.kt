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

package br.com.zup.beagle.android.action

import br.com.zup.beagle.android.widget.RootView
import br.com.zup.beagle.android.widget.WidgetView
import br.com.zup.beagle.core.ServerDrivenComponent

/**
 * Interface that has onInit property
 * @property onInit list of actions performed as soon as the component is rendered
 */
abstract class OnInitiableComponent : WidgetView() {

    abstract val onInit: List<Action>?

    @Transient
    internal var onInitFinishedListener: OnInitFinishedListener? = null

    abstract fun executeOnInit(rootView: RootView, listener: OnInitFinishedListener?)
}

typealias OnInitFinishedListener = (serverState: ServerDrivenComponent) -> Unit
