describe chalk.green('boot/db'), ->

        _sussurro_ = new SussurroConn()
        
        it 'should be able to connect', ->
                _sussurro_.connect().then((db) ->
                        mongoose.connection.readyState.should.be.equal 1
                )
                                
        it 'should be able to disconnect', ->
                _sussurro_.disconnect().then (readyState) ->
                        readyState.should.be.equal 3

console.log chalk.yellow("==> Boot db test loaded")
