locals = {}

### GET /api/locals ###
locals.index = (req, res) ->
        Local.find {}, 'updatedAt cidade estado país', (err, locals) ->
                if not err
                        res.status 200
                        res.json locals
                else
                        res.status 404
                        res.json {err: err}
                        
                
### GET /api/local/:bid ###
locals.local = (req, res) ->
        if mongoose.Types.ObjectId.isValid(req.params.local_id)
                Local.findById mongoose.Types.ObjectId(req.params.local_id), (err, local) ->
                        if not err
                                res.status 200
                                res.json local
                        else
                                res.status 404
                                res.json {err: err}
        else
                res.json {err: "id #{req.params.local_id} isnt valid"}


### /api/local helper ###
locals.id = (req, res, next, id) ->
        req.params.local_id = id
        next()

console.log chalk.yellow("==> Local controller loaded")
