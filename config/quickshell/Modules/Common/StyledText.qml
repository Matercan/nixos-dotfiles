import QtQuick
import qs.Data

Text {
  color: Config.colors.foreground
  property var opts: Config.options.text

  font {
    family: opts.font
    pixelSize: opts.size
  }
}
