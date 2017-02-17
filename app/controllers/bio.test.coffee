describe chalk.green("app/controllers/bio"), ->

        it "should GET /api/bios", ->
                request(sussurro.app)
                        .get('/api/bios')
                        .expect(200)
                        .expect('Content-Type', /application\/json/)
                        .expect (res) ->
                                res.body.should.is.Array()
                                for bio in res.body
                                        bio.should.have.property 'updatedAt'
                                        bio.should.have.property 'text'
                                        bio.should.have.property 'local_de_nascimento'
                                        bio.should.have.property 'local_de_falecimento'
                                        bio.should.have.property 'data_de_falecimento'
                                        bio.should.have.property 'data_de_falecimento'

        it "should GET /api/bios/:id", ->
                Bio.find {}, '_id', (err, bios) ->
                        for bio in bios
                                request(sussurro.app)
                                        .get('/api/bios/'+bio._id)
                                        .expect(200)
                                        .expect('Content-Type', /application\/json/)
                                        .expect (res) ->
                                                bio = res.body
                                                bio.should.have.not.property 'err'
                                                bio.should.have.property 'text'
                                                bio.should.have.property 'local_de_nascimento'
                                                bio.should.have.property 'local_de_falecimento'
                                                bio.should.have.property 'data_de_falecimento'
                                                bio.should.have.property 'data_de_falecimento'

console.log chalk.yellow("==> Bio app test loaded")
