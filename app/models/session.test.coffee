describe chalk.green("app/models/session"), ->

        count = (query, callback) -> mongoose.model('Session').count query, (err, count) -> callback count
        create = (data, callback) -> mongoose.model('Session').create data, (err, session) -> if not err then callback null, session else callback err

        _sussurro_ = new SussurroConn()
        
        beforeEach ->
                _sussurro_.connect().then (db) ->
                        mongoose.connection.readyState.should.be.equal 1

        afterEach ->
                _sussurro_.disconnect().then (readyState) ->
                        readyState.should.be.equal 3
                                
        it 'should empty Sessions', ->
                new Promise (resolve, reject) ->
                        Session.find().remove().exec()
                        count {}, (c) ->
                                c.should.be.equal 0
                                resolve()
                                
        it "should create a simple Session", ->
                new Promise (resolve, reject) ->
                        Profile.findOne {}, (err, profile) ->
                                create profile: profile._id, (err, session) ->
                                        if not err
                                                session.profile = profile._id
                                                session.save()
                                                count {}, (c) ->
                                                        c.should.be.equal 1
                                                        resolve()
                                        else
                                                reject err
