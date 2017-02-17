bios = {}

### GET /api/bios ###
bios.index = (req, res) ->
        Bio.find {}, req.fields, (err, bios) ->
                if not err
                        res.status 200
                        res.json bios
                else
                        res.status 404
                        res.json {err: err}
                        
                
### GET /api/bio/:bid ###
bios.bio = (req, res) ->
        if mongoose.Types.ObjectId.isValid(req.params.bio_id)
                Bio.findById mongoose.Types.ObjectId(req.params.bio_id), (err, bio) ->
                        if not err
                                res.status 200
                                res.json bio
                        else
                                res.status 404
                                res.json {err: err}
        else
                res.json {err: "id #{req.params.bio_id} isnt valid"}


### /api/bio helper ###
bios.id = (req, res, next, id) ->
        req.params.bio_id = id
        req.fields = 'updatedAt text local_de_nascimento local_de_falecimento data_de_nascimento data_de_falecimento'
        next()
        
console.log chalk.yellow("==> Bio controller loaded")
