# Initialize Passport!  Also use passport.session() middleware, to support
# persistent login sessions (recommended)
app.use(passport.initialize())
app.use(passport.session())
