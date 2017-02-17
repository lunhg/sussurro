describe chalk.green("config/app"), ->

        it 'should be disconnected', ->
                mongoose.connection.readyState.should.is.equal 0

console.log chalk.yellow("==> App config test loaded")
