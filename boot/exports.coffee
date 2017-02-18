### Export express app ###
sussurro.connection.connect().then (db) ->
        sussurro.configure (readyState) ->
                if readyState is 1 then console.log chalk.cyan("==> Server ready")

module.exports = sussurro.app
