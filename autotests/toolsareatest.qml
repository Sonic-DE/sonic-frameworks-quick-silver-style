/*
    SPDX-FileCopyrightText: 2026 Joseph Crowell <joseph.w.crowell@gmail.com>

    SPDX-License-Identifier: GPL-2.0-or-later
*/

import QtQuick
import org.kde.kirigami as Kirigami

Window {
    width: 100
    height: 100
    visible: true
    readonly property bool active: Kirigami.Theme.toolsArea.active
    readonly property color backgroundColor: Kirigami.Theme.toolsArea.backgroundColor
    readonly property color inactiveBackgroundColor: Kirigami.Theme.toolsArea.inactiveBackgroundColor
    readonly property color separatorColor: Kirigami.Theme.toolsArea.separatorColor
    readonly property bool blurBehind: Kirigami.Theme.toolsArea.blurBehind
    readonly property bool titleBarHidden: Kirigami.Theme.toolsArea.titleBarHidden
    readonly property bool translucent: Kirigami.Theme.toolsArea.translucent
}
