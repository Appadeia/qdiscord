import QtQuick 2.0
import QtQuick.Window 2.12
import QtWebEngine 1.2
import QtQuick.Controls 2.5
import Qt.labs.platform 1.0 as Native
import Qt.labs.settings 1.0
import me.appadeia.Simplifier 1.0
import QtQuick.Controls.Material 2.12

Window {
    id: root
    visible: true
    width: 800
    height: 600
    title: webView.shouldShow ? webView.title : qsTr("Discord Wrapper")
    color: "#2C2F33"
    property bool shouldClose: true

    Material.accent: "#7289DA"
    Material.theme: Material.Dark

    Simplifier { id: simp }
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
        property int versionIndex: 0
    }
    Component.onCompleted: {
        console.log(settings.versionIndex)
        console.log(isFlatpak)
        root.showMaximized()
        var http = new XMLHttpRequest();
        var url = "https://capnkitten.github.io/BetterDiscord/Material-Discord/css/source.css";
        http.open("GET", url, true);

        http.onreadystatechange = function () {
            if (http.readyState == 4) {
                if (http.status == 200) {
                    var css = http.responseText
                    webView.css = simp.getSimple(css)
                }
            }
        }

        http.send();
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
        focus: true
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
        Rectangle {
            radius: 5
            height: childrenRect.height + 2
            width: childrenRect.width + 2
            color: "transparent"
            border.color: "#141616"
            border.width: 1
            Column {
                opacity: 1
                id: versionColumn
                x: 1
                y: 1
                VersionRow {
                    height: 64
                    width: header.width
                    text: "Discord Stable"
                    hovering: stableMaus.containsMouse
                    lastSelected: settings.versionIndex == 0
                    MouseArea {
                        id: stableMaus
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            root.shouldClose = false
                            systray.visible = true
                            if (settings.versionIndex != 0) {
                                settings.versionIndex = 0
                                webView.url = "https://discordapp.com/login"
                            }
                            webView.shouldShow = true
                        }
                    }
                }
                Rectangle {
                    height: 1
                    width: header.width
                    color: "#141616"
                }
                VersionRow {
                    height: 64
                    width: header.width
                    text: "Discord PTB (Beta)"
                    hovering: ptbMaus.containsMouse
                    lastSelected: settings.versionIndex == 1
                    MouseArea {
                        id: ptbMaus
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            root.shouldClose = false
                            systray.visible = true
                            if (settings.versionIndex != 1) {
                                settings.versionIndex = 1
                                webView.url = "https://ptb.discordapp.com/login"
                            }
                            webView.shouldShow = true
                        }
                    }
                }
                Rectangle {
                    height: 1
                    width: header.width
                    color: "#141616"
                }
                VersionRow {
                    height: 64
                    width: header.width
                    text: "Discord Canary (Testing)"
                    hovering: canaryMaus.containsMouse
                    lastSelected: settings.versionIndex == 2
                    MouseArea {
                        id: canaryMaus
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            root.shouldClose = false
                            systray.visible = true
                            if (settings.versionIndex != 2) {
                                settings.versionIndex = 2
                                webView.url = "https://canary.discordapp.com/login"
                            }
                            webView.shouldShow = true
                        }
                    }
                }
            }
        }
        Rectangle {
            height: 10
            width: 1
            color: "transparent"
        }
        Rectangle {
            height: 64
            width: header.width
            color: "#23272A"
            border.color: "#141616"
            radius: 5

            Label {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 20
                color: "white"
                text: "Use Material Style"
            }
            CheckBox {
                id: styleSwitch
                property alias enabled: styleSwitch.checked
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: 12
                onPressed: {
                    webView.injectCss("theme", webView.css)
                }
            }
        }
        Rectangle {
            height: 10
            width: 1
            color: "transparent"
        }
        Rectangle {
            radius: 5
            height: childrenRect.height + 2
            width: childrenRect.width + 2
            color: "transparent"
            border.color: "#141616"
            border.width: 1
            Column {
                opacity: 1
                id: actionColumn
                x: 1
                y: 1
                VersionRow {
                    height: 64
                    width: header.width
                    text: "Reload Discord"
                    hovering: reloadMaus.containsMouse
                    MouseArea {
                        id: reloadMaus
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            webView.reload()
                            webView.shouldShow = true
                        }
                    }
                }
                Rectangle {
                    height: 1
                    width: header.width
                    color: "#141616"
                }
                VersionRow {
                    height: 64
                    width: header.width
                    text: "Inject Custom CSS"
                    hovering: cssMaus.containsMouse
                    MouseArea {
                        id: cssMaus
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            cssBox.visible = true
                        }
                    }
                }
            }
        }
    }
    ScrollView {
        visible: false
        id: cssBox
        height: parent.height / 2
        width: parent.width / 2
        anchors.centerIn: parent
        TextArea {
            id: cssArea
            text: "/* Put your CSS here. */"
        }
        background: Rectangle {
            color: "black"
        }
    }
    Button {
        id: injectBtn
        visible: cssBox.visible
        text: "Inject"
        anchors.right: cssBox.right
        anchors.top: cssBox.bottom
        onClicked: {
            webView.injectCss("custom", simp.getSimple(cssArea.text))
            cssBox.visible = false
            webView.shouldShow = true
        }
    }
    Button {
        visible: cssBox.visible
        text: "Cancel"
        anchors.right: injectBtn.left
        anchors.rightMargin: 5
        anchors.top: cssBox.bottom
        onClicked: {
            cssBox.visible = false
        }
    }

    Rectangle {
        visible: !isFlatpak
        color: "#62a0ea"
        width: parent.width
        height: flatpakLabel.contentHeight * 2
        anchors.bottom: parent.bottom
        Label {
            id: flatpakLabel
            font.pointSize: 14
            color: "white"
            font.bold: true
            text: "This application is best used as a Flatpak."
            anchors.centerIn: parent
        }
    }
    WebEngineView {
        property string css: ""
        property string addCss: ""
        id: webView
        property bool shouldShow: false
        y: shouldShow ? 0 : height
        Behavior on y {
            NumberAnimation {
                duration: 300
                easing.type: Easing.InOutQuad
            }
        }

        width: parent.width
        height: parent.height
        url: "https://blank.org"
        function injectCss(id, css) {
            console.log(id)
            console.log(css)
            var script = "(function() { css = document.createElement('style'); css.type = 'text/css'; css.id = '%1'; document.head.appendChild(css); css.innerText = \"%2\"; })()".arg(id).arg(css)
            webView.runJavaScript(script)
        }
        onLoadingChanged: {
            if (loadRequest.status == WebEngineLoadRequest.LoadSucceededStatus) {
                if (styleSwitch.enabled == false) {
                    return;
                }
                injectCss("theme", webView.css)
            }
        }
        Component.onCompleted: {
            if (settings.versionIndex == 0) {
                webView.url = "https://www.discordapp.com/login"
            } else if (settings.versionIndex == 1) {
                webView.url = "https://ptb.discordapp.com/login"
            } else if (settings.versionIndex == 2) {
                webView.url = "https://canary.discordapp.com/login"
            } else {
                webView.url = "https://www.discordapp.com/login"
            }
        }
    }
    Rectangle {
        anchors.top: webView.top
        anchors.left: webView.left
        height: returnMaus.containsMouse ? 60 : 12
        width: 72
        color: Qt.darker("#202225", 3.0)
        MouseArea {
            id: returnMaus
            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
                webView.shouldShow = false
            }
        }
        Label {
            opacity: returnMaus.containsMouse ? 1 : 0
            color: "white"
            text: "^"
            anchors.centerIn: parent
            Behavior on opacity {
                NumberAnimation {
                    duration: 100
                }
            }
        }
        Behavior on height {
            NumberAnimation {
                duration: 100
                easing.type: Easing.InOutQuad
            }
        }
    }
    // 12px between top and button, 72px sidebar width
}
