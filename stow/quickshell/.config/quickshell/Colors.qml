import QtQuick

pragma Singleton

QtObject {
  id: root

  readonly property color bg:      "#181616"
  readonly property color fg:      "#c5c9c5"
  readonly property color black:   "#0d0c0c"
  readonly property color red:     "#c4746e"
  readonly property color green:   "#8a9a7b"
  readonly property color yellow:  "#c4b28a"
  readonly property color blue:    "#8ba4b0"
  readonly property color magenta: "#a292a3"
  readonly property color cyan:    "#8ea4a2"
  readonly property color white:   "#c5c9c5"

  readonly property color surface: bg
  readonly property color border:  Qt.rgba(fg.r, fg.g, fg.b, 0.08)
  readonly property color muted:   Qt.rgba(fg.r, fg.g, fg.b, 0.45)
  readonly property color accent:  blue
}
