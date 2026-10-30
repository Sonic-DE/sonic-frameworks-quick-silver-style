/* SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
 */

import QtQml
import QtQuick
import QtQuick.Templates as T
import org.kde.kirigami as Kirigami
import org.kde.guiaddons as GuiAddons

T.ApplicationWindow {
    id: window

    Kirigami.Theme.colorSet: Kirigami.Theme.Window
    // A translucent tools area shows what is behind the window: the window colour is then
    // painted everywhere but there.
    readonly property bool __translucentToolsArea: Kirigami.Theme.toolsArea.active && Kirigami.Theme.toolsArea.translucent
    color: __translucentToolsArea ? "transparent" : Kirigami.Theme.backgroundColor
    background: Kirigami.ToolsAreaWindowBackground {
        visible: window.__translucentToolsArea
        color: Kirigami.Theme.backgroundColor
    }

    Item {
        id: headerColor

        Kirigami.Theme.colorSet: Kirigami.Theme.Header
        Kirigami.Theme.inherit: false

        Binding {
            target: GuiAddons.WindowInsetsController
            property: "statusBarBackgroundColor"
            value: Kirigami.Theme.backgroundColor
        }
    }

    Binding {
        target: GuiAddons.WindowInsetsController
        property: "navigationBarBackgroundColor"
        value: window.footer ? window.footer.Kirigami.Theme.backgroundColor : Kirigami.Theme.backgroundColor
    }
}
