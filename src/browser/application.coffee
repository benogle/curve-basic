ApplicationWindow = require './application-window'
app = require 'app' # provided by electron
dialog = require 'dialog' # provided by electron

module.exports =
class Application
  window: null

  constructor: (options) ->
    global.application = this

    # Report crashes to our server.
    require('crash-reporter').start()

    # Quit when all windows are closed.
    app.on 'window-all-closed', -> app.quit()
    app.on 'ready', => @openWindow()

  openWindow: ->
    htmlURL = "file://#{__dirname}/../main-window/index.html"
    @window = new ApplicationWindow htmlURL,
      width: 1200,
      height: 800

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
