import QtQuick 2.15
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.plasma5support as Plasma5Support
import org.kde.plasma.core as PlasmaCore
import org.kde.kirigami as Kirigami
import org.kde.plasma.plasmoid

PlasmoidItem {
    id: page
    height: childrenRect.height
    width: Kirigami.Units.gridUnit * 12.6
    preferredRepresentation: compactRepresentation
    compactRepresentation: null
	fullRepresentation: Item {
        width: Kirigami.Units.gridUnit * 12.6
        Plasma5Support.DataSource {
            id: executable
            engine: "executable"
            connectedSources: []
            property var callbacks: ({})
            onNewData: {
                var stdout = data["stdout"]

                if (callbacks[sourceName] !== undefined) {
                    callbacks[sourceName](stdout);
                }

                exited(sourceName, stdout)
                disconnectSource(sourceName)
            }
            function exec(cmd, onNewDataCallback) {
                if (onNewDataCallback !== undefined){
                    callbacks[cmd] = onNewDataCallback
                }
                connectSource(cmd)
            }
            signal exited(string sourceName, string stdout)
        }
        Column {
            anchors.fill: parent
            spacing: 0
            width: Kirigami.Units.gridUnit * 12.6
            PlasmaComponents.ToolButton {
                text: "About this computer"
                onClicked: {
                    executable.exec("kinfocenter")
                }
                width: Kirigami.Units.gridUnit * 12.6
            }
            PlasmaComponents.MenuSeparator {
                width: Kirigami.Units.gridUnit * 12.6
            }
            PlasmaComponents.ToolButton {
                text: "System Preferences..."
                width: Kirigami.Units.gridUnit * 12.6
                anchors.left: parent.left
                onClicked: {
                    executable.exec("systemsettings")
                }
            }
            PlasmaComponents.ToolButton {
                text: "App Store..."
                width: Kirigami.Units.gridUnit * 12.6
                onClicked: {
                    executable.exec("plasma-discover")
                }
            }
            PlasmaComponents.MenuSeparator {
                width: Kirigami.Units.gridUnit * 12.6
            }
            PlasmaComponents.ToolButton {
                text: "Force Quit..."
                width: Kirigami.Units.gridUnit * 12.6
                onClicked: {
                    executable.exec("xkill")
                }
                PlasmaComponents.Label {
                    text: "⌥⌘⎋ "
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
            PlasmaComponents.MenuSeparator {
                width: Kirigami.Units.gridUnit * 12.6
            }
            PlasmaComponents.ToolButton {
                text: "Sleep"
                width: Kirigami.Units.gridUnit * 12.6
                onClicked: {
                    executable.exec("systemctl suspend")
                }
            }
            PlasmaComponents.ToolButton {
                text: "Restart..."
                width: Kirigami.Units.gridUnit * 12.6
                onClicked: {
                    executable.exec("reboot")
                }
            }
            PlasmaComponents.ToolButton {
                text: "Shut Down..."
                width: Kirigami.Units.gridUnit * 12.6
                onClicked: {
                    executable.exec("shutdown now")
                }
            }
            PlasmaComponents.MenuSeparator {
                width: Kirigami.Units.gridUnit * 12.6
            }
            PlasmaComponents.ToolButton {
                text: "Lock Screen"
                width: Kirigami.Units.gridUnit * 12.6
                onClicked: {
                    executable.exec("qdbus org.kde.ksmserver /ScreenSaver org.freedesktop.ScreenSaver.Lock")
                }
                PlasmaComponents.Label {
                    text: "⌃⌘Q "
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
            PlasmaComponents.ToolButton {
                text: "Log Out"
                width: Kirigami.Units.gridUnit * 12.6
                onClicked: {
                    executable.exec("qdbus org.kde.ksmserver /KSMServer logout 0 0 0")
                }
                PlasmaComponents.Label {
                    text: "⇧⌘Q "
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }
    }
}
