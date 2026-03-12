import QtQuick
import QtQuick.Layouts
import Quickshell

RowLayout {
  spacing: 8

  SystemClock {
    id: clock
    precision: SystemClock.Minutes
  }

  Text {
    text: Qt.formatTime(clock.date, "HH:mm")
    color: Colors.fg
    font.pixelSize: 13
    font.bold: true
    font.family: "JetBrainsMono Nerd Font"
  }

  Text {
    text: Qt.formatDate(clock.date, "ddd dd")
    color: Colors.muted
    font.pixelSize: 12
    font.family: "JetBrainsMono Nerd Font"
  }
}
