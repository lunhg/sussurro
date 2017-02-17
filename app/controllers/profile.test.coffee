describe chalk.green("app/controllers/profile"), ->

        id1 = "0"
        id2 = "0"

                                
        it 'should GET /api/profiles', ->
                request(sussurro.app)
                        .get('/api/profiles')
                        .expect('Content-Type', /json/)
                        .expect(200)
                        .expect (res) ->
                                res.body.should.is.Array()
                                for profile in res.body
                                        profile.should.have.property 'updatedAt'
                                        profile.should.have.property 'nome_artistico'
                                        profile.should.have.property 'nome_completo'
                                        profile.should.have.property 'posts'
                                id1 = res.body[0]._id
                                


        it "should POST /api/profiles/create with a form", ->
                request(sussurro.app)
                        .post("/api/profiles/create")
                        .query({nome_completo:uuid.v4()})
                        .query({nome_artistico:uuid.v4()})
                        .query({email:"gcravista@gmail.com"})
                        .query({telefone:"+5515998006760"})
                        .query({sites: "https://www.github.com/sussurro/sussurro||https://sussurro.github.io/"})
                        .query({redes_sociais:"https://www.facebook.com/sussuro"})
                        .query({nome_completo:uuid.v4()})
                        .query({nome_completo:uuid.v4()})
                        .query({bio: uuid.v4()})
                        .query({data_nascimento: Date.now()})
                        .query({data_falecimento: Date.now()}) # TODO
                        .query({local_de_nascimento:"país:Brasil||estado:SP||cidade:Sorocaba"})
                        .query({local_de_falecimento:"país:null||estado:null||cidade:null"})
                        .expect('Content-Type', 'application/json; charset=utf-8') 
                        .expect(201)
                        .expect (res) ->
                                m = res.body
                                m.should.have.property 'msg'
                                m.msg.should.be.equal "Email enviado para gcravista@gmail.com"

        it "should GET /api/profiles get two profiles", ->
                request(sussurro.app)
                        .get('/api/profiles')
                        .expect('Content-Type', /json/)
                        .expect(200)
                        .expect (res) ->
                                res.body.should.be.an.Array()
                                res.body.should.be.not.empty()
                                res.body.should.have.length 2
                                id2 = res.body[1]._id

        it "should GET /api/profiles/:id(first)", ->
                request(sussurro.app)
                        .get('/api/profiles/'+id1)
                        .expect('Content-Type', /json/)
                        .expect(200)
                        .expect (res) ->
                                profile = res.body
                                profile.should.not.have.property 'err'
                                profile.should.have.property 'updatedAt'
                                profile.should.have.property 'nome_artistico'
                                profile.should.have.property 'nome_completo'
                                profile.should.have.property 'posts'


        it "should GET /api/profile/:id(second)", ->
                request(sussurro.app)
                        .get('/api/profiles/'+id2)
                        .expect('Content-Type', /json/)
                        .expect(200)
                        .expect (res) ->
                                profile = res.body
                                profile.should.not.have.property 'err'
                                profile.should.have.property 'updatedAt'
                                profile.should.have.property 'nome_artistico'
                                profile.should.have.property 'nome_completo'
                                profile.should.have.property 'posts'

console.log chalk.yellow("==> Profile app test loaded")
