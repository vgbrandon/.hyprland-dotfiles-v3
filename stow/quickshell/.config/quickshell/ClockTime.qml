import QtQuick
import Quickshell

Text {
  SystemClock {
    id: clock
    precision: SystemClock.Minutes
  }

  text: Qt.formatTime(clock.date, "HH:mm")
  color: Colors.fg
  font.pixelSize: 13
  font.bold: true
  font.family: "JetBrainsMono Nerd Font"
}
