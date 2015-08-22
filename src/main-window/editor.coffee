fs = require 'fs'
{SVGDocument} = require('curve')

module.exports =
class Main
  constructor: (@canvasElement, filePath) ->
    @svgDocument = new SVGDocument(@canvasElement)
    @svgDocument.initializeTools()
    @setFilePath(filePath)
    @updateDocumentSize()

  setFilePath: (@filePath) ->
    svgFile = fs.readFileSync(@filePath, {encoding: 'utf8'})
    @svgDocument.deserialize(svgFile)

  updateDocumentSize: ->
    size = this.svgDocument.getSize()
    @canvasElement.style.width = "#{size.width}px"
    @canvasElement.style.height = "#{size.height}px"
    @canvasElement.parentNode.style.minWidth = "#{size.width}px"
