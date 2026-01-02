import QtQml
import QtQuick

import qs.Config

AnimatedImage {
  antialiasing: true
  asynchronous: true
  fillMode: Image.PreserveAspectCrop
  layer.enabled: true
  retainWhileLoading: true
  smooth: true
  source: Config.options.background.wallpaperSrc
}
