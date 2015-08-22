path = require 'path'

window.onload = ->
  Editor = require './editor'
  element = document.querySelector('#canvas')
  filePath = path.join(__dirname, '..', '..', 'cloud-upload.svg')
  new Editor(element, filePath)
