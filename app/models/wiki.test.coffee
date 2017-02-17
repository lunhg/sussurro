describe chalk.green("app/models/wiki"), ->

        count = (query, callback) -> mongoose.model('Wiki').count query, (err, count) -> callback count
        create = (data, callback) -> mongoose.model('Wiki').create data, (err, wiki) -> if not err then callback null, wiki else callback err

        _sussurro_ = new SussurroConn()
        
        beforeEach ->
                _sussurro_.connect().then (db) ->
                        mongoose.connection.readyState.should.be.equal 1

        afterEach ->
                _sussurro_.disconnect().then (readyState) ->
                        readyState.should.be.equal 3
                                
        it 'should empty Wikis', ->
                new Promise (resolve, reject) ->
                        Wiki.find({}).remove().exec()
                        count {}, (c) ->
                                c.should.be.equal 0
                                resolve()
                                
        it "should create a Wiki", ->
                new Promise (resolve, reject) ->
                        create wiki_test, (err, wiki) ->
                                if not err then wiki.save()
                                count {}, (c) ->
                                        c.should.be.equal 1
                                        resolve()
console.log chalk.yellow("==> Wiki DB test loaded")
