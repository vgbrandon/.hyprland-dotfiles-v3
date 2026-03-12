import QtQuick
import Quickshell

Text {
  SystemClock {
    id: clock
    precision: SystemClock.Minutes
  }

  text: Qt.formatDate(clock.date, "ddd, dd MMM")
  color: Colors.fg
  font.pixelSize: 12
  font.family: "JetBrainsMono Nerd Font"
}
