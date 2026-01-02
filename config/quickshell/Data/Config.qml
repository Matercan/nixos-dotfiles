pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
  id: root

  property alias options: configOptionsJsonAdapter
  property bool ready: false
  property int readWriteDelay: 50 // miliseconds
  property bool blockWrites: false
  property string filePath: Quickshell.env("HOME") + "/.config/quickshell/Data/config.json";


  function setNestedValue(nestedKey: string, value) {
    let keys = nestedKey.split('.');
    let obj = root.options;
    let parents = [obj];

    for (let key in keys) {
      if (!obj[key] || typeof obj[key] !== "object") {
        obj[key] = {};
      }
      obj = obj[key];
      parents.push(obj);
    }

    let convertedValue = value;
    if (typeof value === "string") {
      let trimmed = value.trim();
      if (trimmed === "true" || trimmed === "false" || !isNaN(Number(trimmed))) {
        try {
          convertedValue = JSON.parse(trimmed);
        } catch (_) {
          convertedValue = value;
        }
      }
    }

    obj[keys[keys.length - 1]] = convertedValue;
  }

  FileView {
    id: configFileView
    path: root.filePath
    watchChanges: true

    blockWrites: root.blockWrites
    onFileChanged: reload()
    onAdapterUpdated: writeAdapter()
    onLoaded: root.ready = true
    onLoadFailed: err => {
      if (err == FileViewError.FileNotFound) {
        writeAdapter();
      }
    }

    JsonAdapter {
      id: configOptionsJsonAdapter

      property JsonObject appearance: JsonObject {
        property JsonObject bar: JsonObject {
          property int width: 15
        }
      }
      property JsonObject background: JsonObject {
        property string wallSrc: Quickshell.env("HOME") + "/.config/assets/wallpaper.png"
        property bool wallSet: true
      }
    }
  }
}
