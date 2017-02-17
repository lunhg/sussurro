describe chalk.green("app/models/contato"), ->

        count = (query, callback) -> mongoose.model('Contato').count query, (err, count) -> callback count
        create = (data, callback) -> mongoose.model('Contato').create data, (err, profile) -> if not err then callback null, profile else callback err

        _sussurro_ = new SussurroConn()
        
        beforeEach ->
                _sussurro_.connect().then (db) ->
                        mongoose.connection.readyState.should.be.equal 1

        afterEach ->
                _sussurro_.disconnect().then (readyState) ->
                        readyState.should.be.equal 3
                                
        it 'should empty Contato', ->
                new Promise (resolve, reject) ->
                        Contato.find({}).remove().exec()
                        count {}, (c) ->
                                c.should.be.equal 0
                                resolve()
                                
        it "should create a Contato", ->
                new Promise (resolve, reject) ->
                        Contato.create contato_test, (err, contato) ->
                                Profile.findById firstProfile, '_id', (err, profile) ->
                                        if not err
                                                contato.profile = profile._id
                                                profile.contato = contato._id
                                                contato.save()
                                                profile.save()
                                                count {}, (c) ->
                                                        c.should.be.equal 1
                                                        resolve()

console.log chalk.yellow("==> Contato DB test loaded")
