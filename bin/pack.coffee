#!/usr/bin/env coffee

Snockets = require 'snockets'
program  = require 'commander'
events   = require 'events'
fs       = require 'fs'
path     = require 'path'

dispatcher = new events.EventEmitter

program
  .version('0.0.4')
  .option('-w, --watch <directory>',  'Directory to watch file changes within')
  .option('-o, --output <directory>', 'Directory to output changed files')
  .option('-i, --input <file>',       'Input file')
  .option('-m, --minify',             'Minify the JavaScript output')

program
  .on '--help', ->
    console.log """
                ----------------------------------------------------------------

                  Examples:

                    Compile with dependencies and minify a single file,
                    then output it to STDOUT:
                    > packjs --minify --input coffee/main.coffee

                    Output the compiled JavaScript into a particular file:
                    > packjs --input coffee/main.coffee > ../public/js/main.js

                    Watch a folder recursively and recompile on each change,
                    note that -o (output) option is required:
                    > packjs --minify --watch coffee/ --output ../public/js/
                """

program
  .parse(process.argv)

config =
  minify : !!program.minify
  watch  : program.watch
  output : program.output

merge =
  single: (file, callback) ->
    snockets   = new Snockets()

    that       = @
    js         = snockets.getConcatenation file, { minify: config.minify, async: false }
    result     = "// Generated by CoffeeScript#{ if program.minify then ', minified with UglifyJS' else '' }\n#{ js }"
    
    outputFile = path.resolve( config.output, path.basename(file, '.coffee') ) + '.js'

    if config.output
      fs.writeFile outputFile, result, (err) ->
        if err
          throw err
        else
          console.log "[#{ that.formatTime() }] Updated #{ path.basename outputFile }"

        callback?()
    else
      console.log result
      callback?()
          
  batch: ->
    for file in @topLevelFiles
      @single file

  watchDir: (directory, callback) ->
    that = @

    fs.readdir directory, (err, files) ->
      throw err if err

      for file in files
        fullPath = path.resolve directory, file

        do (fullPath) ->
          fs.stat fullPath, (err, stats) ->
            throw err if err

            if stats.isDirectory()
              merge.watchDir fullPath, callback 
            else
              dispatcher.emit 'topLevelFile:added', fullPath if path.dirname(fullPath) is path.resolve(config.watch)

      fs.watch directory, (event, fileName) ->
        callback?()

  padZero: (number) ->
    (if number < 10 then '0' else '') + number

  formatTime: ->
    now = new Date
    return "#{ @padZero now.getHours() }:#{ @padZero now.getMinutes() }:#{ @padZero now.getSeconds() }"

  topLevelFiles: []

dispatcher.on 'mode:compile', (params) ->
  merge.single params.file, ->
    dispatcher.emit 'exit'

dispatcher.on 'mode:watch', (params) ->
  unless path.existsSync config.output
    fs.mkdirSync config.output

  merge.watchDir params.directory, ->
    merge.batch()

dispatcher.on 'topLevelFile:added', (path) ->
  merge.topLevelFiles.push path
  merge.batch()

dispatcher.on 'exit', ->
  process.exit()

# Initialization
if program.watch
  dispatcher.emit 'mode:watch',
    directory : program.watch
    output    : program.output
else
  dispatcher.emit 'mode:compile',
    file   : program.input

# Handling errors
process.on 'uncaughtException', (err) ->
  console.log "Error:\n#{ err.message }"
