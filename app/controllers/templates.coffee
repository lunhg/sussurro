getTemplate = (p) ->
        new Promise (resolve, reject) ->
                _p = path.resolve "#{path.join(__dirname)}/../app/views/#{p}.pug"
                fs.readFile _p, 'utf8', (err, content) ->
                        if not err
                                try
                                        opt = {filename: _p, doctype:'html'}
                                        html = pug.compile(content, opt)()
                                        result = component: {template: html}, name: p, path: "/#{p}"
                                        resolve result
                                catch e
                                        console.log e
                                        reject e
                        else
                                reject err

                
app.get '/templates/routes/:type', (req, res) ->
        onSuccess = (result) -> res.json result
        onErr = (err) -> res.json err.message
        getTemplate(req.params['type']).then(onSuccess).catch(onErr)

app.get '/templates/index/routes', (req, res) ->
        res.json [
                "indice",
                "login",
                "signup",
                "resetPassword",
                "confirm",
                "conta",
                "audios"
                "postagens"
        ]
                
app.get "/templates/index/page", (req, res) ->
        p = path.join(__dirname, '..', 'app/views', 'vue.pug')
        fs.readFile p, 'utf8', (err, content) ->
                opt = {filename: p, doctype:'html'}
                html = pug.compile(content, opt)()
                res.send html

app.get "/templates/index/data", (req, res) ->
        res.json {
                autorizado:false
                user:
                        displayName:false
                        email:false
                        photoURL:false
                        telephone:false
                atualizar: {}
        }                        
