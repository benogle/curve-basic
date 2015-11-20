# Demo

Initially it loads the curve library, and renders an editable SVG file.

Tag: `00-loads-svg`

## 01 - Add file opening

Tag: `01-open-files`

* Explain menu
* Add to application

```coffee
  openFileDialog: ->
    options = {
      title: 'Open an SVG file',
      properties: ['openFile'],
      filters: [
        { name: 'SVG files', extensions: ['svg'] }
      ]
    }

    dialog.showOpenDialog null, options, (filePaths) =>
      if filePaths
        @openFile(filePaths[0])
      # else, the user clicked cancel

  openFile: (filePath) ->
    @window.window.webContents.send('open-file', filePath)
```

* Add to index.coffee

```coffee
  ipc.on 'open-file', (filePath) ->
    editor.setFilePath(filePath)
```

* Add to editor's setFilePath

```coffee
document.title = @filePath
```

## 02 - Add represented file path

Tag: `02-represented-file`

* Add to application

```coffee
ipc.on 'set-represented-filename', (event, filePath) =>
  sendingWindow = BrowserWindow.fromWebContents(event.sender)
  sendingWindow.setRepresentedFilename(filePath)
```

* Add to editor's setFilePath

```coffee
ipc.send('set-represented-filename', @filePath)
```

## 03 - Set window edited state

Tag: `03-document-edited`

* Add to application

```coffee
ipc.on 'set-document-edited', (event, edited) =>
  sendingWindow = BrowserWindow.fromWebContents(event.sender)
  sendingWindow.setDocumentEdited(edited)
```

* Add to editor's setFilePath

```coffee
ipc.send('set-represented-filename', @filePath)
```

* Add to editor's constructor

```coffee
@svgDocument.on 'change', ->
  ipc.send('set-document-edited', true)
```

## 04 - Prompt to save when modified

Tag: `04-prompt-before-exit`

* Refactor editor.coffee to add edited state

```coffee
setEdited: (@edited) ->
  ipc.send('set-document-edited', @edited)
```

* Add save method to editor.coffee

```coffee
save: ->
  console.log 'save!'
```

* Add to index.coffee

To the top, under the requires:

```coffee
remote = require 'remote'
editor = null
```

To the end:

```coffee
window.onbeforeunload = ->
  unless editor.edited
    editor.save()
    return true

  chosen = showConfirmDialog(editor.filePath)
  switch chosen
    when 0
      editor.save()
      return true
    when 1
      return false
    when 2
      return true

showConfirmDialog = (filePath) ->
  dialog = remote.require('dialog')
  dialog.showMessageBox remote.getCurrentWindow(),
    type: 'info',
    message: "'#{filePath}' has changes, do you want to save them?"
    detailedMessage: "Your changes will be lost if you close this item without saving.",
    buttons: ["Save", "Cancel", "Don't Save"]
```
