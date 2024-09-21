TARGET = harbour-trites

CONFIG += sailfishapp_qml

DISTFILES += qml/harbour-trites.qml \
    qml/BasePiece.qml \
    qml/Block.qml \
    qml/Dimensions.qml \
    qml/game.js \
    qml/MenuButton.qml \
    qml/PieceI.qml \
    qml/PieceJ.qml \
    qml/PieceL.qml \
    qml/PieceO.qml \
    qml/PieceS.qml \
    qml/PieceT.qml \
    qml/PieceZ.qml \
    qml/data/author.svg \
    qml/data/block_blue.png \
    qml/data/block_green.png \
    qml/data/block_purple.png \
    qml/data/block_yellow.png \
    qml/data/menubutton_pressed.svg \
    qml/data/pausebutton_pressed.svg \
    qml/data/background.png \
    qml/data/block_cyan.png \
    qml/data/block_orange.png \
    qml/data/block_red.png \
    qml/data/logo.svg \
    qml/data/menubutton_unpressed.svg \
    qml/data/pausebutton_unpressed.svg \
    COPYING \
    rpm/harbour-trites.spec \
    harbour-trites.desktop \
    harbour-trites.svg \
    README.md

ICON_SIZES = 86 108 128 172
ICON_SOURCE = $$PWD/harbour-trites.svg
for (size, ICON_SIZES) {
    icon_dir = $$shadowed(icons/$${size}x$${size})
    icon_path = $${icon_dir}/$${TARGET}.png

    icon_$${size}.commands = mkdir -p $$icon_dir $$escape_expand(\n\t)
    icon_$${size}.commands += rsvg-convert --width=$${size} --height=$${size} \
            --output $$icon_path $$ICON_SOURCE $$escape_expand(\n\t)
    icon_$${size}.depends = $$ICON_SOURCE
    icon_$${size}.output = $$icon_path
    icon_$${size}.target = $$icon_path

    icon_$${size}_install.CONFIG = no_check_exist
    icon_$${size}_install.depends = $$icon_path
    icon_$${size}_install.files = $$icon_path
    icon_$${size}_install.path = /usr/share/icons/hicolor/$${size}x$${size}/apps

    QMAKE_EXTRA_TARGETS += icon_$${size}
    PRE_TARGETDEPS += $$icon_path
    QMAKE_CLEAN += $$icon_path
    INSTALLS += icon_$${size}_install
}

static_files.files = COPYING README.md $$ICON_SOURCE
static_files.path = /usr/share/$${TARGET}
INSTALLS += static_files