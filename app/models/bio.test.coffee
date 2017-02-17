describe chalk.green("app/models/bio"), ->

        count = (query, callback) -> mongoose.model('Bio').count query, (err, count) -> callback count
        create = (data, callback) -> mongoose.model('Bio').create data, (err, profile) -> if not err then callback null, profile else callback err

        _sussurro_ = new SussurroConn()
        
        beforeEach ->
                _sussurro_.connect().then (db) ->
                        mongoose.connection.readyState.should.be.equal 1

        afterEach ->
                _sussurro_.disconnect().then (readyState) ->
                        readyState.should.be.equal 3
                                
        it 'should empty Bios', ->
                new Promise (resolve, reject) ->
                        Bio.find({}).remove().exec()
                        count {}, (c) ->
                                c.should.be.equal 0
                                resolve()
                                        
        it "should create a simple Bio", ->
                new Promise (resolve, reject) ->
                        Profile.findOne {}, (err, profile) ->
                                Bio.create bio_test, (err, bio) ->
                                        if not err
                                                bio.profile = profile._id
                                                profile.bio = bio._id
                                                bio.save()
                                                profile.save()
                                                count {}, (c) ->
                                                        c.should.be.equal 1
                                                        resolve()

                                        else
                                                reject err

console.log chalk.yellow("==> Bio test loaded")
