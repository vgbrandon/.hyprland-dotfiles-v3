import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray

RowLayout {
  spacing: 6

  readonly property bool hasItems: (SystemTray.items.values?.length ?? 0) > 0
  visible: hasItems

  Repeater {
    model: SystemTray.items

    delegate: Item {
      required property var modelData

      width: 18
      height: 18

      Image {
        anchors.fill: parent
        source: modelData.icon
        smooth: true
        mipmap: true
      }

      MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: mouse => {
          if (mouse.button === Qt.LeftButton)
            modelData.activate()
          else
            modelData.secondaryActivate()
        }
        cursorShape: Qt.PointingHandCursor
      }
    }
  }
}
