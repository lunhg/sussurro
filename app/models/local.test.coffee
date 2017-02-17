describe chalk.green("app/models/local"), ->

        count = (query, callback) -> mongoose.model('Local').count query, (err, count) -> callback count
        create = (data, callback) -> mongoose.model('Local').create data, (err, profile) -> if not err then callback null, profile else callback err

        _sussurro_ = new SussurroConn()
        
        beforeEach ->
                _sussurro_.connect().then (db) ->
                        mongoose.connection.readyState.should.be.equal 1

        afterEach ->
                _sussurro_.disconnect().then (readyState) ->
                        readyState.should.be.equal 3
                                
        it 'should empty Locals', ->
                new Promise (resolve, reject) ->
                        Local.find({}).remove().exec()
                        count {}, (c) ->
                                c.should.be.equal 0
                                resolve()
                                
        it "should create a nascimento Local", ->
                new Promise (resolve, reject) ->
                        Bio.findOne {}, (err, bio) ->
                                
                                create locals_test.nascimento, (err, local) ->
                                        local.bio = bio._id
                                        bio.local_de_nascimento = local._id
                                        local.tipo = 'nascimento'
                                        local.save()
                                        bio.save()
                                        count {}, (c) ->
                                                c.should.be.equal 1
                                                resolve()

        it "should create a falecimento Local", ->
                new Promise (resolve, reject) ->
                        Bio.findOne {}, (err, bio) ->
                                locals_test.falecimento.bio = bio._id
                                create locals_test.falecimento, (err, local) ->
                                        local.bio = bio._id
                                        bio.local_de_falecimento = local._id
                                        local.tipo = 'falecimento'
                                        local.save()
                                        bio.save()
                                        count {}, (c) ->
                                                c.should.be.equal 2
                                                resolve()

console.log chalk.yellow("==> Local DB test loaded")
