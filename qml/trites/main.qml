/* 
    This file is part of Trites.
	Copyright (C) 2011 odamite <odamite@gmail.com>

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

import QtQuick 1.1
import com.nokia.meego 1.0
import "game.js" as Game

/* This is the over long main file... */

PageStackWindow {
    id: window;
    showStatusBar: false
    initialPage: root

    Page {
        id: root
        state: "introState"

        orientationLock: PageOrientation.LockPortrait

        Rectangle {
            id: rectangle1
            anchors.fill: parent
            color: "black"
        }

        Connections {
            target: platformWindow
            onActiveChanged: {
                if (!platformWindow.active && root.state == "gameState") {
                    gameTimer.running = false;
                    root.state = "pauseMenuState"
                }
            }
        }

        MouseArea {
            id: gameControler
            enabled: gameTimer.running
            x:0
            y:0
            width:480
            height:710

            onPressed: Game.mousePressed(mouse)
            onReleased: Game.mouseReleased()
            onPositionChanged: Game.mouseMoved(mouse)
        }

        Keys.onPressed: {
            if (event.key == Qt.Key_Up) {
                Game.rotatePiece();
            }
            else if (event.key == Qt.Key_Left) {
                Game.movePiece(-1);
            }
            else if (event.key == Qt.Key_Right) {
                Game.movePiece(1);
            }
            else if (event.key == Qt.Key_Down) {
                Game.updateGame();
            }
        }

        MouseArea {
            id: mousearea1
            x: 72
            y: 13
            anchors.fill: parent
            enabled: false
            onClicked: root.state = "menuState";
        }

        Item {
            id: helpContainer
            x: 480
            y: 130
            width: 480
            height: 724
            z: 10

            Rectangle {
                anchors.fill: parent
                color: "black"
                opacity: 0.75
            }

            Flickable {
                id: flickHelp
                width: 416
                height: 563
                contentHeight: helpText.paintedHeight
                anchors.right: parent.right
                anchors.rightMargin: 32
                anchors.left: parent.left
                anchors.leftMargin: 32
                anchors.top: parent.top
                anchors.topMargin: 32
                clip: true

                Label {
                    id: helpText
                    width: parent.width
                    color: "white"
                    text: qsTr("Original consept by Alexey Pajitnov\n\nTrites is a game developed by odamite. Graphics designed by joppu\n\nTrites is open source and licenced under GPL version 3.\n\nGame data licenced under CC BY-SA.")
                    wrapMode: Text.WordWrap
                }
            }
            ScrollDecorator { flickableItem: flickHelp }

            Item {
                id: highScoreText
                width: 416
                height: 563
                anchors.right: parent.right
                anchors.rightMargin: 32
                anchors.left: parent.left
                anchors.leftMargin: 32
                anchors.top: parent.top
                anchors.topMargin: 32

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
                    font.pointSize: 32
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
                x: 96
                y: 628
                label: "Back"
                onClicked: {
                    helpContainer.x = 480;
                    menuContainer.x = 0;
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
            x: 53
            y: 13
            width: 374
            height: 104
            sourceSize.width: 512
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
                onCompleted: root.state = "menuState"
            }

            Image {
                source: "data/author.svg"
                id: author
                x: 0
                y: 489
                width: 446
                height: 74
                opacity: 1
                fillMode: "PreserveAspectFit"
            }
        }

        Item {
            id: menuContainer
            y: 130
            width: 480
            height: 724
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
                x: 96
                y: 854
                label: "Start game"
                onClicked: {
                    stupidAnimation.stop();
                    root.state = "gameState";
                }
            }

            MenuButton {
                id: buttonRestart
                x: 96
                y: 854
                label: "Restart"
                onClicked: {
                    Game.startGame();
                    gameTimer.running = false;
                    root.state = "gameState";
                }
            }

            MenuButton {
                id: buttonResume
                x: 96
                y: 854
                label: "Resume"
                onClicked: root.state = "gameState"
            }

            MenuButton {
                id: buttonHighscores
                x: 96
                y: 854
                label: "Highscores"
                onClicked: {
                    Game.showHighScores();
                    helpContainer.x = 0;
                    menuContainer.x = -480
                    helpText.visible = false;
                    highScoreText.visible = true;
                }
            }

            MenuButton {
                id: buttonHelp
                x: 96
                y: 854
                label: "Help"
                onClicked: {
                    helpContainer.x = 0;
                    menuContainer.x = -480
                    helpText.visible = true;
                    highScoreText.visible = false;
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
            y: 0
            width: 480
            height: 724
            visible: true

            Text {
                id: scoreText;
                x: 362
                y: 266
                width: 113
                height: 66
                color: "white"
                text: "Score:\n0"
                font.pointSize: 20
                verticalAlignment: Text.AlignTop
                wrapMode: Text.NoWrap
                horizontalAlignment: Text.AlignRight
                z: 3
            }

            Text {
                id: nextText;
                x: 362
                y: 28
                width: 113
                height: 33
                color: "white"
                text: "Next:"
                font.pointSize: 20
                verticalAlignment: Text.AlignTop
                wrapMode: Text.NoWrap
                horizontalAlignment: Text.AlignRight
                z: 3
            }

            Item {
                id: nextPiecePlaceholder
                x: 379
                y: 68
                width: 96
                height: 108
            }

            Text {
                id: levelText;
                x: 362
                y: 181
                width: 113
                height: 66
                color: "white"
                text: "Level:\n1"
                font.pointSize: 20
                verticalAlignment: Text.AlignTop
                wrapMode: Text.NoWrap
                horizontalAlignment: Text.AlignRight
                z: 3
            }

            Image {
                id: gameArea
                source: "data/background.png"
                x: 25
                y: 4
                width: 347
                height: 693
                clip: true
            }

            Image {
                id: pauseButton
                x: 397
                y: 600
                width: 60
                height: 60
                source: pauseButtonArea.pressed ? "data/pausebutton_pressed.svg" : "data/pausebutton_unpressed.svg"

                MouseArea {
                    id: pauseButtonArea
                    anchors.fill: parent
                    onClicked: {
                        root.state = "pauseMenuState";
                        gameTimer.running = false;
                    }
                }
            }

            Image {
                id: leftButton
                x: 30
                y: 720
                width: 80
                height: 80
                sourceSize.width: 80
                source: leftButtonArea.pressed ? "data/leftbutton_pressed.svg" : "data/leftbutton_unpressed.svg"

                signal repeatedClick();
                MouseArea {
                    id: leftButtonArea
                    anchors.fill: parent
                    onPressed: {
                        Game.movePiece(-1);
                        timerLeftButton.running = true;
                    }
                    onReleased: timerLeftButton.running = false;
                }

                Timer {
                    id: timerLeftButton
                    interval: 200
                    running: false
                    repeat: true
                    onTriggered: leftButton.repeatedClick();
                }

                onRepeatedClick: Game.movePiece(-1);
            }

            Image {
                id: rotateButton
                x: 150
                y: 720
                width: 80
                height: 80
                sourceSize.width: 80
                source: rotateButtonArea.pressed ? "data/rotatebutton_pressed.svg" : "data/rotatebutton_unpressed.svg"

                signal repeatedClick();
                MouseArea {
                    id: rotateButtonArea
                    anchors.fill: parent
                    onPressed: {
                        Game.rotatePiece();
                        timerRotateButton.running = true;
                    }
                    onReleased: timerRotateButton.running = false;
                }

                Timer {
                    id: timerRotateButton
                    interval: 400
                    running: false
                    repeat: true
                    onTriggered: rotateButton.repeatedClick();
                }

                onRepeatedClick: Game.rotatePiece();
            }

            Image {
                id: downButton
                x: 270
                y: 720
                width: 80
                height: 80
                sourceSize.width: 80
                source: downButtonArea.pressed ? "data/downbutton_pressed.svg" : "data/downbutton_unpressed.svg"

                MouseArea {
                    id: downButtonArea
                    anchors.fill: parent
                    onPressed: {
                        Game.updateGame();
                        Game.savedInterval = gameTimer.interval;
                        gameTimer.interval = 100;
                    }
                    onReleased: {
                        if (Game.savedInterval) {
                            gameTimer.interval = Game.savedInterval - (100 - gameTimer.interval);
                            Game.savedInterval = false;
                        }
                    }
                }
            }

            Image {
                id: rightButton
                x: 390
                y: 720
                width: 80
                height: 80
                sourceSize.width: 80
                source: rightButtonArea.pressed ? "data/rightbutton_pressed.svg" : "data/rightbutton_unpressed.svg"

                signal repeatedClick();
                MouseArea {
                    id: rightButtonArea
                    anchors.fill: parent
                    onPressed: {
                        Game.movePiece(1);
                        timerRightButton.running = true;
                    }
                    onReleased: timerRightButton.running = false;
                }

                Timer {
                    id: timerRightButton
                    interval: 200
                    running: false
                    repeat: true
                    onTriggered: rightButton.repeatedClick();
                }

                onRepeatedClick: Game.movePiece(1);
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
            y: 130
            width: 480*2
            height: 724
            //anchors.fill: parent
            color: "black"
            visible: false
            anchors.topMargin: 130
            opacity: 0

            TextField {
                id: nameField
                placeholderText: "Write your name here"
                maximumLength: 50
                y: 140
                anchors.right: parent.right
                anchors.rightMargin: 480+25
                anchors.left: parent.left
                anchors.leftMargin: 25
            }

            MenuButton {
                x: 95
                y: 210
                label: "Save my score"
                onClicked: { Game.saveHighScore(); rectangle2.x = -480; }
            }

            MenuButton {
                x: 95
                y: 290
                label: "No, thank you"
                onClicked: { Game.showHighScores(); rectangle2.x = -480; }
            }

            MenuButton {
                x: 480 + 95
                y: 636
                label: "Go To Menu"
                onClicked: {
                    root.state = "menuState";
                    author.visible = false;
                }
            }

            MenuButton {
                x: 480 + 95
                y: 544
                label: "Play Again"
                onClicked: {
                    root.state = "gameState";
                }
            }

            Text {
                id: text1
                x: 53
                y: 24
                width: 371
                height: 30
                color: "white"
                text: "Score:"
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 24
            }

            ListView {
                x: 480+50
                width: 480-100
                height: 500
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
                    font.pointSize: 32
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
                x: 53
                y: 61
                width: 371
                height: 59
                color: "white"
                text: "0"
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 48
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
                    x: 42
                    y: 13
                    width: 396
                    height: 719
                    opacity: 1
                }

                PropertyChanges {
                    target: author
                    x: 0
                    y: 420
                    width: 396
                    height: 50
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
                    y: 130
                    width: 480
                    height: 724
                    visible: true
                    opacity: 1
                }

                PropertyChanges {
                    target: image1
                    x: 53
                    width: 374
                    height: 104
                }

                PropertyChanges {
                    target: author
                    x: -36
                    y: 113
                    width: 446
                    height: 44
                    opacity: 0
                }

                PropertyChanges {
                    target: buttonStartGame
                    opacity: 1
                    y: 11
                }

                PropertyChanges {
                    target: buttonHighscores
                    opacity: 1
                    y: 91
                }

                PropertyChanges {
                    target: buttonHelp
                    opacity: 1
                    y: 171
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
                    x: 390
                    y: 0
                    width: 80
                    height: 24
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
                    target: image1
                    x: 53
                    y: 13
                    width: 374
                    height: 104
                    z: 5
                }

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
                    y: 136
                }

                PropertyChanges {
                    target: buttonHighscores
                    y: 230
                }

                PropertyChanges {
                    target: buttonHelp
                    y: 310
                }

                PropertyChanges {
                    target: buttonResume
                    y: 58
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
                    ScriptAction { script: { Game.startGame(); gameTimer.running = false; } }
                    NumberAnimation { properties: "x, y, width, height, opacity"; easing.type: Easing.InOutQuad; duration: 500 }
                    ScriptAction { script: gameTimer.running = true; }
                }
            },
            Transition {
                from: "gameState"
                to: "pauseMenuState"
                NumberAnimation { properties: "x, y, width, height, opacity"; easing.type: Easing.InOutQuad; duration: 250 }
            },
            Transition {
                from: "pauseMenuState"
                to: "gameState"
                SequentialAnimation {
                    NumberAnimation { properties: "x, y, width, height, opacity"; easing.type: Easing.InOutQuad; duration: 250 }
                    ScriptAction { script: gameTimer.running = true; }
                }
            },
            Transition {
                from: "hiscoresEnd"
                to: "gameState"
                SequentialAnimation {
                    ScriptAction { script: { Game.startGame(); gameTimer.running = false; } }
                    NumberAnimation { properties: "opacity"; easing.type: Easing.InOutQuad; duration: 250 }
                    ScriptAction { script: gameTimer.running = true; }
                }
            }
        ]
    }
}
