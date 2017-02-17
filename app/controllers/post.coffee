posts = {}

### GET /api/posts ###
posts.index = (req, res) ->
        Post.find {}, 'updatedAt title text author', (err, posts) ->
                if not err
                        res.status 200
                        res.json posts
                else
                        res.status 404
                        res.json {err: err}
                        
                
### GET /api/post/:bid ###
posts.post = (req, res) ->
        if mongoose.Types.ObjectId.isValid(req.params.post_id)
                Post.findById mongoose.Types.ObjectId(req.params.post_id), (err, post) ->
                        if not err
                                res.status 200
                                res.json post
                        else
                                res.status 404
                                res.json {err: err}
        else
                res.json {err: "id #{req.params.post_id} isnt valid"}


### /api/post helper ###
posts.id = (req, res, next, id) ->
        req.params.post_id = id
        next()

console.log chalk.yellow("==> Post controller loaded")
