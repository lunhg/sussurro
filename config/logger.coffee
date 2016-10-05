var chalk = require('chalk');

logger = ->
        (req, res, next) ->
        	res.on 'finish', ->
                        color = @statusCode is '404' then chalk.red else chalk.green
                        msg   = color(this.statusCode) + ' ' + this.req.originalUrl;
                        encoding = @_headers and @_headers['content-encoding']
                        if encoding
                		msg += chalk.gray("#{encoding}")
                                console.log(msg)
                	next()
