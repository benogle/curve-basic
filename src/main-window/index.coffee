ipc = require 'ipc'
path = require 'path'

window.onload = ->
  Editor = require './editor'
  element = document.querySelector('#canvas')
  filePath = path.join(__dirname, '..', '..', 'cloud-upload.svg')
  editor = new Editor(element, filePath)

  ipc.on 'open-file', (filePath) ->
    editor.setFilePath(filePath)
