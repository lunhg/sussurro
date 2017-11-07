logger = ->
        (req, res, next) ->
        	res.on 'finish', ->
                        color = if @statusCode is '404' then chalk.red else chalk.green
                        msg   = color(this.statusCode) + ' ' + this.req.originalUrl;
                        encoding = if @_headers and @_headers['content-encoding'] then @_headers['content-encoding']
                        if encoding then msg += chalk.gray("#{encoding}")
                        console.log(msg)
                	next()
