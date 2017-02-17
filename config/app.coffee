# STARTING EXPRESS
class App
        constructor: ->
                @connection = new SussurroConn()
                @isConnected = false
                @isConfigured = false       
                @app = express()

console.log chalk.yellow("==> App helper loaded")
