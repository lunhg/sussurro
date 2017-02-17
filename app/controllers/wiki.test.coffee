describe chalk.green("app/controllers/wiki"), ->

        it "should GET /api/wikis", ->
                request(sussurro.app)
                        .get('/api/wikis')
                        .expect(200)
                        .expect('Content-Type', /application\/json/)
                        .expect (res) ->
                                res.body.should.is.Array()
                                for wiki in res.body
                                        wiki.should.have.property 'updatedAt'
                                        wiki.should.have.property 'description'
                                        wiki.should.have.property 'posts'
                                        
        it "should GET /api/wikis/:id", ->
                Wiki.find {}, '_id', (err, wikis) ->
                        for wiki in wikis
                                request(sussurro.app)
                                        .get('/api/wikis/'+wiki._id)
                                        .expect(200)
                                        .expect('Content-Type', /application\/json/)
                                        .expect (res) ->
                                                wiki = res.body
                                                wiki.should.have.not.property 'err'
                                                wiki.should.have.property 'updatedAt'
                                                wiki.should.have.property 'description'
                                                wiki.should.have.property 'posts'
