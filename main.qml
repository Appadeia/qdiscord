import QtQuick 2.0
import QtQuick.Window 2.12
import QtWebEngine 1.2
import QtQuick.Controls 2.0
import Qt.labs.platform 1.0 as Native
import me.appadeia.Simplifier 1.0

Window {
    id: root
    visible: true
    width: 800
    height: 600
    title: webView.shouldShow ? webView.title : qsTr("Discord Wrapper")
    color: "#2C2F33"
    property bool shouldClose: true
    SystemPalette { id: sysPalette; colorGroup: SystemPalette.Active }
    Simplifier { id: simp }
    onClosing: {
        if (!root.shouldClose) {
            root.hide()
            close.accepted = false
        } else {
            systray.visible = false
        }
    }

    Component.onCompleted: {
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
                    webView.shouldShow = true
                }
            }
        }
        Rectangle {
            height: 5
            width: 1
            color: "transparent"
        }
        Rectangle {
            height: 64
            width: header.width
            color: "#23272A"
            border.color: "#141616"

            Label {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 20
                color: "white"
                text: "Use Material Style"
            }
            Switch {
                id: styleSwitch
                property bool enabled: position > 0.5 ? true : false
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: 20
            }
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
        url: "https://www.discordapp.com/login"
        function injectCss(css) {
            if (!styleSwitch.enabled) {
                return;
            }
            var script = "(function() { css = document.createElement('style'); css.type = 'text/css'; css.id = '%1'; document.head.appendChild(css); css.innerText = \"%2\"; })()".arg("style").arg(css)
            webView.runJavaScript(script)
        }
        onLoadingChanged: {
            if (loadRequest.status == WebEngineLoadRequest.LoadSucceededStatus) {
                injectCss(webView.css)
            }
        }
    }
}
