describe chalk.green("app/models/post"), ->

        count = (query, callback) -> mongoose.model('Post').count query, (err, count) -> callback count
        create = (data, callback) -> mongoose.model('Post').create data, (err, post) -> if not err then callback null, post else callback err

        _sussurro_ = new SussurroConn()
        
        beforeEach ->
                _sussurro_.connect().then (db) ->
                        mongoose.connection.readyState.should.be.equal 1

        afterEach ->
                _sussurro_.disconnect().then (readyState) ->
                        readyState.should.be.equal 3
                                
        it 'should empty Posts', ->
                new Promise (resolve, reject) ->
                        Post.find({}).remove().exec()
                        count {}, (c) ->
                                c.should.be.equal 0
                                resolve()
                                
        it "should create a post", ->
                new Promise (resolve, reject) ->
                        Wiki.findOne {}, (err, wiki) ->
                                Profile.findOne {}, (err2, profile) ->
                                        create post_test, (err, post) ->
                                                if not err
                                                        post.wiki = wiki._id
                                                        wiki.posts.push post._id
                                                        post.author = profile._id
                                                        profile.posts.push post._id
                                                       
                                                        post.save()
                                                        wiki.save()
                                                        profile.save()
                                                        count {}, (c) ->
                                                                c.should.be.equal 1
                                                                should(wiki.posts.length).is.equal 1
                                                                resolve()

        it "should create another post", ->
                new Promise (resolve, reject) ->
                        Wiki.findOne {}, (err, wiki) ->
                                Profile.findOne {}, (err2, profile) ->
                                        create post_test, (err, post) ->
                                                if not err
                                                        post.wiki = wiki._id
                                                        wiki.posts.push post._id
                                                        post.author = profile._id
                                                        profile.posts.push post._id
                                                       
                                                        post.save()
                                                        wiki.save()
                                                        profile.save()
                                                        count {}, (c) ->
                                                                c.should.be.equal 2
                                                                should(wiki.posts.length).is.equal 2
                                                                resolve()

        it "should create a third post", ->
                new Promise (resolve, reject) ->
                        Wiki.findOne {}, (err, wiki) ->
                                Profile.findOne {}, (err2, profile) ->
                                        create post_test, (err, post) ->
                                                if not err
                                                        post.wiki = wiki._id
                                                        wiki.posts.push post._id
                                                        post.author = profile._id
                                                        profile.posts.push post._id
                                                       
                                                        post.save()
                                                        wiki.save()
                                                        profile.save()
                                                        count {}, (c) ->
                                                                c.should.be.equal 3
                                                                should(wiki.posts.length).is.equal 3
                                                        resolve()

console.log chalk.yellow("==> Post DB test loaded")
