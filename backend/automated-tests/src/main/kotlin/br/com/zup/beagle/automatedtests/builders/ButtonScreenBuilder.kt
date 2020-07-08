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

package br.com.zup.beagle.automatedtests.builders

import BUTTON_STYLE
import BUTTON_STYLE_APPEARANCE
import CYAN_BLUE
import SCREEN_ACTION_CLICK_ENDPOINT
import br.com.zup.beagle.widget.action.Alert
import br.com.zup.beagle.core.CornerRadius
import br.com.zup.beagle.core.Style
import br.com.zup.beagle.ext.applyFlex
import br.com.zup.beagle.ext.applyStyle
import br.com.zup.beagle.ext.unitReal
import br.com.zup.beagle.widget.Widget
import br.com.zup.beagle.widget.action.Navigate
import br.com.zup.beagle.widget.action.Route
import br.com.zup.beagle.widget.core.EdgeValue
import br.com.zup.beagle.widget.layout.Container
import br.com.zup.beagle.widget.layout.NavigationBar
import br.com.zup.beagle.widget.layout.NavigationBarItem
import br.com.zup.beagle.widget.layout.Screen
import br.com.zup.beagle.widget.ui.Button
import br.com.zup.beagle.widget.ui.ImagePath.Local

object ButtonScreenBuilder {
     fun build() = Screen(
        navigationBar = NavigationBar(
            title = "Beagle Button",
            showBackButton = true,
            navigationBarItems = listOf(
                NavigationBarItem(
                    text = "",
                    image = Local.justMobile("informationImage"),
                    action = Alert(
                        title = "Button",
                        message = "This is a widget that will define a button natively using the server " +
                            "driven information received through Beagle.",
                        labelOk = "OK"
                    )
                )
            )
        ),
        child = Container(
            children = listOf(
                createButton(
                    text = "Button",
                    style = Style(
                        margin = EdgeValue(
                            top = 15.unitReal()
                        )
                    )
                ),

                createButton(
                    text = "Button with style",
                    styleId = BUTTON_STYLE,
                    style = Style(
                        margin = EdgeValue(
                            top = 15.unitReal()
                        )
                    )
                ),

                buttonWithAppearanceAndStyle(text = "Button with Appearance"),
                buttonWithAppearanceAndStyle(
                    text = "Button with Appearance and style",
                    styleId = BUTTON_STYLE_APPEARANCE
                )
            )
        )
    )

    private fun buttonWithAppearanceAndStyle(text: String, styleId: String? = null) = createButton(
        text = text,
        styleId = styleId,
        style = Style(
            margin = EdgeValue(
                left = 25.unitReal(),
                right = 25.unitReal(),
                top = 15.unitReal()
            )
        )
    ).applyStyle(
        Style(
            backgroundColor = CYAN_BLUE,
            cornerRadius = CornerRadius(radius = 16.0)
        )
    )

    private fun createButton(
        text: String,
        styleId: String? = null,
        style: Style? = null
    ): Widget {
        val button = Button(
            text = text,
            styleId = styleId,
            onPress = listOf(Navigate.PushView(Route.Remote(SCREEN_ACTION_CLICK_ENDPOINT, true)))
        )

        if (style != null) {
            button.applyStyle(style)
        }

        return button
    }
}