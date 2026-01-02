pragma Singleton
import Quickshell
import QtQml
import QtQuick

Singleton {
  function applyAlpha(color: string, alpha: real): color {
    var c = Qt.color(color);
    return Qt.rgba(c.r, c.g, c.b, alpha);
  }
}
