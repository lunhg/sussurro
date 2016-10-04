# The request will be redirected to SoundCloud for authentication, so this function will not be called.
app.get '/auth/soundcloud', passport.authenticate 'soundcloud', (req, res) ->

#callback for GET /login
app.get '/auth/soundcloud/callback', passport.authenticate('soundcloud', { failureRedirect: '/login' }), (req, res) ->
        console.log res.body
        res.redirect('/users/#{req.user.id}')
                
# GET /login
app.get '/login', (req, res) -> res.render 'login', form: [{name:'email', placeholder:'vc@email'}, {name:'subject', placeholder:'subject'}]

app.get '/login/soundcloud', (req, res) -> res.redirect '/auth/soundcloud'

# POST /login
app.post '/login', (req, res) ->
         passport.authenticate 'local',
                successRedirect: '/user/:id',
                failureRedirect: '/login',
                failureFlash: true

# GET /logout
app.get '/logout', (req, res) ->
        req.logout()
        res.redirect('/')
