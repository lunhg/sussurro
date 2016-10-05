SOUNDCLOUD_OPTIONS =
    clientID:  "--insert-soundcloud-client-id-here--"
    clientSecret:  "--insert-soundcloud-client-secret-here--"
    callbackURL: "http://127.0.0.1:3000/auth/soundcloud/callback"

SOUNDCLOUD_STRATEGY = (accessToken, refreshToken, profile, done) ->
        # asynchronous verification, for effect...
        process.nextTick ->
      
        # To keep the example simple, the user's SoundCloud profile is returned
        # to represent the logged-in user.  In a typical application, you would
        # want to associate the SoundCloud account with a user record in your
        # database, and return that user instead.
        done(null, profile)
