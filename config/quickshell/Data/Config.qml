pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
  id: root

  property alias options: configOptionsJsonAdapter
  property alias colors: colorsOptionsAdapter
  property bool ready: false
  property int readWriteDelay: 50 // miliseconds
  property bool blockWrites: false
  property string dirPath: Quickshell.env("HOME") + "/.config/quickshell/Data/"

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
    path: root.dirPath + "config.json"
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
          property int width

          property bool wkEnabled
          property int wkWidth
        }

        property JsonObject spacing: JsonObject {
          property int small
          property int medium
          property int large
        }

        property JsonObject size: JsonObject {
          property int small
          property int medium
          property int large
        }

        property JsonObject padding: JsonObject {
          property int small
          property int medium
          property int large
        }
      }
      property JsonObject text: JsonObject {
        property string font
        property int size
      }


      property JsonObject background: JsonObject {
        property string wallSrc
        property bool wallSet
      }
    }
  }

  FileView {
    id: colorsFileView
    path: root.dirPath + "colors.json"
    watchChanges: true

    blockWrites: root.blockWrites
    onFileChanged: reload()
    onAdapterChanged: writeAdapter()
    onLoaded: root.ready = true
    onLoadFailed: err => {
      if (err == FileViewError.FileNotFound) {
        writeAdapter();
      }
    }

    JsonAdapter {
      id: colorsOptionsAdapter

      property string background
      property string foreground
      property string text
      property string border
      property string accent
      property string secondary
      property string secondary_text
      property string selection
      property string slection_background

      property string regular0
      property string regular1
      property string regular2
      property string regular3
      property string regular4
      property string regular5
      property string regular6
      property string regular7
      property string regular8

      property string bright0
      property string bright1
      property string bright2
      property string bright3
      property string bright4
      property string bright5
      property string bright6
      property string bright7
    }
  }
}
