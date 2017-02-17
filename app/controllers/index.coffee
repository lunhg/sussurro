### Initialize a index router ###
index = {}
index.makeJSON = (req, wiki, post) ->
        json = 
                flash: false
                msg: ''
                nav:
                        post:
                                title: post.title
                                text:  post.text
                                updatedAt: post.updatedAt or post.createdAt
                                authors: post.authors
                        wiki:
                                name: wiki.name
                                description: wiki.description
                                ref : wiki.ref
                        wikis: []
                        posts: []
         if req.query.msg
                if req.query.msg is 'contato'
                        json.msg = "Mensagem enviada."
                        json.flash = true
                else if req.query.msg is 'cadastro'
                        if req.query.type is 'notallowed'
                                json.msg = "Usuário já existe"
                                json.flash = true
                        else
                                json.msg = "Cadastro feito. Verifique seu email."
                                json.flash = true
        json
        

### simulate a export to call them in boot/routes.coffee ###
index.welcome = (req, res) ->
        Wiki.find, 'title description author', (err, wikis) ->
                if err
                        res.json {error: err}
                else
                        Post.findOne {wiki: wiki._id}, (err, post) =>
                                if err
                                        res.json {error: err} 
                                else
                                        json = index.makeJSON(req, wiki, post)
                                        console.log json
                                        res.json json

console.log chalk.yellow("==> Index helpers loaded")
