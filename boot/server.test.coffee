describe chalk.green("Sussurro server"), ->

        it 'should GET http://localhost:3000/', ->
                request("http://localhost:3000").get('/').expect(200).expect (res) ->
                        res.body.should.have.property 'flash', false
                        res.body.should.have.property 'msg', ''
                        res.body.should.have.property 'wikis'
                        res.body.wikis.should.be.Array()
                        for wiki in res.body.wikis
                                wiki.should.have.property 'name'
                                wiki.should.have.property 'description'
                                wiki.should.have.property 'posts'
                                wiki.posts.should.be.Array()
                        
        it 'should GET http://localhost:3000/api/profiles', ->
                request("http://localhost:3000")
                        .get('/api/profiles')
                        .expect('Content-Type', /json/)
                        .expect(200)
                        .expect (res) ->
                                res.body.should.is.Array()
                                res.body.should.have.length 2
                                for profile in res.body
                                        profile.should.have.property 'updatedAt'
                                        profile.should.have.property 'nome_artistico'
                                        profile.should.have.property 'nome_completo'
                                        profile.should.have.property 'posts'
                                


        it "should POST http://localhost:3000/api/profiles/create with a form", ->
                request("http://localhost:3000")
                        .post("/api/profiles/create")
                        .query({nome_completo:"Guilherme Martins Lunhani"})
                        .query({nome_artistico:"Cravista"})
                        .query({email:"lunhg@gmail.com"})
                        .query({telefone:"+5515998006760"})
                        .query({sites: "https://www.github.com/sussurro/sussurro||https://sussurro.github.io/"})
                        .query({redes_sociais:"https://www.facebook.com/sussuro"})
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
                                m.msg.should.be.equal "Email enviado para lunhg@gmail.com"

        it "should GET http://localhost:3000/api/profiles get three profiles", ->
                request("http://localhost:3000")
                        .get('/api/profiles')
                        .expect('Content-Type', /json/)
                        .expect(200)
                        .expect (res) ->
                                res.body.should.be.an.Array()
                                res.body.should.be.not.empty()
                                res.body.should.have.length 3


        it "should GET all http://localhost:3000/api/profiles/:id", ->
                mongoose.model('Profile').find {}, (err, profiles) ->
                        each profiles, (profile, i, p) ->
                                request("http://localhost:3000")
                                        .get('/api/profiles/'+profile._id)
                                        .expect('Content-Type', /json/)
                                        .expect(200)
                                        .expect (res) ->
                                                profile = res.body
                                                profile.should.not.have.property 'err'
                                                profile.should.have.property 'updatedAt'
                                                profile.should.have.property 'nome_artistico'
                                                profile.should.have.property 'nome_completo'
                                                profile.should.have.property 'posts'

        it 'should GET http://localhost:3000/api/contatos get three contatos', ->
                request("http://localhost:3000")
                        .get('/api/contatos')
                        .expect('Content-Type', /json/)
                        .expect(200)
                        .expect (res) ->
                                res.body.should.is.Array()
                                res.body.should.have.length 3
                                for contato in res.body
                                        contato.should.have.property 'email'
                                        contato.should.have.property 'sites'
                                        contato.should.have.property 'redes_sociais'
                                        contato.should.have.property 'telefone'
                                

        it "should GET all http://localhost:3000/api/contatos/:id", ->
                mongoose.model('Contato').find {}, (err, contatos) ->
                        each contatos, (contato, i, p) ->
                                request("http://localhost:3000")
                                        .get('/api/contatos/'+contato._id)
                                        .expect('Content-Type', /json/)
                                        .expect(200)
                                        .expect (res) ->
                                                res.body.should.have.property 'email'
                                                res.body.should.have.property 'sites'
                                                res.body.should.have.property 'redes_sociais'
                                                res.body.should.have.property 'telefone'
        
        it 'should GET http://localhost:3000/api/bios get three bios', ->
                request("http://localhost:3000")
                        .get('/api/bios')
                        .expect('Content-Type', /json/)
                        .expect(200)
                        .expect (res) ->
                                res.body.should.is.Array()
                                res.body.should.have.length 3
                                for bio in res.body
                                        res.body.should.have.property 'data_de_nascimento'
                                        res.body.should.have.property 'data_de_falecimento'
                                        res.body.should.have.property 'text'
                                        res.body.should.have.property 'local_de_nascimento'
                                        res.body.should.have.property 'local_de_falecimento'
                                

        it "should GET all http://localhost:3000/api/bios/:id", ->
                mongoose.model('Bio').find {}, (err, bios) ->
                        each bios, (bio, i, p) ->
                                request("http://localhost:3000")
                                        .get('/api/bios/'+bio._id)
                                        .expect('Content-Type', /json/)
                                        .expect(200)
                                        .expect (res) ->
                                                res.body.should.have.property 'data_de_nascimento'
                                                res.body.should.have.property 'data_de_falecimento'
                                                res.body.should.have.property 'text'
                                                res.body.should.have.property 'local_de_nascimento'
                                                res.body.should.have.property 'local_de_falecimento'


         it 'should GET http://localhost:3000/api/locals get six locals', ->
                request("http://localhost:3000")
                        .get('/api/locals')
                        .expect('Content-Type', /json/)
                        .expect(200)
                        .expect (res) ->
                                res.body.should.is.Array()
                                res.body.should.have.length 6
                                for local in res.body
                                        local.should.have.property 'cidade'
                                        local.should.have.property 'estado'
                                        local.should.have.property 'país'

                                

        it "should GET all http://localhost:3000/api/locals/:id", ->
                mongoose.model('Local').find {}, (err, locals) ->
                        each locals, (local, i, p) ->
                                request("http://localhost:3000")
                                        .get('/api/locals/'+local._id)
                                        .expect('Content-Type', /json/)
                                        .expect(200)
                                        .expect (res) ->
                                                res.body.should.have.property 'cidade'
                                                res.body.should.have.property 'estado'
                                                res.body.should.have.property 'país'

        it 'should GET http://localhost:3000/api/wikis get one wiki', ->
                request("http://localhost:3000")
                        .get('/api/wikis')
                        .expect('Content-Type', /json/)
                        .expect(200)
                        .expect (res) ->
                                res.body.should.is.Array()
                                res.body.should.have.length 1
                                for wiki in res.body
                                        wiki.should.have.property 'description'
                                        wiki.should.have.property 'name'
                                        wiki.should.have.property('posts').which.have.length 3
                                        

                                

        it "should GET all http://localhost:3000/api/wikis/:id", ->
                mongoose.model('Wiki').find {}, (err, wikis) ->
                        each wikis, (wiki, i, p) ->
                                request("http://localhost:3000")
                                        .get('/api/wikis/'+wiki._id)
                                        .expect('Content-Type', /json/)
                                        .expect(200)
                                        .expect (res) ->
                                                wiki.should.have.property 'description'
                                                wiki.should.have.property 'name'
                                                wiki.should.have.property('posts').which.have.length 3


        it 'should GET http://localhost:3000/api/posts get three posts', ->
                request("http://localhost:3000")
                        .get('/api/posts')
                        .expect('Content-Type', /json/)
                        .expect(200)
                        .expect (res) ->
                                res.body.should.is.Array()
                                res.body.should.have.length 3
                                for post in res.body
                                        post.should.have.property 'text'
                                        
        it "should GET all http://localhost:3000/api/posts/:id", ->
                mongoose.model('Post').find {}, (err, posts) ->
                        each posts, (post, i, p) ->
                                request("http://localhost:3000")
                                        .get('/api/posts/'+post._id)
                                        .expect('Content-Type', /json/)
                                        .expect(200)
                                        .expect (res) ->
                                                post.should.have.property 'text'
                                                                                                
console.log chalk.yellow("==> Sussurro server test loaded")
