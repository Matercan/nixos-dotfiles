import QtQuick
import Quickshell


PopupWindow {
  id: root
  required property QsMenuHandle trayItemMenuHandle

  signal menuClosed 
}
