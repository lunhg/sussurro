describe chalk.green("app/models/user"), ->

        count = (query, callback) -> mongoose.model('User').count query, (err, count) -> callback count
        create = (data, callback) -> mongoose.model('User').create data, (err, profile) -> if not err then callback null, profile else callback err

        _sussurro_ = new SussurroConn()
        
        beforeEach ->
                _sussurro_.connect().then (db) ->
                        mongoose.connection.readyState.should.be.equal 1

        afterEach ->
                _sussurro_.disconnect().then (readyState) ->
                        readyState.should.be.equal 3
                                
        it 'should empty Users', ->
                new Promise (resolve, reject) ->
                        User.find({}).remove().exec()
                        count {}, (c) ->
                                c.should.be.equal 0
                                resolve()
                                
        it "should create a simple User", ->
                new Promise (resolve, reject) ->
                        Profile.findOne {}, (err, profile) ->
                                create profile: profile._id, (err, user) ->
                                        if not err
                                                profile.user = user._id
                                                user.profile = profile._id
                                                profile.save()
                                                user.save()
                                                count {}, (c) ->
                                                        c.should.be.equal 1
                                                        resolve()
                                        else
                                                reject err

console.log chalk.yellow("==> User DB test loaded")
