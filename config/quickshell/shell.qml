import QtQml
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
        activeAsync: Config.options.background.wallSet

        Background {
          modelData: modelData
        }
      }
    }
  }
}
