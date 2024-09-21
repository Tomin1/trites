/* 
    This file is part of Trites.
    Copyright (C) 2011 odamite <odamite@gmail.com>
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
import "game.js" as Game

/* This is the over long main file... */

ApplicationWindow {
    readonly property real scalingFactor: Math.min(Screen.width / 480, Screen.height / 854)

    function scaledValue(value) {
        return value * scalingFactor
    }

    function scaledByHeight(value) {
        return value * Screen.height / 854;
    }

    id: window
    initialPage: Page { // NB: Cannot use Component here
        id: root
        state: "introState"

        allowedOrientations: Orientation.Portrait

        Rectangle {
            id: rectangle1
            anchors.fill: parent
            color: "black"
        }

        Connections {
            target: Qt.application

            onStateChanged: {
                if (Qt.application.state !== Qt.ApplicationActive && root.state == "gameState") {
                    gameTimer.running = false
                    root.state = "pauseMenuState"
                }
            }
        }

        MouseArea {
            id: gameControler
            enabled: gameTimer.running
            anchors.fill: parent

            onPressed: Game.mousePressed(mouse)
            onReleased: Game.mouseReleased()
            onPositionChanged: Game.mouseMoved(mouse)
        }

        Keys.onPressed: {
            if (event.key === Qt.Key_Up) {
                Game.rotatePiece()
            }
            else if (event.key === Qt.Key_Left) {
                Game.movePiece(-1)
            }
            else if (event.key === Qt.Key_Right) {
                Game.movePiece(1)
            }
            else if (event.key === Qt.Key_Down) {
                Game.updateGame()
            }
        }

        MouseArea {
            id: mousearea1
            x: scaledValue(72)
            y: scaledValue(13)
            anchors.fill: parent
            enabled: false
            onClicked: root.state = "menuState"
        }

        Item {
            id: helpContainer
            x: Screen.width
            y: scaledValue(130)
            width: Screen.width
            height: scaledByHeight(724)
            z: 10

            Rectangle {
                anchors.fill: parent
                color: "black"
                opacity: 0.75
            }

            SilicaFlickable {
                id: flickAbout
                width: scaledValue(416)
                height: scaledByHeight(563)
                contentHeight: aboutText.height
                anchors.right: parent.right
                anchors.rightMargin: scaledValue(32)
                anchors.left: parent.left
                anchors.leftMargin: scaledValue(32)
                anchors.top: parent.top
                anchors.topMargin: scaledByHeight(32)
                clip: true

                Column {
                    id: aboutText
                    spacing: Theme.paddingLarge
                    width: parent.width

                    Label {
                        width: parent.width
                        color: "white"
                        text: qsTr("Original concept by Alexey Pajitnov.")
                        wrapMode: Text.WordWrap
                    }

                    Label {
                        width: parent.width
                        color: "white"
                        text: qsTr("Trites is a game developed by odamite. Graphics designed by joppu. Sailfish port by tomin.")
                        wrapMode: Text.WordWrap
                    }

                    Label {
                        width: parent.width
                        color: "white"
                        text: qsTr("Trites is open source and licensed under GPL version 3.")
                        wrapMode: Text.WordWrap
                    }

                    Label {
                        width: parent.width
                        color: "white"
                        text: qsTr("Game data licensed under CC BY-SA.")
                        wrapMode: Text.WordWrap
                    }
                }

                VerticalScrollDecorator {}
            }

            Item {
                id: highScoreText
                width: scaledValue(416)
                height: scaledByHeight(563)
                anchors.right: parent.right
                anchors.rightMargin: scaledValue(32)
                anchors.left: parent.left
                anchors.leftMargin: scaledValue(32)
                anchors.top: parent.top
                anchors.topMargin: scaledValue(32)

                ListView {
                    anchors.fill: parent
                    clip: true
                    model: ListModel {
                        id: highScoreModel
                    }
                    delegate: Label {
                        color: "white"
                        text: index + ". " + player + " - " + score
                    }
                }

                Text {
                    id: noHighYet
                    anchors.fill: parent
                    text: "No highscores yet"
                    font.pixelSize: scaledValue(32) * 1.5
                    visible: false
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    color: "#202020"

                    states: State {
                        when: (highScoreModel.count == 0)
                        PropertyChanges {
                            target: noHighYet
                            visible: true
                        }
                    }
                }
            }

            MenuButton {
                x: scaledValue(96)
                y: scaledValue(628)
                label: "Back"
                onClicked: {
                    helpContainer.x = Screen.width
                    menuContainer.x = 0
                }
            }

            Behavior on x {
                NumberAnimation {
                    easing.type: Easing.OutQuad
                }
            }
        }

        Image {
            id: image1
            x: scaledValue(53)
            y: scaledValue(13)
            width: scaledValue(374)
            height: scaledValue(104)
            sourceSize.width: scaledValue(374)
            fillMode: Image.PreserveAspectFit
            smooth: true
            source: "data/logo.svg"

            SequentialAnimation {
                id: stupidAnimation
                running: true
                NumberAnimation { target: image1; property: "opacity"; from: 0.0; to: 1.0; duration: 1000 }
                NumberAnimation { target: author; property: "opacity"; from: 0.0; to: 1.0; duration: 1000 }
                ScriptAction { script: mousearea1.enabled = true }
                PauseAnimation { duration: 5000 }
                PropertyAction { target: root; property: "state"; value: "menuState" }
            }

            Image {
                source: "data/author.svg"
                id: author
                x: 0
                y: scaledValue(489)
                width: scaledValue(446)
                height: scaledValue(74)
                opacity: 1
                fillMode: "PreserveAspectFit"
            }
        }

        Item {
            id: menuContainer
            y: scaledValue(130)
            width: Screen.width
            height: scaledValue(724)
            visible: true
            z: 1

            Rectangle {
                id: backFader
                anchors.fill: parent
                color: "black"
                opacity: 0
            }

            MenuButton {
                id: buttonStartGame
                x: scaledValue(96)
                y: Screen.height
                label: "Start game"
                onClicked: {
                    stupidAnimation.stop()
                    root.state = "gameState"
                }
            }

            MenuButton {
                id: buttonRestart
                x: scaledValue(96)
                y: Screen.height
                label: "Restart"
                onClicked: {
                    Game.startGame()
                    gameTimer.running = false
                    root.state = "gameState"
                }
            }

            MenuButton {
                id: buttonResume
                x: scaledValue(96)
                y: Screen.height
                label: "Resume"
                onClicked: root.state = "gameState"
            }

            MenuButton {
                id: buttonHighscores
                x: scaledValue(96)
                y: Screen.height
                label: "Highscores"
                onClicked: {
                    Game.showHighScores()
                    helpContainer.x = 0
                    menuContainer.x = -Screen.width
                    aboutText.visible = false
                    highScoreText.visible = true
                }
            }

            MenuButton {
                id: buttonAbout
                x: scaledValue(96)
                y: Screen.height
                label: "About"
                onClicked: {
                    helpContainer.x = 0
                    menuContainer.x = -Screen.width
                    aboutText.visible = true
                    highScoreText.visible = false
                }
            }

            Behavior on x {
                NumberAnimation {
                    easing.type: Easing.OutQuad
                }
            }
        }

        Item {
            id: gameContainer
            x: 0
            y: scaledValue(130)
            width: Screen.width
            height: scaledValue(724)
            visible: true

            Text {
                id: scoreText
                x: scaledValue(362)
                y: scaledValue(254)
                width: scaledValue(113)
                height: scaledValue(66)
                color: "white"
                text: "Score:\n0"
                font.pixelSize: scaledValue(20) * 1.5
                verticalAlignment: Text.AlignTop
                wrapMode: Text.NoWrap
                horizontalAlignment: Text.AlignRight
                z: 3
            }

            Text {
                id: nextText
                x: scaledValue(362)
                y: scaledValue(16)
                width: scaledValue(113)
                height: scaledValue(33)
                color: "white"
                text: "Next:"
                font.pixelSize: scaledValue(20) * 1.5
                verticalAlignment: Text.AlignTop
                wrapMode: Text.NoWrap
                horizontalAlignment: Text.AlignRight
                z: 3
            }

            Item {
                id: nextPiecePlaceholder
                x: scaledValue(379)
                y: scaledValue(56)
                width: scaledValue(96)
                height: scaledValue(108)
            }

            Text {
                id: levelText
                x: scaledValue(362)
                y: scaledValue(169)
                width: scaledValue(113)
                height: scaledValue(66)
                color: "white"
                text: "Level:\n1"
                font.pixelSize: scaledValue(20) * 1.5
                verticalAlignment: Text.AlignTop
                wrapMode: Text.NoWrap
                horizontalAlignment: Text.AlignRight
                z: 3
            }

            Image {
                id: gameArea
                source: "data/background.png"
                x: scaledValue(25)
                y: scaledValue(16)
                width: scaledValue(347)
                height: scaledValue(693)
                clip: true
            }

            Image {
                id: pauseButton
                x: scaledValue(397)
                y: scaledValue(632)
                width: scaledValue(60)
                height: scaledValue(60)
                source: pauseButtonArea.pressed ? "data/pausebutton_pressed.svg" : "data/pausebutton_unpressed.svg"

                MouseArea {
                    id: pauseButtonArea
                    anchors.fill: parent
                    onClicked: {
                        root.state = "pauseMenuState"
                        gameTimer.running = false
                    }
                }
            }

            Timer {
                id: gameTimer
                interval: 400
                running: false
                repeat: true
                onTriggered: Game.updateGame()
            }
        }

        Rectangle {
            id: rectangle2
            x: 0
            y: scaledValue(130)
            width: Screen.width*2
            height: scaledValue(724)
            //anchors.fill: parent
            color: "black"
            visible: false
            anchors.topMargin: 130
            opacity: 0

            TextField {
                id: nameField
                placeholderText: "Write your name here"
                maximumLength: 50
                y: scaledValue(140)
                anchors.right: parent.right
                anchors.rightMargin: Screen.width+scaledValue(25)
                anchors.left: parent.left
                anchors.leftMargin: scaledValue(25)
            }

            MenuButton {
                x: scaledValue(95)
                y: scaledValue(210)
                label: "Save my score"
                onClicked: { Game.saveHighScore(); rectangle2.x = -Screen.width }
            }

            MenuButton {
                x: scaledValue(95)
                y: scaledValue(290)
                label: "No, thank you"
                onClicked: { Game.showHighScores(); rectangle2.x = -Screen.width }
            }

            MenuButton {
                x: Screen.width + scaledValue(95)
                y: scaledValue(636)
                label: "Go To Menu"
                onClicked: {
                    root.state = "menuState"
                    author.visible = false
                }
            }

            MenuButton {
                x: Screen.width + scaledValue(95)
                y: scaledValue(544)
                label: "Play Again"
                onClicked: {
                    root.state = "gameState"
                }
            }

            Text {
                id: text1
                x: scaledValue(53)
                y: scaledValue(24)
                width: scaledValue(371)
                height: scaledValue(30)
                color: "white"
                text: "Score:"
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: scaledValue(24)
            }

            ListView {
                x: Screen.width+scaledValue(50)
                width: Screen.width-scaledValue(100)
                height: scaledValue(500)
                clip: true
                model: highScoreModel
                delegate: Label {
                    color: "white"
                    text: index + ". " + player + " - " + score
                }

                Text {
                    id: noHighYetEnd1
                    anchors.fill: parent
                    text: "No highscores yet"
                    font.pixelSize: scaledValue(32) * 1.5
                    visible: false
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    color: "#202020"

                    states: State {
                        when: (highScoreModel.count == 0)
                        PropertyChanges {
                            target: noHighYetEnd1
                            visible: true
                        }
                    }
                }
            }

            Text {
                id: textFinalScore
                x: scaledValue(53)
                y: scaledValue(61)
                width: scaledValue(371)
                height: scaledValue(59)
                color: "white"
                text: "0"
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: scaledValue(48)
            }

            Behavior on x {
                NumberAnimation {
                    easing.type: Easing.OutQuad
                }
            }
        }

        states: [
            State {
                name: "introState"

                PropertyChanges {
                    target: menuContainer
                    visible: false
                    opacity: 0
                }

                PropertyChanges {
                    target: gameContainer
                    opacity: 0
                    visible: false
                }

                PropertyChanges {
                    target: image1
                    x: scaledValue(42)
                    y: scaledValue(13)
                    width: scaledValue(396)
                    height: scaledValue(719)
                    opacity: 1
                }

                PropertyChanges {
                    target: author
                    x: scaledValue(0)
                    y: scaledValue(420)
                    width: scaledValue(396)
                    height: scaledValue(50)
                    opacity: 0
                }

                PropertyChanges {
                    target: mousearea1
                    enabled: false
                }
            },
            State {
                name: "menuState"

                PropertyChanges {
                    target: menuContainer
                    x: 0
                    y: scaledValue(130)
                    width: Screen.width
                    height: scaledValue(724)
                    visible: true
                    opacity: 1
                }

                PropertyChanges {
                    target: image1
                    x: scaledValue(53)
                    width: scaledValue(374)
                    height: scaledValue(104)
                }

                PropertyChanges {
                    target: author
                    x: scaledValue(-36)
                    y: scaledValue(113)
                    width: scaledValue(446)
                    height: scaledValue(44)
                    opacity: 0
                }

                PropertyChanges {
                    target: buttonStartGame
                    opacity: 1
                    y: scaledValue(11)
                }

                PropertyChanges {
                    target: buttonHighscores
                    opacity: 1
                    y: scaledValue(91)
                }

                PropertyChanges {
                    target: buttonAbout
                    opacity: 1
                    y: scaledValue(171)
                }

                PropertyChanges {
                    target: gameContainer
                    opacity: 0
                    visible: true
                }

                PropertyChanges {
                    target: mousearea1
                    enabled: false
                }

                PropertyChanges {
                    target: rectangle2
                    opacity: 0
                    visible: true
                }
            },
            State {
                name: "gameState"

                PropertyChanges {
                    target: mousearea1
                    visible: false
                }

                PropertyChanges {
                    target: gameContainer
                    visible: true
                }

                PropertyChanges {
                    target: image1
                    x: scaledValue(53)
                    y: scaledValue(13)
                    width: scaledValue(374)
                    height: scaledValue(104)
                    fillMode: "PreserveAspectFit"
                    z: 5
                }

                PropertyChanges {
                    target: author
                    visible: false
                }

                PropertyChanges {
                    target: menuContainer
                    visible: true
                    opacity: 0
                }

                PropertyChanges {
                    target: backFader
                    opacity: 0
                }

                PropertyChanges {
                    target: gameTimer
                    running: false
                }
            },
            State {
                name: "pauseMenuState"
                PropertyChanges {
                    target: menuContainer
                    visible: true
                }

                PropertyChanges {
                    target: gameContainer
                    visible: true
                }

                PropertyChanges {
                    target: author
                    visible: false
                }

                PropertyChanges {
                    target: backFader
                    opacity: 0.75
                }

                PropertyChanges {
                    target: gameTimer
                    running: false
                }

                PropertyChanges {
                    target: buttonStartGame
                    visible: false
                }

                PropertyChanges {
                    target: buttonRestart
                    y: scaledValue(136)
                }

                PropertyChanges {
                    target: buttonHighscores
                    y: scaledValue(230)
                }

                PropertyChanges {
                    target: buttonAbout
                    y: scaledValue(310)
                }

                PropertyChanges {
                    target: buttonResume
                    y: scaledValue(58)
                }
            },
            State {
                name: "hiscoresEnd"

                PropertyChanges {
                    target: gameContainer
                    opacity: 0
                    visible: true
                }

                PropertyChanges {
                    target: menuContainer
                    opacity: 0
                    visible: true
                }

                PropertyChanges {
                    target: author
                    visible: false
                }

                PropertyChanges {
                    target: rectangle2
                    visible: true
                    opacity: 1
                }
            }

        ]

        transitions: [
            Transition {
                NumberAnimation { properties: "x, y, width, height, opacity"; easing.type: Easing.InOutQuad; duration: 500 }
            },
            Transition {
                from: "menuState"
                to: "gameState"
                SequentialAnimation {
                    ScriptAction { script: { Game.startGame(); gameTimer.running = false } }
                    NumberAnimation { properties: "x, y, width, height, opacity"; easing.type: Easing.InOutQuad; duration: 500 }
                    ScriptAction { script: gameTimer.running = true }
                }
            },
            Transition {
                from: "gameState"
                to: "pauseMenuState"
                NumberAnimation { properties: "y, opacity"; easing.type: Easing.InOutQuad; duration: 250 }
            },
            Transition {
                from: "pauseMenuState"
                to: "gameState"
                SequentialAnimation {
                    NumberAnimation { properties: "y, opacity"; easing.type: Easing.InOutQuad; duration: 250 }
                    ScriptAction { script: gameTimer.running = true }
                }
            },
            Transition {
                from: "hiscoresEnd"
                to: "gameState"
                SequentialAnimation {
                    ScriptAction { script: { Game.startGame(); gameTimer.running = false } }
                    NumberAnimation { properties: "opacity"; easing.type: Easing.InOutQuad; duration: 250 }
                    ScriptAction { script: gameTimer.running = true }
                }
            }
        ]
    }
}