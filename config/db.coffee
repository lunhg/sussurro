mongoose.connect("mongodb://#{process.env.MONGODB_URL}")
        .then(->
                console.log chalk.cyan "connected to MongoDB"
                configure = new Configure(app)
                configure.connect()
                configure.use()
        )
        .catch((err) -> console.log chalk.red err) 
