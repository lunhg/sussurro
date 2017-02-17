### MONGODB ON CONNECTION ###
mongoose.connection.once 'open', ->
        mongoose.connection.on 'connected',   -> console.log chalk.yellow "==> sussurro data base connected"
        mongoose.connection.on 'disconnected',-> console.log chalk.cyan "==> sussurro database disconnected"
        mongoose.connection.on 'reconnected', -> console.log chalk.cyan "==> sussurro database reconnected"
        mongoose.connection.on 'error', (err) -> console.log chalk.red err.stack
        

console.log chalk.yellow("==> MongoDB once open loaded")
