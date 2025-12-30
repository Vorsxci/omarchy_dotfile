import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtQuick.Effects
import QtMultimedia

import "Components"

Pane {
    id: root

    FontLoader {
        id: customFont
        source: "Fonts/8bitlim.ttf"
    }

    // IMPORTANT: use Screen.width/height (avoids weird clipping)
    height: config.ScreenHeight || Screen.height
    width:  config.ScreenWidth  || Screen.width
    padding: config.ScreenPadding

    LayoutMirroring.enabled: config.RightToLeftLayout == "true" ? true : Qt.application.layoutDirection === Qt.RightToLeft
    LayoutMirroring.childrenInherit: true

    palette.window: config.BackgroundColor
    palette.highlight: config.HighlightBackgroundColor
    palette.highlightedText: config.HighlightTextColor
    palette.buttonText: config.HoverSystemButtonsIconsColor

    font.family: (config.Font === "8bitlim") ? customFont.name : config.Font
    font.pointSize: config.FontSize !== "" ? config.FontSize : parseInt(height / 80) || 13

    focus: true

    Item {
        id: sizeHelper
        anchors.fill: parent

        Rectangle {
            id: tintLayer
            anchors.fill: parent
            z: 1
            color: config.DimBackgroundColor
            opacity: config.DimBackground
        }

        Image {
            id: backgroundPlaceholderImage
            z: 10
            source: config.BackgroundPlaceholder
            visible: false
        }

        AnimatedImage {
            id: backgroundImage

            MediaPlayer {
                id: player
                videoOutput: videoOutput
                autoPlay: true
                playbackRate: config.BackgroundSpeed == "" ? 1.0 : config.BackgroundSpeed
                loops: -1
                onPlayingChanged: backgroundPlaceholderImage.visible = false
            }

            VideoOutput {
                id: videoOutput
                fillMode: config.CropBackground == "true"
                          ? VideoOutput.PreserveAspectCrop
                          : VideoOutput.PreserveAspectFit
                anchors.fill: parent
            }

            anchors.fill: parent

            horizontalAlignment: config.BackgroundHorizontalAlignment == "left" ?
                                 Image.AlignLeft :
                                 config.BackgroundHorizontalAlignment == "right" ?
                                 Image.AlignRight : Image.AlignHCenter

            verticalAlignment: config.BackgroundVerticalAlignment == "top" ?
                               Image.AlignTop :
                               config.BackgroundVerticalAlignment == "bottom" ?
                               Image.AlignBottom : Image.AlignVCenter

            speed: config.BackgroundSpeed == "" ? 1.0 : config.BackgroundSpeed
            paused: config.PauseBackground == "true" ? 1 : 0
            fillMode: config.CropBackground == "true" ? Image.PreserveAspectCrop : Image.PreserveAspectFit
            asynchronous: true
            cache: true
            clip: true
            mipmap: true

            Component.onCompleted: {
                var fileType = config.Background.substring(config.Background.lastIndexOf(".") + 1).toLowerCase()
                const videoFileTypes = ["avi","mp4","mov","mkv","m4v","webm"];
                if (videoFileTypes.includes(fileType)) {
                    backgroundPlaceholderImage.visible = true
                    player.source = Qt.resolvedUrl(config.Background)
                    player.play()
                } else {
                    backgroundImage.source = config.background || config.Background
                }
            }
        }

        MouseArea {
            anchors.fill: backgroundImage
            onClicked: parent.forceActiveFocus()
        }

        // ============================================================
        //  ORIGINAL “FORM CONTAINER” PATTERN — just CENTERED now
        // ============================================================

        // This is the key: keep original size math so LoginForm doesn't overflow.
        LoginForm {
            id: form
            height: parent.height
            width: parent.width / 2.5
            anchors.horizontalCenter: parent.horizontalCenter
            z: 5
        }

        // Pane background follows form (like upstream)
// Pane background follows form (layout stays upstream)
Rectangle {
    id: formBackground
    anchors.fill: form
    z: 4

    radius: (config.RoundCorners !== "" && config.RoundCorners !== undefined) ? parseInt(config.RoundCorners) : 20

    // theme.conf driven
    color: config.PaneBackgroundColor
    opacity: (config.PaneBackgroundOpacity !== "" && config.PaneBackgroundOpacity !== undefined)
             ? Number(config.PaneBackgroundOpacity) : 0.82

    border.width: (config.PaneBorderWidth !== "" && config.PaneBorderWidth !== undefined)
                  ? parseInt(config.PaneBorderWidth) : 2
    border.color: config.PaneBorderColor

    // Outer shadow (kitty/hyprland window float)
    layer.enabled: true
    layer.effect: MultiEffect {
        shadowEnabled: true
        shadowHorizontalOffset: 0
        shadowVerticalOffset: (config.PaneShadowYOffset !== "" && config.PaneShadowYOffset !== undefined)
                              ? Number(config.PaneShadowYOffset) : 16
        shadowBlur: (config.PaneShadowBlur !== "" && config.PaneShadowBlur !== undefined)
                    ? Number(config.PaneShadowBlur) : 1.10
        shadowOpacity: (config.PaneShadowOpacity !== "" && config.PaneShadowOpacity !== undefined)
                       ? Number(config.PaneShadowOpacity) : 0.38
        shadowColor: "#000000"
    }
}

// Accent border opacity control (kept separate so border.color can stay clean)
Rectangle {
    anchors.fill: formBackground
    radius: formBackground.radius
    color: "transparent"
    border.width: formBackground.border.width
    border.color: config.PaneBorderColor
    opacity: (config.PaneBorderOpacity !== "" && config.PaneBorderOpacity !== undefined)
             ? Number(config.PaneBorderOpacity) : 0.70
    z: 4.05
}

// Inner highlight line (glass edge)
Rectangle {
    anchors.fill: formBackground
    radius: formBackground.radius
    color: "transparent"
    border.width: (config.PaneInnerBorderWidth !== "" && config.PaneInnerBorderWidth !== undefined)
                  ? parseInt(config.PaneInnerBorderWidth) : 1
    border.color: config.PaneInnerBorderColor
    opacity: (config.PaneInnerBorderOpacity !== "" && config.PaneInnerBorderOpacity !== undefined)
             ? Number(config.PaneInnerBorderOpacity) : 0.10
    z: 4.10
}

// Outer glow ring (slightly larger than the pane)
// Soft outer glow (real bloom, not a ring)
// Soft outer glow (real bloom, not a ring)
Rectangle {
    id: paneGlow
    anchors.fill: formBackground
    radius: formBackground.radius
    z: 3.80

    // tiny fill so the shadow has “ink” to bloom from
    color: config.PaneGlowColor
    opacity: Number(config.PaneGlowFillOpacity)

    // no border — borders create the “separate outline” look
    border.width: 0

    layer.enabled: true
    layer.effect: MultiEffect {
        autoPaddingEnabled: true      // prevents clipping
        shadowEnabled: true
        shadowHorizontalOffset: 0
        shadowVerticalOffset: 0
        shadowBlur: Number(config.PaneGlowBlur)
        shadowOpacity: Number(config.PaneGlowOpacity)
        shadowColor: config.PaneGlowColor
    }
}

        // Blur mask follows form (like upstream)
        ShaderEffectSource {
            id: blurMask
            anchors.fill: form
            sourceItem: backgroundImage
            sourceRect: Qt.rect(x, y, width, height)
            visible: (config.FullBlur == "true" || config.PartialBlur == "true")
        }

        MultiEffect {
            id: blur
            anchors.fill: form
            source: blurMask
            blurEnabled: true
            autoPaddingEnabled: true
            blur: config.Blur == "" ? 2.0 : config.Blur
            blurMax: config.BlurMax == "" ? 48 : config.BlurMax
            visible: (config.FullBlur == "true" || config.PartialBlur == "true")
            z: 3
        }

        // OS Logo sits inside the “pane” area (won't affect form internals)
        Image {
            id: osLogo
            source: config.Logo
            visible: config.Logo !== ""
            z: 6
            height: 300
            width: 500
            fillMode: Image.PreserveAspectFit
            smooth: true
            mipmap: true

            anchors.top: formBackground.top
            anchors.topMargin: 18
            anchors.horizontalCenter: formBackground.horizontalCenter
            // For top-left instead:
            // anchors.horizontalCenter: undefined
            // anchors.left: formBackground.left
            // anchors.leftMargin: 22
        }

        // Keep upstream virtual keyboard behavior
        Loader {
            id: virtualKeyboard
            source: "Components/VirtualKeyboard.qml"

            width: config.KeyboardSize == "" ? parent.width * 0.4 : parent.width * config.KeyboardSize
            anchors.bottom: parent.bottom
            anchors.left: config.VirtualKeyboardPosition == "left" ? parent.left : undefined
            anchors.horizontalCenter: config.VirtualKeyboardPosition == "center" ? parent.horizontalCenter : undefined
            anchors.right: config.VirtualKeyboardPosition == "right" ? parent.right : undefined
            z: 10

            state: "hidden"
            property bool keyboardActive: item ? item.active : false

            function switchState() { state = state == "hidden" ? "visible" : "hidden" }

            states: [
                State {
                    name: "visible"
                    PropertyChanges { target: virtualKeyboard; y: root.height - virtualKeyboard.height; opacity: 1 }
                },
                State {
                    name: "hidden"
                    PropertyChanges { target: virtualKeyboard; y: root.height - root.height/4; opacity: 0 }
                }
            ]
            transitions: [
                Transition {
                    from: "hidden"; to: "visible"
                    SequentialAnimation {
                        ScriptAction {
                            script: {
                                virtualKeyboard.item.activated = true;
                                Qt.inputMethod.show();
                            }
                        }
                        ParallelAnimation {
                            NumberAnimation { target: virtualKeyboard; property: "y"; duration: 100; easing.type: Easing.OutQuad }
                            OpacityAnimator { target: virtualKeyboard; duration: 100; easing.type: Easing.OutQuad }
                        }
                    }
                },
                Transition {
                    from: "visible"; to: "hidden"
                    SequentialAnimation {
                        ParallelAnimation {
                            NumberAnimation { target: virtualKeyboard; property: "y"; duration: 100; easing.type: Easing.InQuad }
                            OpacityAnimator { target: virtualKeyboard; duration: 100; easing.type: Easing.InQuad }
                        }
                        ScriptAction {
                            script: {
                                virtualKeyboard.item.activated = false;
                                Qt.inputMethod.hide();
                            }
                        }
                    }
                }
            ]
        }
    }
}

