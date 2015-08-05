{BufferedProcess, CompositeDisposable} = require 'atom'

module.exports =
  config:
    executablePath:
      type: 'string'
      description: 'The path to the Reek executable. Find by running `which reek` or `rbenv which reek`'
      default: 'reek'

  activate: ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.config.observe 'linter-ruby-reek.executablePath',
     (executablePath) =>
        @executablePath = executablePath

  deactivate: ->
    @subscriptions.dispose()

  provideLinter: ->
    provider =
      grammarScopes: ['source.ruby', 'source.ruby.rails', 'source.ruby.rspec']
      scope: 'file'
      lintOnFly: true
      lint: (TextEditor) =>
        new Promise (resolve, reject) =>
          filePath = TextEditor.getPath()
          json = []
          process = new BufferedProcess
            command: @executablePath
            args: [filePath, '-s']

            stdout: (data) ->
              json = data.split('\n')

            exit: (code) ->
              console.log "code is #{code}"
              return resolve [] unless code is 2

              info        = {"errors": []}
              info.errors = (err for err in json)

              info.errors.shift();
              info.errors.pop();

              return resolve [] unless info?
              return resolve [] if info.passed

              resolve info.errors.map (error) ->
                type: 'warning'
                text: error.split(':')[2]           # text: error.message,
                filePath: filePath                  # filePath: error.file or filePath,
                range: [
                  [parseInt(error.split(':')[1])-1, 0],
                  [parseInt(error.split(':')[1])-1, 80]
                ]

          process.onWillThrowError ({error,handle}) ->
            atom.notifications.addError "Failed to run #{@executablePath}",
            detail: "#{error.message}"
            dismissable: true
            handle()
            resolve
