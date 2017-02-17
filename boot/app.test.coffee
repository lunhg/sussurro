describe chalk.green("boot/app"), ->
             
        it 'should be connect with mongodb',->
                new Promise (resolve, reject) ->
                        sussurro.connection
                                .connect()
                                .then sussurro.configure
                                .then (readyState) ->
                                        readyState.should.be.equal 1
                                        resolve()
                                        
console.log chalk.yellow("==> App boot test loaded")
