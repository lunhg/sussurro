firstProfile = null
describe chalk.green("app/models/profile"), ->
        
        count = (query, callback) -> mongoose.model('Profile').count query, (err, count) -> callback count
        create = (data, callback) -> mongoose.model('Profile').create data, (err, profile) -> if not err then callback null, profile else callback err

        _sussurro_ = new SussurroConn()
                
        beforeEach ->
                _sussurro_.connect().then (db) ->
                        mongoose.connection.readyState.should.be.equal 1

        afterEach ->
                _sussurro_.disconnect().then (readyState) ->
                        readyState.should.be.equal 3
                                                        
        it 'should empty Profiles', ->
                new Promise (resolve, reject) ->
                        Profile.findOne({}).remove().exec()
                        count {}, (c) ->
                                c.should.be.equal 0
                                resolve()
                                
        it "should create a simple Profile", ->
                 new Promise (resolve, reject) ->
                        create profile_test, (err, profile) ->
                                profile.save()
                                profile.should.have.property 'nome_completo'
                                profile.should.have.property 'nome_artistico'
                                firstProfile = profile._id
                                count {}, (c) ->
                                        c.should.be.equal 1
                                        resolve()

console.log chalk.yellow("==> Profile DB test loaded")
