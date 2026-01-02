import QtQuick
import Quickshell

import qs.Data
import qs.Modules.Common.Functions

PanelWindow {
  required property var modelData

  screen: modelData

  anchors {
    left: true
    top: true
    bottom: true
  }

  implicitWidth: Config.options.appearance.bar.width

  color: Colors.applyAlpha("#ffffff", 0.2)
}
