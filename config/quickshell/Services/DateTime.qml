pragma Singleton

import Quickshell
import QtQuick

Singleton {
  property string dmy: Qt.formatDateTime(clock.date, "dd/MM/yyyy");
  property string day: Qt.formatDateTime(clock.date, "dddd");

  SystemClock {
    id: clock
    precision: SystemClock.Seconds
  }
}
