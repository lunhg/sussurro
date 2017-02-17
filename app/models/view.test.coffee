describe chalk.green("app/models/view"), ->

        count = (query, callback) -> mongoose.model('View').count query, (err, count) -> callback count
        create = (data, callback) -> mongoose.model('View').create data, (err, profile) -> if not err then callback null, profile else callback err

        _sussurro_ = new SussurroConn()
        
        beforeEach ->
                _sussurro_.connect().then (db) ->
                        mongoose.connection.readyState.should.be.equal 1

        afterEach ->
                _sussurro_.disconnect().then (readyState) ->
                        readyState.should.be.equal 3
                                
        it 'should empty views', ->
                new Promise (resolve, reject) ->
                        View.find({}).remove().exec()
                        count {}, (c) ->
                                c.should.be.equal 0
                                resolve()
                                
        it "should create a simple view", ->
                new Promise (resolve, reject) ->
                        Profile.findOne {}, (err, profile) ->
                                create profile: profile._id, (err, view) ->
                                        if not err
                                                view.profile = profile._id
                                                view.path = path.join(__dirname, '..', 'app/views/')
                                                view.engine = 'pug'
                                                view.save()
                                                count {}, (c) ->
                                                        c.should.be.equal 1
                                                        resolve()
console.log chalk.yellow("==> View DB test loaded")
