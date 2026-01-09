pragma Singleton

import Quickshell
import QtQuick

Singleton {
  property string dmy: Qt.formatDateTime(clock.date, "dd/MM/yyyy");
  property string day: Qt.formatDateTime(clock.date, "dddd");
  property string time: Qt.formatDateTime(clock.date, "hh:mm:ss");

  SystemClock {
    id: clock
    precision: SystemClock.Seconds
  }
}
