import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland

Row {
  spacing: 6

  Repeater {
    model: Hyprland.workspaces.values

    delegate: Item {
      required property var modelData

      readonly property bool active:   modelData.id === Hyprland.focusedWorkspace?.id
      readonly property bool occupied: modelData.windowCount > 0

      width: active ? 22 : 8
      height: 8

      Behavior on width { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }

      Rectangle {
        anchors.fill: parent
        radius: height / 2

        color: active   ? Colors.accent
             : occupied ? Qt.rgba(Colors.fg.r, Colors.fg.g, Colors.fg.b, 0.45)
             :            Qt.rgba(Colors.fg.r, Colors.fg.g, Colors.fg.b, 0.15)

        Behavior on color { ColorAnimation { duration: 150 } }
      }

      MouseArea {
        anchors.fill: parent
        onClicked: Hyprland.dispatch("workspace " + modelData.id)
        cursorShape: Qt.PointingHandCursor
      }
    }
  }
}
