### User Model: http://stackoverflow.com/questions/30416170/how-to-perform-a-mongoose-validate-function-only-for-create-user-page-and-not-edA Validation function for local strategy properties ###
validateLocalStrategyPassword = (password) -> (@provider isnt 'local' or (password and password.length > 6))

UserSchema = new mongoose.Schema
        profile:
                type: mongoose.Schema.Types.ObjectId
                ref:  'Profile'
        password: 
                type: String
                validate: [validateLocalStrategyPassword, 'Password should be longer']
        salt: String
        isActive: Boolean
        token: String
        mailSent: Boolean
        
UserSchema.plugin timestamps

UserSchema.pre 'save', (next) ->
        if not @password 
                @password = uuid.v4()
        if @password.length > 6
                @salt = new Buffer(crypto.randomBytes(16).toString('base64'), 'base64')
                @password = @hashPassword @password
                @token = uuid.v4()
                @isActive = false
                @mailSent = false   
        next()

UserSchema.methods.hashPassword = (password) -> if @salt and password then crypto.pbkdf2Sync(password, @salt, 10000, 64).toString('base64') else password

UserSchema.methods.authenticate = (password) -> @password is @hashPassword password


UserSchema.methods.sendMail = (mail, callback) ->
        console.log "===> sending email to #{mail.to}..."
        mail.from = MAILBOT
        mailer.sendMail mail, (err, info) =>
                if err
                        console.log chalk.red err
                else
                        @mailSent = true
                        console.log chalk.yellow info

mongoose.model 'User', UserSchema
User = mongoose.model 'User'
console.log chalk.yellow "==> #{User.modelName} schema loaded"
