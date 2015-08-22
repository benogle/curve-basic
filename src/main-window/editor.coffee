fs = require 'fs'
ipc = require 'ipc'
{SVGDocument} = require 'curve'

module.exports =
class Editor
  constructor: (@canvasElement, filePath) ->
    @svgDocument = new SVGDocument(@canvasElement)
    @svgDocument.initializeTools()
    @setFilePath(filePath)
    @updateDocumentSize()

    @svgDocument.on 'change', ->
      ipc.send('set-document-edited', true)

  setFilePath: (@filePath) ->
    @clearDocument()
    svgFile = fs.readFileSync(@filePath, {encoding: 'utf8'})
    @svgDocument.deserialize(svgFile)
    document.title = @filePath
    ipc.send('set-represented-filename', @filePath)
    ipc.send('set-document-edited', false)

  clearDocument: ->
    @svgDocument.getObjectLayer().clear()
    @svgDocument.model.reset()

  updateDocumentSize: ->
    size = this.svgDocument.getSize()
    @canvasElement.style.width = "#{size.width}px"
    @canvasElement.style.height = "#{size.height}px"
    @canvasElement.parentNode.style.minWidth = "#{size.width}px"
