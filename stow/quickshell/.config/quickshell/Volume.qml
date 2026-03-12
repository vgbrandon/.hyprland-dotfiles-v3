import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire

Item {
  implicitWidth: row.implicitWidth
  implicitHeight: row.implicitHeight

  PwObjectTracker {
    objects: [Pipewire.defaultAudioSink]
  }

  RowLayout {
    id: row
    anchors.fill: parent
    spacing: 6

    Text {
      text: {
        const sink = Pipewire.defaultAudioSink
        if (!sink || sink.audio.muted) return "󰖁"
        const v = sink.audio.volume
        if (v > 0.6) return "󰕾"
        if (v > 0.2) return "󰖀"
        return "󰕿"
      }
      color: Colors.muted
      font.pixelSize: 13
      font.family: "JetBrainsMono Nerd Font"
    }

    Rectangle {
      width: 70
      height: 8
      radius: 4
      color: Qt.rgba(Colors.fg.r, Colors.fg.g, Colors.fg.b, 0.15)

      Rectangle {
        id: fill
        width: parent.width * Math.min(Pipewire.defaultAudioSink?.audio.volume ?? 0, 1.0)
        height: parent.height
        radius: 4

        color: Colors.accent

        Behavior on width { NumberAnimation { duration: 100; easing.type: Easing.OutCubic } }
      }
    }
  }

  MouseArea {
    anchors.fill: parent
    onWheel: wheel => {
      const sink = Pipewire.defaultAudioSink
      if (!sink) return
      const delta = wheel.angleDelta.y > 0 ? 0.05 : -0.05
      sink.audio.volume = Math.max(0, Math.min(1, sink.audio.volume + delta))
    }
    onClicked: {
      const sink = Pipewire.defaultAudioSink
      if (sink) sink.audio.muted = !sink.audio.muted
    }
    cursorShape: Qt.PointingHandCursor
  }
}
