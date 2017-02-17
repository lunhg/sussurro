### The request will be redirected to SoundCloud for authentication, so this function will not be called. ###
GET '/auth/soundcloud', passport.authenticate 'soundcloud', (req, res) ->

### callback for GET /login/soundcloud ###
GET '/auth/soundcloud/callback', passport.authenticate('soundcloud', { failureRedirect: '/login' }), (req, res) ->
        console.log res.body
        res.redirect('/users/#{req.user.id}')
                
### GET /login ###
GET '/login', (req, res) ->
        res.render 'login',
                form: [
                        {name:'email', placeholder:'vc@email'},
                        {name:'subject', placeholder:'subject'}
                ]

### GET /login/soundcloud ###
GET '/login/soundcloud', (req, res) ->
        res.redirect '/auth/soundcloud'

### POST /login ###
POST '/login', (req, res) ->
         passport.authenticate 'local',
                successRedirect: '/user/:id',
                failureRedirect: '/login',
                failureFlash: true

### GET /logout ###
GET '/logout', (req, res) ->
        req.logout()
        res.redirect('/')
