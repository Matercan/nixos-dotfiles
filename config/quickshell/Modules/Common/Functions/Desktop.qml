pragma Singleton

import Quickshell

Singleton {
  function removeNotifications(window: string): string {
    return window.replace(/^\(\d+\)\s*/, '');
  }

  function getNotifications(window: string): int {
    var match = window.match(/\((\d+)\)/);
    if (match) {
      var str = parseInt(match[1], 10);
      if (str >= 9)
        return 9;
      else
        return str;
    }
    return 0;
  }
}
