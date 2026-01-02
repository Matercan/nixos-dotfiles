pragma ComponentBehavior: Bound
import QtQml
import QtQuick
import Quickshell

import qs.Background
import qs.Data

ShellRoot {
  Variants {
    model: Quickshell.screens

    Scope {
      id: root
      required property var modelData
      LazyLoader {
        active: true
        loading: true

        component: Background {
          modelData: root.modelData
        }
      }
    }
  }
}
