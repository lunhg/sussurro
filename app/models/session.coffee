SessionSchema = new mongoose.Schema
        pass: String
        salt: String
        profile:
                type: mongoose.Schema.Types.ObjectId
                ref:  'Profile'
        
SessionSchema.plugin timestamps
SessionSchema.pre 'save', (next) ->
        if not @pass 
                @pass = uuid.v4()
        if @pass.length > 6
                @salt = new Buffer(crypto.randomBytes(16).toString('base64'), 'base64')
                @pass = crypto.pbkdf2Sync(@pass, @salt, 10000, 64).toString('base64')
        next()
        
mongoose.model 'Session', SessionSchema
Session = mongoose.model 'Session'
console.log chalk.yellow "==> #{Session.modelName} schema loaded"
