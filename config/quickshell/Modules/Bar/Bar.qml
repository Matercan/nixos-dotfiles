pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts

import Quickshell

import qs.Data

PanelWindow {
  id: root
  required property var modelData
  property var config: Config.options.appearance

  screen: modelData

  anchors {
    left: true
    top: true
    right: true
  }

  implicitHeight: root.config.bar.width

  color: Config.colors.background

  RowLayout {
    Loader {
      Layout.preferredWidth: children[0].width
      Layout.preferredHeight: children[0].height
      Layout.alignment: Qt.AlignCenter

      active: true

      sourceComponent: WkWidget {
        anchors.centerIn: parent

        screen: root.screen
      }
    }

    Loader {
      active: true
      asynchronous: true

      Layout.preferredWidth: children[0].width
      Layout.preferredHeight: children[0].height
      Layout.alignment: Qt.AlignCenter

    }
  }
}
