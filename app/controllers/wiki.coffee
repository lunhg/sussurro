wikis = {}

### GET /api/wikis ###
wikis.index = (req, res) ->
        Wiki.find {}, 'updatedAt name description posts', (err, wikis) ->
                if not err
                        res.status 200
                        res.json wikis
                else
                        res.status 404
                        res.json {err: err}
                        
                
### GET /api/wiki/:bid ###
wikis.wiki = (req, res) ->
        if mongoose.Types.ObjectId.isValid(req.params.wiki_id)
                Wiki.findById mongoose.Types.ObjectId(req.params.wiki_id), (err, wiki) ->
                        if not err
                                res.status 200
                                res.json wiki
                        else
                                res.status 404
                                res.json {err: err}
        else
                res.json {err: "id #{req.params.wiki_id} isnt valid"}


### /api/wiki helper ###
wikis.id = (req, res, next, id) ->
        req.params.wiki_id = id
        next()

console.log chalk.yellow("==> Wiki controller loaded")
