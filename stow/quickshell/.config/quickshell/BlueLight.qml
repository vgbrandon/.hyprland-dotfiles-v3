import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

Item {
  implicitWidth: row.implicitWidth
  implicitHeight: row.implicitHeight

  property bool active: false
  property int temperature: 3500

  Process {
    id: daemonProc
    command: ["wl-gammarelay-rs"]
    running: true
  }

  Process {
    id: animProc
    command: []
  }

  function animateTo(from, to) {
    const step = from > to ? -200 : 200
    const script = `
      current=${from}
      target=${to}
      step=${step}
      while true; do
        current=$((current + step))
        if [ ${step} -lt 0 ] && [ $current -le $target ]; then current=$target; fi
        if [ ${step} -gt 0 ] && [ $current -ge $target ]; then current=$target; fi
        busctl --user set-property rs.wl-gammarelay / rs.wl.gammarelay Temperature q $current
        [ $current -eq $target ] && break
        sleep 0.015
      done
    `
    animProc.command = ["bash", "-c", script]
    animProc.running = true
  }

  function toggle() {
    if (active) {
      active = false
      animateTo(temperature, 6500)
    } else {
      active = true
      animateTo(6500, temperature)
    }
  }

  RowLayout {
    id: row
    anchors.fill: parent
    spacing: 6

    Text {
      text: active ? "󰛨" : "󰛩"
      color: active ? Colors.yellow : Colors.muted
      font.pixelSize: 14
      font.family: "JetBrainsMono Nerd Font"
    }

    Text {
      text: temperature + "K"
      color: Colors.yellow
      font.pixelSize: 11
      font.family: "JetBrainsMono Nerd Font"
      visible: active
    }
  }

  MouseArea {
    anchors.fill: parent
    cursorShape: Qt.PointingHandCursor
    onClicked: toggle()
    onWheel: wheel => {
      if (!active) return
      const prev = temperature
      const delta = wheel.angleDelta.y > 0 ? 100 : -100
      temperature = Math.max(1000, Math.min(6500, temperature + delta))
      animateTo(prev, temperature)
    }
  }
}
