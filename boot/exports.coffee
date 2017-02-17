### Export express app ###
sussurro.connection.connect().then (db) ->
        sussurro.configure (readyState) ->
                if readyState isnt 1
                        process.exit(1)

module.exports = sussurro.app
