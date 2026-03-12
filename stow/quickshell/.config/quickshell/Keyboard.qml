import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland

Item {
  implicitWidth: row.implicitWidth
  implicitHeight: row.implicitHeight

  property string layout: "EN"
  property bool capsLock: false

  Timer {
    interval: 500
    running: true
    repeat: true
    onTriggered: pollProc.running = true
  }

  Process {
    id: pollProc
    command: ["bash", "-c",
      "hyprctl devices -j | jq -r '.keyboards[] | select(.main == true) | (.active_keymap[0:2] | ascii_upcase) + \":\" + (if .capsLock then \"1\" else \"0\" end)'"
    ]
    stdout: StdioCollector {
      waitForEnd: true
      onStreamFinished: {
        const out = text.trim()
        const parts = out.split(":")
        if (parts.length === 2) {
          layout = parts[0]
          capsLock = parts[1] === "1"
        }
      }
    }
  }

  Connections {
    target: Hyprland
    function onRawEvent(event) {
      if (event.name === "activelayout") {
        const parts = event.data.split(",")
        if (parts.length >= 2) {
          layout = parts[1].trim().substring(0, 2).toUpperCase()
        }
      }
    }
  }

  RowLayout {
    id: row
    anchors.fill: parent
    spacing: 5

    Text {
      text: "󰪛"
      color: Colors.red
      font.pixelSize: 14
      font.family: "JetBrainsMono Nerd Font"
      visible: capsLock
    }

    Text {
      text: layout
      color: Colors.fg
      font.pixelSize: 11
      font.family: "JetBrainsMono Nerd Font"
    }
  }
}
