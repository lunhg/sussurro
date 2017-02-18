describe chalk.green("app/controllers/post"), ->

        it "should GET /api/posts", ->
                request(sussurro.app)
                        .get('/api/posts')
                        .expect(200)
                        .expect('Content-Type', /application\/json/)
                        .expect (res) ->
                                res.body.should.is.Array()
                                for post in res.body
                                        post.should.have.property 'updatedAt'
                                        post.should.have.property 'text'
                                        post.should.have.property 'title'
                                        post.should.have.property 'author'

        it "should GET /api/posts/:id", ->
                Post.find {}, '_id', (err, posts) ->
                        for post in posts
                                request(sussurro.app)
                                        .get('/api/posts/'+post._id)
                                        .expect(200)
                                        .expect('Content-Type', /application\/json/)
                                        .expect (res) ->
                                                post = res.body
                                                post.should.have.not.property 'err'
                                                post.should.have.property 'updatedAt'
                                                post.should.have.property 'text'
                                                post.should.have.property 'title'
                                                post.should.have.property 'author'
