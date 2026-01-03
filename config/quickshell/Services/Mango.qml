pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
  id: root

  property var activeTags: []
  property var tags: [] // One for each monitor

  enum Mango {
    Active = 1,
    Inactive = 0
  }

  Process {
    command: ["mmsg", "-w", "-t"]
    running: true

    stdout: SplitParser {
      onRead: line => {
        const regEx = /(.*) tag (\d) (\d) (\d) (\d)/;  
        const data = regEx.exec(line);
        if (!data) {
          return;
        }

        const monitor = data[1];      
        const tId = parseInt(data[2]);
        const tState = parseInt(data[3]);
        const tNumClients = parseInt(data[4]);

        let tagsCopy = root.tags.slice();
        let activeTagsCopy = root.activeTags.slice();

        // Find the monitor with that name, if it doesn't exist create it
        var mon = tagsCopy.find(m => m.length > 0 && m[0].monitor === monitor);

        if (!mon) {
          mon = [];
          tagsCopy.push(mon);
        }

        // Push to the monitor the tag information
        mon.push({
          monitor: monitor,
          tag: tId,
          state: tState,
          numWindows: tNumClients
        });

        root.tags = tagsCopy; // Hack to update the tagsChanged

        // If it's active, push it to the list of active tags
        if (tState !== Mango.Active) { // Insane hack, but if it works it works :>
          activeTagsCopy.push({
            tag: tId,
            mon: monitor
          });
        }

        root.activeTags = activeTagsCopy;
      }
    }
  }
}
