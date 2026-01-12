pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets

import QtQuick.Layouts
import QtQuick

import qs.Data

Rectangle {
  id: root
  property var config: Config.options.appearance

  implicitWidth: layout.width + config.padding.medium * 2
  implicitHeight: config.bar.width
  color: Config.colors.background

  RowLayout {
    id: layout
    spacing: 10
    anchors.centerIn: parent

    Repeater {
      model: SystemTray.items

      delegate: MouseArea {
        id: del
        required property SystemTrayItem modelData
        implicitWidth: root.config.bar.width * 0.75
        implicitHeight: width
        hoverEnabled: true

        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: event => {
          switch (event.button) {
          case Qt.LeftButton:
            del.modelData.activate();
            break;
          case Qt.RightButton:
            if (del.modelData.hasMenu) {
              menu.open();
              break;
            }
          }
          event.accepted = true;
        }

        onEntered: implicitWidth *= 1.15
        onExited: implicitWidth /= 1.15

        Behavior on height {
          Anim {}
        }

        Loader {
          id: menu
          function open() {
            menu.active = true;
          }
          active: false
          sourceComponent: TrayMenu {
            Component.onCompleted: menu.open()
            trayItemMenuHandle: del.modelData.menu

            anchor {
              rect.x: del.x + root.config.bar.width
              rect.y: del.y
              window: del.QsWindow.window
            }

            onMenuClosed: {
              menu.active = false;
            }
          }
        }

        IconImage {
          id: icon
          source: del.modelData.icon
          anchors.fill: parent
        }
      }
    }
  }

  component Anim: Anims.EmphAnim {}
}
