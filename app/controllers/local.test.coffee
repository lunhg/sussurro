describe chalk.green("app/controllers/local"), ->

        it "should GET /api/locals", ->
                request(sussurro.app)
                        .get('/api/locals')
                        .expect(200)
                        .expect('Content-Type', /application\/json/)
                        .expect (res) ->
                                res.body.should.is.Array()
                                for local in res.body
                                        local.should.have.not.property 'err'
                                        local.should.have.property 'cidade'
                                        local.should.have.property 'estado'
                                        local.should.have.property 'país'
                                        local.should.have.property 'updatedAt'

        it "should GET /api/locals/:id", ->
                Local.find {}, '_id', (err, locals) ->
                        for local in locals
                                request(sussurro.app)
                                        .get('/api/locals/'+local._id)
                                        .expect(200)
                                        .expect('Content-Type', /application\/json/)
                                        .expect (res) ->
                                                local = res.body
                                                local.should.have.not.property 'err'
                                                local.should.have.property 'cidade'
                                                local.should.have.property 'estado'
                                                local.should.have.property 'país'
                                                local.should.have.property 'updatedAt'

console.log chalk.yellow("==> Local app test loaded")
