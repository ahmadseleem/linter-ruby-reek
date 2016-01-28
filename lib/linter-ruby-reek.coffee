{BufferedProcess, CompositeDisposable, File} = require 'atom'

module.exports =
  config:
    executablePath:
      type: 'string'
      description: 'The path to the Reek executable. Find by running `which reek` or `rbenv which reek`'
      default: 'reek'
    configPath:
      type: 'string'
      description: 'The path to the Reek config. Default is config.reek (optional)'
      default: 'config.reek'

  activate: ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.config.observe 'linter-ruby-reek.executablePath',
     (executablePath) =>
        @executablePath = executablePath
    @subscriptions.add atom.config.observe 'linter-ruby-reek.configPath',
     (configPath) =>
        @configPath = configPath

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
          args = [filePath, "-s"]

          projectPath = atom.project.getPaths()[0]
          absConfigPath = "#{projectPath}/#{@configPath}"
          configFile = new File(absConfigPath, false)

          if configFile.existsSync()
            args.push "-c", "#{absConfigPath}"

          process = new BufferedProcess
            command: @executablePath
            args: args
            stdout: (data) ->
              json = data.split('\n')

            exit: (code) ->
              return resolve [] unless code is 2

              info        = {"errors": []}
              info.errors = (err for err in json)

              info.errors.shift();
              info.errors.pop();

              return resolve [] unless info?
              return resolve [] if info.passed

              docLinkPattern = ///\[(.+)\]$///i

              resolve info.errors.map (error) ->
                errorName = error.split(':')[2].trim()
                errorDesc = error.split(':')[3].split('[')[0].trim()
                docLink   = error.match(docLinkPattern)[1]
                errBadge  = '<span class="badge badge-flexible">reek</span>'
                errHtml   = "#{errBadge} <a href='#{docLink}'>#{errorName}</a>: #{errorDesc}"

                type: 'warning'
                html: errHtml
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
