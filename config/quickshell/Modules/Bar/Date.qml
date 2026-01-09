import QtQuick
import qs.Services
import qs.Modules.Generics
import qs.Data

Rectangle {
  implicitWidth: row.width
  implicitHeight: Config.options.appearance.bar.width

  color: "transparent"

  Row {
    id: row
    height: parent.height
    spacing: 5

    anchors {
      right: parent.right
      rightMargin: 5
      verticalCenter: parent.verticalCenter
    }

    Text {
      anchors.verticalCenter: parent.verticalCenter

      text: DateTime.time
      color: Config.colors.foreground

      font.family: "CaskaydiaCove NF"
      font.pixelSize: 10
    }

    Divider {}

    Text {
      anchors.verticalCenter: parent.verticalCenter

      text: DateTime.day
      color: Config.colors.foreground

      font.family: "CaskaydiaCove NF"
      font.pixelSize: 10
    }

    Divider {}

    Text {

      anchors.verticalCenter: parent.verticalCenter

      text: DateTime.dmy
      color: Config.colors.foreground

      font.family: "CaskaydiaCove NF"
      font.pixelSize: 10
    }
  }

  component Divider: Rectangle {
    anchors.verticalCenter: parent.verticalCenter

    color: Config.colors.foreground
    height: parent.height * 0.8
    width: 1
  }
}
