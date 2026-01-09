import QtQuick

import qs.Services
import qs.Data

Rectangle {
  id: root

  property var conf: Config.options.appearance
  required property var screen

  implicitWidth: 500
  implicitHeight: conf.bar.width

  color: "transparent"

  Text {
    anchors {
      left: parent.left
      leftMargin: 15
      verticalCenter: parent.verticalCenter
    }

    text: {
      const window = Mango.activeWindows.find(x => x.monitor === root.screen.name);

      if (!window) {
        return "";
      }

      return window.name;
    }
    color: Config.colors.foreground

    font.family: "CaskaydiaCove NF"
    font.pixelSize: 10
  }
}
