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
        isActive: Boolean
        password: String
        roles:
                admin: mongoose.Schema.Types.ObjectId
        bio: String
        img: String
        wiki:
                posts: [{type: mongoose.Schema.Types.ObjectId, ref: 'Post'}]
                compositions: [{type: mongoose.Schema.Types.ObjectId, ref: 'Composition'}]

UserSchema.plugin mongoose_timestamp

UserSchema.methods.setPassword = (pass) ->
        this.password = pass
        this.save()
                   
UserSchema.methods.addBio = (bio) ->
        this.info.bio = bio
        this.save()

UserSchema.methods.addPost = (text) ->
        this.posts.push new Post(text: text)
        if callback then this.save(callback) else this.save()

UserSchema.methods.addComposition = (o) ->
        this.compostion.push new Composition(o)
        if callback then this.save(callback) else this.save()

mongoose.model 'User', UserSchema
User = mongoose.model 'User'
console.log chalk.yellow "==> #{User.modelName} schema loaded"
