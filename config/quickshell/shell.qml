pragma ComponentBehavior: Bound
import QtQml
import QtQuick
import Quickshell

import qs.Modules.Background
import qs.Modules.Bar

import qs.Data

ShellRoot {
  Variants {
    model: Quickshell.screens

    Scope {
      id: root
      required property var modelData

      LazyLoader {
        active: Config.options.background.wallSet;

        component: Background {
          modelData: root.modelData
        }
      }

      LazyLoader {
        active: true

        component: Bar {
          modelData: root.modelData
        }
      }
    }
  }
}
