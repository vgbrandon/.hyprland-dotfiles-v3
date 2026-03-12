import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Mpris

Item {
  implicitWidth: row.implicitWidth
  implicitHeight: row.implicitHeight

  readonly property list<MprisPlayer> players: Mpris.players.values
  readonly property MprisPlayer player: players.find(p => p.isPlaying) ?? players.find(p => p.canControl) ?? null
  readonly property bool hasPlayer: player !== null

  visible: hasPlayer

  RowLayout {
    id: row
    anchors.fill: parent
    spacing: 6

    // Anterior
    Text {
      text: "󰒮"
      color: Colors.muted
      font.pixelSize: 13
      font.family: "JetBrainsMono Nerd Font"
      MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: player?.previous()
      }
    }

    // Play / Pause
    Text {
      text: player?.isPlaying ? "󰏤" : "󰐊"
      color: Colors.yellow
      font.pixelSize: 13
      font.family: "JetBrainsMono Nerd Font"
      MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: player?.togglePlaying()
      }
    }

    // Siguiente
    Text {
      text: "󰒭"
      color: Colors.muted
      font.pixelSize: 13
      font.family: "JetBrainsMono Nerd Font"
      MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: player?.next()
      }
    }

    // Artista — Título
    Text {
      text: {
        const title = player?.trackTitle ?? ""
        const artist = player?.trackArtist ?? ""
        if (title && artist) return `${artist} — ${title}`
        return title || artist
      }
      color: Colors.fg
      font.pixelSize: 11
      font.family: "JetBrainsMono Nerd Font"
      elide: Text.ElideRight
      Layout.maximumWidth: 200
    }
  }
}
