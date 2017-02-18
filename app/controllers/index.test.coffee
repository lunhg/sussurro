describe chalk.green("app/controllers/index"), ->

        it 'should welcome GET /', ->
                request(sussurro.app)
                        .get('/')
                        .expect(200)
                        .expect('Content-Type', /json/)
                        .expect (res) ->
                                res.body.should.have.property('flash').which.is.equal false
                                res.body.should.have.property('msg', '')
                                res.body.should.have.property('wikis')
                                res.body.wikis.should.be.Array()
                                for wiki in res.body.wikis
                                        wiki.should.have.property 'posts'
                                        wiki.posts.should.be.Array()
                                

        it "Disconnect from mongodb", ->
                sussurro.connection.disconnect().then (readyState)->
                        readyState.should.be.equal 3

console.log chalk.yellow("==> Index app test loaded")
