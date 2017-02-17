profiles = {}
                                       
### GET /api/profiles ###    
profiles.index = (req, res) ->
        allowed = 'id nome_completo nome_artistico posts updatedAt'
        Profile.find {}, allowed, (err, profiles) ->
                if (err or not err) and not profiles
                        res.status(404)
                        console.log chalk.red err
                        res.json error: err
                else
                        if profiles
                                res.status(200)
                                res.json profiles
                        else
                                res.status 404
                                res.json {error: "profiles is a #{typeof(profiles)}"}

### POST /api/profiles/new ###
profiles.create = (req, res) ->
        profile = new Profile
                nome_completo: req.query.nome_completo
                nome_artistico:req.query.nome_artistico
        profile.save()

        contato = new Contato
                email:req.query.email
                telefone: req.query.telefone
                sites: req.query.sites.split("||")
                redes_sociais: req.query.redes_sociais.split("||")
                profile: profile._id
                
        contato.profile = profile._id
        contato.save()
        profile.contato = contato._id
        profile.save()

        bio = new Bio profile: profile._id, text: req.query.bio
        bio.save()
        
        for local in 'nascimento falecimento'.split(' ')
                if req.query['local_de_'+local]
                        _local = new Local()
                        _local.tipo = local
                        for v in req.query['local_de_'+local].split("||")
                                kv = v.split(":")
                                _local[kv[0]] = kv[1] 
                        _local.save()
                        _local.bio = bio._id
                        bio['local_de_'+local] = _local._id
                if req.query['data_de_'+local]
                        console.log local
                        bio['data_de_'+local] = req.query['data_de_'+local]
                        bio.save()

        user = new User
                profile: profile._id
        user.save()
        res.status 201
        res.json {msg:"Email enviado para #{contato.email}"}



### GET /api/profile/:id ###
profiles.profile = (req, res) ->
        query = mongoose.Schema.Types.ObjectId req.params.id
        Profile.findOne query, 'nome_completo nome_artistico posts updatedAt', (err, profile) ->
                if not err
                        res.status 200
                        res.json profile
                else
                        res.json {err: err, status: 404}

### Some helper ###
profiles.id = (req, res, next, id) ->
        req.params.id = id
        next()

console.log chalk.yellow("==> Profile controller loaded")
