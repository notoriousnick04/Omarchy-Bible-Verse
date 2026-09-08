# Omarchy-BibleVerse

Daily Bible verse bar widget for [Omarchy](https://omarchy.org). Shows a verse citation in the bar; click to read the full text in a popup.

## Features

- Daily rotating verse (deterministic — same verse all day, rolls over at midnight)
- 190 offline KJV verses — no network required
- Click bar widget to open full-text popup
- Keyboard navigation support

## Install

```bash
omarchy plugin clone https://github.com/yourname/Omarchy-BibleVerse
```

Or manually:

```bash
git clone https://github.com/yourname/Omarchy-BibleVerse ~/.config/omarchy/plugins/Omarchy-BibleVerse
omarchy-shell shell rescanPlugins
omarchy plugin enable Omarchy-BibleVerse
```

## Files

| File | Purpose |
|------|---------|
| `manifest.json` | Plugin metadata |
| `BarWidget.qml` | Bar entry showing today's verse citation |
| `Panel.qml` | Popup with full verse text |
| `Model.js` | Offline verse data + daily rotation logic |

## License

MIT
