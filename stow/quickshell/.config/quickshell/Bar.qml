import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

PanelWindow {
  id: bar

  WlrLayershell.namespace: "quickshell:bar"

  anchors { top: true; left: true; right: true }
  exclusiveZone: 34
  implicitHeight: 34
  color: "transparent"

  // Franja superior (ancho completo, siempre 34px)
  Rectangle {
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    height: 34
    color: Colors.surface

    Rectangle {
      anchors.bottom: parent.bottom
      anchors.left: parent.left
      anchors.right: parent.right
      height: 1
      color: Colors.border
    }

    RowLayout {
      anchors.left: parent.left
      anchors.leftMargin: 12
      anchors.verticalCenter: parent.verticalCenter
      spacing: 8

      Workspaces {}
      Separator {}
      TaskBar { screenName: bar.screen.name }
    }

    ClockTime {
      anchors.centerIn: parent
    }

    RowLayout {
      anchors.right: parent.right
      anchors.rightMargin: 12
      anchors.verticalCenter: parent.verticalCenter
      spacing: 10

      SysTray { id: systray }
      Separator { visible: systray.hasItems }
      BlueLight {}
      Separator {}
      Volume {}
      Separator {}
      Keyboard {}
      Separator {}
      ClockDate {}
    }
  }

}
