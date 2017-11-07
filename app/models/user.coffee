############
# User Model
############
UserSchema = new mongoose.Schema
        username: String
        email: String
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
