pragma ComponentBehavior: Bound
import QtQuick

Item {
  id: root

  required property color color
  property int bwidth: 2
  property QtObject sides: QtObject {
    property bool top: true
    property bool bottom: false
    property bool left: false
    property bool right: false
  }

  Side {
    visible: root.sides.top

    anchors {
      left: parent.left
      top: parent.top
      right: parent.right
    }
  }
  Side {
    visible: root.sides.left

    anchors {
      left: parent.left
      top: parent.top
      bottom: parent.bottom
    }
  }
  Side {
    visible: root.sides.bottom

    anchors {
      left: parent.left
      right: parent.right
      bottom: parent.bottom
    }
  }
  Side {
    visible: root.sides.right

    anchors {
      right: parent.right
      top: parent.top
      bottom: parent.bottom
    }
  }

  component Side: Rectangle {
    color: root.color
    implicitHeight: root.width
    implicitWidth: root.width
  }
}
