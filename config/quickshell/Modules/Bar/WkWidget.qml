pragma ComponentBehavior: Bound
import QtQuick
import Quickshell

import qs.Data
import qs.Services

Rectangle {
  id: root
  implicitWidth: row.width + 2 * conf.padding.medium
  implicitHeight: row.height

  property var conf: Config.options.appearance
  property var colors: Config.colors
  required property var screen
  color: Config.colors.regular0

  Row {
    id: row
    width: root.conf.wkWidth
    spacing: root.conf.spacing.large
    height: root.conf.bar.width
    anchors.centerIn: parent

    Component.onCompleted: {
      Mango.tagsChanged.connect(() => {
        const monitor = Mango.tags.find(m => m.length > 0 && m[0].monitor === root.screen.name);

        // Handle case where monitor isn't found yet
        if (!monitor || monitor.length === 0) {
          model.values = [];
          return;
        }

        const open = monitor.filter(t => t.numWindows > 0);

        if (open.length === 0) {
          model.values = [];
          return;
        }

        const lastWindow = open[open.length - 1];
        const result = [];

        for (let i = 1; i <= lastWindow.tag; i++) {
          result.push(i);
        }

        model.values = result;
      });
    }

    Repeater {
      model: ScriptModel {
        id: model
      }

      delegate: Rectangle {
        id: icon
        anchors.verticalCenter: parent.verticalCenter

        required property int modelData

        implicitWidth: height
        implicitHeight: row.height / (2 * Math.SQRT2)

        property bool active: Mango.activeTags.find(x => x.tag === icon.modelData && root.screen.name === x.mon) != null

        rotation: 45
        color: active ? Config.colors.accent : Config.colors.foreground
        radius: active ? height / 2 : 0

        Behavior on radius {
          Anim {}
        }

        antialiasing: true
      }
    }
  }

  component Anim: Anims.EmphAnim {}
}
