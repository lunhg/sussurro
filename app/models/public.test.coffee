describe chalk.green("app/models/public"), ->

        count = (query, callback) -> mongoose.model('Public').count query, (err, count) -> callback count
        create = (data, callback) -> mongoose.model('Public').create data, (err, _public) -> if not err then callback null, _public else callback err

        _sussurro_ = new SussurroConn()
        
        beforeEach ->
                _sussurro_.connect().then (db) ->
                        mongoose.connection.readyState.should.be.equal 1

        afterEach ->
                _sussurro_.disconnect().then (readyState) ->
                        readyState.should.be.equal 3
                                
        it 'should empty publics', ->
                new Promise (resolve, reject) ->
                        Public.find({}).remove().exec()
                        count {}, (c) ->
                                c.should.be.equal 0
                                resolve()
                                
        it "should create a public img path", ->
                new Promise (resolve, reject) ->
                        Profile.findOne {}, (err, profile) ->
                                create profile: profile._id, (err, _public) ->
                                        if not err
                                                _public.profile = profile._id
                                                _public.path = path.join __dirname, '..', 'app/assets/img'
                                                _public.name = 'img' 
                                                _public.save()
                                                count {}, (c) ->
                                                        c.should.be.equal 1
                                                        resolve()

        it "should create a public css path", ->
                new Promise (resolve, reject) ->
                        Profile.findOne {}, (err, profile) ->
                                create profile: profile._id, (err, _public) ->
                                        if not err
                                                _public.profile = profile._id
                                                _public.path = path.join __dirname, '..', 'app/assets/css'
                                                _public.name = 'css' 
                                                _public.save()
                                                count {}, (c) ->
                                                        c.should.be.equal 2
                                                        resolve()


        it "should create a public js path", ->
                new Promise (resolve, reject) ->
                        Profile.findOne {}, (err, profile) ->
                                create profile: profile._id, (err, _public) ->
                                        if not err
                                                _public.profile = profile._id
                                                _public.path = path.join __dirname, '..', 'app/assets/js'
                                                _public.name = 'js' 
                                                _public.save()
                                                count {}, (c) ->
                                                        c.should.be.equal 3
                                                        resolve()

        it "should create a public path", ->
                new Promise (resolve, reject) ->
                        Profile.findOne {}, (err, profile) ->
                                create profile: profile._id, (err, _public) ->
                                        if not err
                                                _public.profile = profile._id
                                                _public.path = path.join(__dirname, '..', 'app/assets/')
                                                _public.name = 'favicon' 
                                                _public.save()
                                                count {}, (c) ->
                                                        c.should.be.equal 4
                                                        resolve()

console.log chalk.yellow("==> Public DB test loaded")
