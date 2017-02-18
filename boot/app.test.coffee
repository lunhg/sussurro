describe chalk.green("boot/app"), ->
             
        it 'should be connect with mongodb',->
                sussurro.connection
                        .connect()
                        .then sussurro.configure
                        .then (readyState) ->
                                readyState.should.be.equal 1
                                        
console.log chalk.yellow("==> App boot test loaded")
