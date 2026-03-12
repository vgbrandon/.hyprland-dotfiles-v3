import Quickshell
import QtQuick

ShellRoot {
  Variants {
    model: Quickshell.screens
    Bar {
      required property var modelData
      screen: modelData
      Component.onCompleted: console.log("screen:", modelData.name, modelData.width, "x", modelData.height)
    }
  }
}
