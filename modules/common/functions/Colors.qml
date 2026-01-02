pragma Singleton

import QtQuick
import Quickshell
import QtQml

Singleton {
    function transparentize(c: Qt.color, alpha: real) {
        var a = Math.max(0, Math.min(1, alpha));
        return Qt.rgba(c.r, c.g, c.b, a);
    }
}
