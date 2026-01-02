import QtQuick
import Quickshell

import qs.Data

PanelWindow {
  required property var modelData

  screen: modelData

  anchors {
    left: true
    top: true
    bottom: true
  }

  implicitWidth: Config.options.appearance.bar.width
}
