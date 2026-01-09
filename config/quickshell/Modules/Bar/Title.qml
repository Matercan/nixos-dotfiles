import QtQuick

import qs.Services
import qs.Data

Rectangle {
  id: root

  property var conf: Config.options.appearance
  required property var screen

  implicitWidth: 500
  implicitHeight: conf.bar.width

  color: Config.colors.regular0

  Text {
    anchors.centerIn: parent

    text: {
      const window = Mango.activeWindows.find(x => x.monitor === root.screen.name);

      if (!window) {
        return "";
      }

      return window.name;
    }
    color: "white"

    font.family: "CaskaydiaMono Nerd font"
    font.pixelSize: 10
  }
}
