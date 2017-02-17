users = {}

### POST /api/users/auth ###
profiles.auth = (req, res) ->
        query = mongoose.Schema.Types.ObjectId req.params.id
        User.findOne {profile: query}, (err, user) ->
                if not err
                        if user.authenticate req.body.password
                                Profile.findById user.profile, (err, profile) ->
                                        if not err
                                                res.status 200
                                                res.json {id: profile._id}
                                        else
                                                res.status 404
                                                res.json {err: err}
                        else
                                res.status 403
                                res.json {err: "Login or password incorrect"}
                else
                        res.status 404
                        res.json {err: err}
