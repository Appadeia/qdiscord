import QtQuick 2.0
import QtQuick.Window 2.12
import QtWebEngine 1.9
import QtQuick.Controls 2.0
import Qt.labs.settings 1.0
import Qt.labs.platform 1.0 as Native

ApplicationWindow {
    id: root
    visible: true
    width: 800
    height: 600
    title: webView.shouldShow ? webView.title : qsTr("Discord Wrapper")
    color: "#2C2F33"
    property bool shouldClose: true
    onClosing: {
        if (!root.shouldClose) {
            root.hide()
            close.accepted = false
        } else {
            systray.visible = false
        }
    }

    Settings {
        id: settings
        property url defaultURL: "https://www.discordapp.com/login"
    }

    Component.onCompleted: {
        root.showMaximized()
    }

    Native.SystemTrayIcon {
        id: systray
        visible: false
        iconSource: webView.icon

        menu: Native.Menu {
            Native.MenuItem {
                text: "Focus Window"
                onTriggered: {
                    root.showMaximized()
                    console.log("raise")
                }
            }
            Native.MenuItem {
                text: "Quit Discord"
                onTriggered: {
                    root.shouldClose = true
                    root.close()
                }
            }
        }
    }


    Column {
        anchors.horizontalCenter: parent.horizontalCenter
        Rectangle {
            height: 10
            width: 1
            color: "transparent"
        }
        Label {
            id: header
            color: "white"
            font.pointSize: 24
            text: "Please select a Discord Version"
        }
        Rectangle {
            height: 10
            width: 1
            color: "transparent"
        }
        VersionRow {
            height: 64
            width: header.width
            text: "Discord Stable"
            hovering: stableMaus.containsMouse
            MouseArea {
                id: stableMaus
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    root.shouldClose = false
                    systray.visible = true
                    webView.url = "https://discordapp.com/login"
                    settings.defaultURL = "https://discordapp.com/login"
                    webView.shouldShow = true
                }
            }
        }
        Rectangle {
            height: 5
            width: 1
            color: "transparent"
        }
        VersionRow {
            height: 64
            width: header.width
            text: "Discord PTB (Beta)"
            hovering: ptbMaus.containsMouse
            MouseArea {
                id: ptbMaus
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    root.shouldClose = false
                    systray.visible = true
                    webView.url = "https://ptb.discordapp.com/login"
                    settings.defaultURL = "https://ptb.discordapp.com/login"
                    webView.shouldShow = true
                }
            }
        }
        Rectangle {
            height: 5
            width: 1
            color: "transparent"
        }
        VersionRow {
            height: 64
            width: header.width
            text: "Discord Canary (Testing)"
            hovering: canaryMaus.containsMouse
            MouseArea {
                id: canaryMaus
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    root.shouldClose = false
                    systray.visible = true
                    webView.url = "https://canary.discordapp.com/login"
                    settings.defaultURL = "https://canary.discordapp.com/login"
                    webView.shouldShow = true
                }
            }
        }
    }
    WebEngineView {
        id: webView
        property bool shouldShow: false
        y: shouldShow ? 0 : height
        Behavior on y {
            NumberAnimation {
                duration: 300
                easing.type: Easing.InOutQuad
            }
        }
        onFeaturePermissionRequested: {
            grantFeaturePermission(securityOrigin, feature, true)
        }

        profile: WebEngineProfile {
            onPresentNotification: {
                console.log(notification.title)
                console.log(notification.message)
            }
        }
        width: parent.width
        height: parent.height
        url: settings.defaultURL
    }
}
