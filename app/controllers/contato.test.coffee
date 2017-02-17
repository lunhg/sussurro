describe chalk.green("app/controllers/contato"), ->

        it "should GET /api/contatos", ->
                request(sussurro.app)
                        .get('/api/contatos')
                        .expect(200)
                        .expect('Content-Type', /application\/json/)
                        .expect (res) ->
                                res.body.should.is.Array()
                                for contato in res.body
                                        contato.should.have.property 'updatedAt'
                                        contato.should.have.property 'email'
                                        contato.should.have.property 'sites'
                                        contato.should.have.property 'redes_sociais'

        it "should GET /api/contatos/:id", ->
                Contato.find {}, '_id', (err, contatos) ->
                        for contato in contatos
                                request(sussurro.app)
                                        .get('/api/contato/'+contato._id)
                                        .expect(200)
                                        .expect('Content-Type', /application\/json/)
                                        .expect (res) ->
                                                contato = res.body
                                                contato.should.have.not.property 'err'
                                                contato.should.have.property 'updatedAt'
                                                contato.should.have.property 'email'
                                                contato.should.have.property 'sites'
                                                contato.should.have.property 'redes_sociais'

console.log chalk.yellow("==> Contato app test loaded")
