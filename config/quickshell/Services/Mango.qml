pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
  id: root

  property var activeTags: []
  property var tags: [] // One for each monitor
  property var activeWindows: []

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
        let activeTagsCopy = [];

        let monIndex = tagsCopy.findIndex(m => m.length > 0 && m[0].monitor === monitor);

        if (monIndex === -1) {
          // New monitor
          tagsCopy.push([
            {
              monitor: monitor,
              tag: tId,
              state: tState,
              numWindows: tNumClients
            }
          ]);
        } else {
          // Existing monitor - find or update tag
          let mon = tagsCopy[monIndex];
          let tagIndex = mon.findIndex(t => t.tag === tId);

          if (tagIndex === -1) {
            // New tag
            mon.push({
              monitor: monitor,
              tag: tId,
              state: tState,
              numWindows: tNumClients
            });
          } else {
            // Update existing tag
            mon[tagIndex] = {
              monitor: monitor,
              tag: tId,
              state: tState,
              numWindows: tNumClients
            };
          }
        }

        // Rebuild active tags list from all monitors
        tagsCopy.forEach(mon => {
          mon.forEach(tag => {
            if (tag.state === Mango.Active) {
              activeTagsCopy.push({
                tag: tag.tag,
                mon: tag.monitor
              });
            }
          });
        });

        // Update properties to trigger changes
        root.tags = tagsCopy;
        root.activeTags = activeTagsCopy;
      }
    }
  }

  Process {
    command: ["mmsg", "-w", "-c"]
    running: true

    stdout: SplitParser {
      onRead: line => {

        const titleRegex = /(.*) title (.*)/;
        const classRegex = /(.*) appid (.*)/;

        let titleMatch = titleRegex.exec(line);
        let classMatch = classRegex.exec(line);

        if (titleMatch) {
          // It's a title line
          const monitor = titleMatch[1];
          const title = titleMatch[2];


          let windowsCopy = root.activeWindows.slice();
          let monIndex = windowsCopy.findIndex(m => m.monitor === monitor);

          if (monIndex === -1) {
            // Create new entry
            windowsCopy.push({
              monitor: monitor,
              name: title,
              tag: root.activeTags.find(t => t.mon === monitor),
              appId: null
            });
          } else {
            // Update existing entry
            let existing = windowsCopy[monIndex];
            windowsCopy[monIndex] = {
              monitor: existing.monitor,
              name: title,
              tag: existing.tag,
              appId: existing.appId
            };
          }

          root.activeWindows = windowsCopy;
        } else if (classMatch) {
          // It's an appid line
          const monitor = classMatch[1];
          const appid = classMatch[2];


          let windowsCopy = root.activeWindows.slice();
          let monIndex = windowsCopy.findIndex(m => m.monitor === monitor);

          if (monIndex === -1) {
            // Create new entry
            windowsCopy.push({
              monitor: monitor,
              appId: appid,
              tag: root.activeTags.find(t => t.mon === monitor),
              name: null
            });
          } else {
            // Update existing entry
            let existing = windowsCopy[monIndex];
            windowsCopy[monIndex] = {
              monitor: existing.monitor,
              name: existing.name,
              tag: existing.tag,
              appId: appid
            };
          }

          root.activeWindows = windowsCopy;
        } else {
          console.log("No match for line:", line);
        }
      }
    }
  }
}
