ipc = require 'ipc'
path = require 'path'
remote = require 'remote'
editor = null

window.onload = ->
  Editor = require './editor'
  element = document.querySelector('#canvas')
  filePath = path.join(__dirname, '..', '..', 'cloud-upload.svg')
  editor = new Editor(element, filePath)

  ipc.on 'open-file', (filePath) ->
    editor.setFilePath(filePath)

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
