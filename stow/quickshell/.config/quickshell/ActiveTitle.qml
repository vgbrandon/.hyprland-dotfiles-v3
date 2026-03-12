import QtQuick
import Quickshell.Hyprland

Text {
  text: Hyprland.activeToplevel?.title ?? ""
  color: Colors.fg
  font.pixelSize: 12
  font.family: "JetBrainsMono Nerd Font"
  elide: Text.ElideRight
  horizontalAlignment: Text.AlignHCenter

  opacity: text.length > 0 ? 1 : 0
  Behavior on opacity { NumberAnimation { duration: 150 } }
}
