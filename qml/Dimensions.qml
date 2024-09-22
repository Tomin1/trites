/*
    This file is part of Trites.
    Copyright (C) 2024 tomin <code@tomin.site>

    Trites is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Trites is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Trites.  If not, see <http://www.gnu.org/licenses/>.
*/

import Sailfish.Silica 1.0
import QtQuick 2.6

Item {
    readonly property real scalingFactor: Math.min(Screen.width / 480, Screen.height / 854)

    readonly property int containerContentWidth: scalingFactor * 416
    readonly property int containerHeight: scalingFactor * 724
    readonly property int containerTopMargin: scalingFactor * 130

    readonly property int fontSizeBig: scalingFactor * 48
    readonly property int fontSizeSmall: scalingFactor * 24

    readonly property int menuButtonHeight: scalingFactor * 60
    readonly property int menuButtonWidth: scalingFactor * 288
    readonly property int menuButtonFontSize: scalingFactor * 32

    readonly property int placeholderFontSize: scalingFactor * 48

    readonly property int marginLess: scalingFactor * 25
    readonly property int marginMedium: scalingFactor * 32
    readonly property int marginSmall: scalingFactor * 16
    readonly property int marginTiny: scalingFactor * 5
    readonly property int marginTop: Screen.height / 854 * 32

    readonly property int pauseButtonSize: scalingFactor * 60

    readonly property int sidebarFontSize: scalingFactor * 30
    readonly property int sidebarRowHeight: scalingFactor * 33
    readonly property int sidebarWidth: scalingFactor * 118

    readonly property int titleLogoWidth: scalingFactor * 374
    readonly property int titleLogoHeight: scalingFactor * 104
}
