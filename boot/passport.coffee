# Initialize Passport!  Also use passport.session() middleware, to support
# persistent login sessions (recommended)
app.use(passport.initialize())
app.use(passport.session())

passport.serializeUser (user, done) ->

passport.deserializeUser (obj, done) ->
        User.findOne id: id, (err, user) ->
                done(err, user)

passport.use new SoundCloudStrategy SOUNDCLOUD_OPTIONS, SOUNDCLOUD_STRATEGY

passport.use new LocalStrategy (username, password, done) ->
        User.findOne name: username, password: password, (err, user) ->
                if not user then done(null, false, { message: 'Incorrect username.' });
                if not user.validPassword(password) then done(null, false, { message: 'Incorrect password.' })
                done(null, user) 

