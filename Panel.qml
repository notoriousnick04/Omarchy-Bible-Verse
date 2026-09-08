import QtQuick
import Quickshell
import qs.Commons
import qs.Ui
import "Model.js" as Model

// Popup showing today's bible verse in full. Reading-only and offline: a
// citation header and the verse text, with nothing else.
Panel {
  id: root
  moduleName: "Omarchy-BibleVerse"
  ipcTarget: "Omarchy-BibleVerse"
  manageIpc: false

  property var anchorItem: null
  property var hostWidget: null
  readonly property var barIdentity: hostWidget || root

  property date today: new Date()
  readonly property var current: Model.verseForDay(today.getFullYear(), today.getMonth(), today.getDate())

  // Guarded so the widget renders before the bar is injected.
  readonly property color contentForeground: bar ? bar.foreground : Color.foreground
  readonly property string contentFontFamily: bar ? bar.fontFamily : Style.font.family

  function open() {
    refresh()
    root.controller.show()
    Qt.callLater(function() {
      if (root.opened) setCenterHoverRevealSuppressed(true)
    })
  }

  function close() {
    setCenterHoverRevealSuppressed(false)
    root.controller.hide()
  }

  function toggle() {
    if (root.opened) root.close()
    else root.open()
  }

  function switchPanel(direction) {
    if (root.bar && typeof root.bar.switchPanelFrom === "function")
      return root.bar.switchPanelFrom(root.barIdentity, direction)
    return false
  }

  function setCenterHoverRevealSuppressed(value) {
    if (root.bar && "centerHoverRevealSuppressed" in root.bar)
      root.bar.centerHoverRevealSuppressed = value
  }

  function refresh() {
    root.today = new Date()
  }

  SystemClock {
    id: clock
    precision: SystemClock.Minutes
    onDateChanged: root.today = date
  }

  KeyboardPanel {
    id: panel
    anchorItem: root.anchorItem
    owner: root.barIdentity
    bar: root.bar
    open: root.opened
    focusTarget: keyCatcher
    contentWidth: panel.fittedContentWidth(Style.space(480))
    contentHeight: panel.fittedContentHeight(cardColumn.implicitHeight)

    PanelKeyCatcher {
      id: keyCatcher
      anchors.fill: parent
      onCloseRequested: root.close()
      onTabRequested: function(direction) { root.switchPanel(direction) }
    }

    Flickable {
      id: verseScroll
      anchors.fill: parent
      contentWidth: cardColumn.width
      contentHeight: cardColumn.implicitHeight
      clip: true
      boundsBehavior: Flickable.StopAtBounds
      interactive: contentHeight > height || contentWidth > width

      Column {
        id: cardColumn
        width: verseScroll.width
        spacing: Style.space(16)

        Column {
          width: parent.width
          spacing: Style.space(6)

          Text {
            textFormat: Text.PlainText
            anchors.horizontalCenter: parent.horizontalCenter
            text: root.current.ref
            color: Style.hoverStateColor(root.contentForeground, Color.accent)
            font.family: root.contentFontFamily
            font.pixelSize: Style.font.caption
            font.letterSpacing: 2
            font.bold: true
          }

          Rectangle {
            anchors.horizontalCenter: parent.horizontalCenter
            width: Style.space(40)
            height: Style.spacing.hairline
            color: root.contentForeground
            opacity: 0.2
          }
        }

        Text {
          id: verseText
          textFormat: Text.Wrap
          width: parent.width
          horizontalAlignment: Text.AlignHCenter
          text: root.current.text
          color: root.contentForeground
          font.family: root.contentFontFamily
          font.pixelSize: Style.font.title
          font.italic: true
          lineHeight: 1.45
          wrapMode: Text.WordWrap
        }
      }
    }
  }
}