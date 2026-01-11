pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts

import Quickshell.Services.SystemTray
import Quickshell.Widgets

import qs.Data

Rectangle {
  id: root
  property var config: Config.options.appearance

  implicitWidth: layout.width
  implicitHeight: config.bar.width
  color: Config.colors.background

  RowLayout {
    id: layout
    spacing: 10
    anchors.centerIn: parent

    Repeater {
      model: SystemTray.items

      delegate: IconImage {
        required property var modelData

        source: modelData.icon
        implicitSize: root.config.bar.width * 0.75
      }
    }
  }
}
