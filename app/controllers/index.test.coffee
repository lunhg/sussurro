describe chalk.green("app/controllers/index"), ->

        it 'should welcome GET /api', ->
                request(sussurro.app).get('/api').expect(200).expect (res) ->
                        res.body.should.have.property('flash').which.is.equal false
                        res.body.should.have.property('msg', '')
                        res.body.should.have.property('nav')
                        res.body.nav.should.have.property('post')
                        res.body.nav.post.should.have.property('title')
                        res.body.nav.post.should.have.property('text')
                        res.body.nav.post.should.have.property('updatedAt')
                        res.body.nav.should.have.property('wiki')
                        res.body.nav.wiki.should.have.property('name')
                        res.body.nav.wiki.should.have.property('description')
                        res.body.nav.wiki.should.have.property('wikis')
                        res.body.nav.wiki.should.have.property('posts')
                                

        it 'should not welcome GET /api?msg=testing', ->
                request(sussurro.app).get('/api?msg=testing').expect(200).expect (res) ->
                        res.body.should.have.property('flash').which.is.equal false
                        res.body.should.have.property('msg').which.is.equal ''


        it 'should welcome GET /api?msg=contato', ->
                request(sussurro.app).get('/api?msg=contato').expect(200).expect (res) ->
                        res.body.should.have.property('flash').which.is.equal true
                        res.body.should.have.property('msg', 'Mensagem enviada.')

        it 'should welcome GET /api?msg=cadastro', ->
                request(sussurro.app).get('/api?msg=cadastro').expect(200).expect (res) ->
                        res.body.should.have.property('flash').which.is.equal true
                        res.body.should.have.property('msg', 'Cadastro feito. Verifique seu email.')

console.log chalk.yellow("==> Index app test loaded")
