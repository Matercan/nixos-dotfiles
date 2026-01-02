import QtQml
import QtQuick

AnimatedImage {
  antialiasing: true
  asynchronous: true
  fillMode: Image.PreserveAspectCrop
  layer.enabled: true
  retainWhileLoading: true
  smooth: true
  source: Config.data.wallSrc
}
