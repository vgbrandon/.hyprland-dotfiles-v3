import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland

RowLayout {
  id: taskbar
  spacing: 4

  property string screenName: ""

  Repeater {
    model: ToplevelManager.toplevels

    delegate: Item {
      id: delegate
      required property var modelData

      readonly property bool active: modelData === ToplevelManager.activeToplevel
      readonly property bool shown: {
        const ws = Hyprland.toplevels.values.find(t => t.title === modelData.title)
        return ws?.workspace?.monitor?.name === taskbar.screenName
      }

      visible: shown
      Layout.preferredWidth: shown ? 28 : 0
      Layout.maximumWidth: shown ? 28 : 0
      height: 28

      Rectangle {
        anchors.fill: parent
        radius: 6
        color: delegate.active
          ? Qt.rgba(Colors.accent.r, Colors.accent.g, Colors.accent.b, 0.25)
          : "transparent"

        Behavior on color { ColorAnimation { duration: 120 } }

        Image {
          anchors.centerIn: parent
          width: 18
          height: 18
          source: {
            const appId = delegate.modelData.appId ?? ""
            if (appId === "dev.zed.Zed") return "/usr/share/icons/zed.png"
            return Quickshell.iconPath(appId, true)
          }
          smooth: true
          mipmap: true
        }
      }

      MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: delegate.modelData.activate()
      }
    }
  }
}
