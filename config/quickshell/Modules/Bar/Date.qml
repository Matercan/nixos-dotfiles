import QtQuick
import qs.Services
import qs.Modules.Common
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

    StyledText {
      anchors.verticalCenter: parent.verticalCenter
      text: DateTime.time
    }

    Divider {}

    StyledText {
      anchors.verticalCenter: parent.verticalCenter
      text: DateTime.day
    }

    Divider {}

    StyledText {
      anchors.verticalCenter: parent.verticalCenter
      text: DateTime.dmy
    }
  }

  component Divider: Rectangle {
    anchors.verticalCenter: parent.verticalCenter

    color: Config.colors.foreground
    height: parent.height * 0.8
    width: 1
  }
}
