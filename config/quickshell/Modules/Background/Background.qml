/* Copied this compeltedly from rexi, ty oomfie <3 */

import QtQuick
import Quickshell
import Quickshell.Wayland

import qs.Data
import qs.Generics

WlrLayershell {
  id: root

  required property var modelData

  anchors {
    bottom: true
    right: true
    top: true
    left: true
  }

  margins {
    left: -20
  }

  color: "transparent"
  exclusionMode: ExclusionMode.Ignore
  focusable: false
  implicitHeight: 28
  layer: WlrLayer.Bottom
  namespace: "Quickshell:background"
  screen: modelData
  surfaceFormat.opaque: false

  Wallpaper {
    id: wallpaper

    anchors.fill: parent
    source: ""

    Component.onCompleted: {

      if (Config.ready) {
        wallpaper.source = Config.options.background.wallSrc;
      }

      Config.readyChanged.connect(() => {
        if (Config.ready) {
          wallpaper.source = Config.options.background.wallSrc;
        }
      });

      // Connect to wallSrc changes
      Config.options.background.wallSrcChanged.connect(() => {
        if (walAnim.running) {
          walAnim.complete();
        }
        animatingWal.source = Config.options.background.wallSrc;
      });

      animatingWal.statusChanged.connect(() => {
        if (animatingWal.status == Image.Ready) {
          walAnim.start();
        }
      });

      walAnim.finished.connect(() => {
        wallpaper.source = animatingWal.source;
        animatingWal.source = "";
        animatingRect.width = 0;
      });
    }
  }

  Rectangle {
    id: animatingRect

    anchors.right: parent.right
    clip: true
    color: "transparent"
    height: root.screen.height
    width: 0

    Anims.EmphAnim {
      id: walAnim
      target: animatingRect

      property: "width"
      duration: MaterialEasing.emphasizedTime * 5
      from: 0
      to: root.screen.width
    }

    Wallpaper {
      id: animatingWal
      anchors.right: parent.right
      height: root.height
      source: ""
      width: root.width
    }
  }
}
