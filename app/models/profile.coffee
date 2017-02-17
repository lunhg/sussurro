### Profile Model ###
ProfileSchema = new mongoose.Schema
        nome_completo: {type:String, required:true}
        nome_artistico: {type:String, required:true}
        bio: {type: mongoose.Schema.Types.ObjectId, ref: 'Bio'}
        contato: {type: mongoose.Schema.Types.ObjectId, ref: 'Contato'}
        user: {type: mongoose.Schema.Types.ObjectId, ref: 'User'}
        posts: [{type: mongoose.Schema.Types.ObjectId, ref: 'Post'}]

ProfileSchema.plugin timestamps

ProfileSchema.methods.hasUser = (data)->
        user = new User data
        user.save()
        stringer = (p) ->
                readMsg = fs.readFileSync(p)
                readMsg = readMsg.replace(/\{\{nome}\}/, @nome_completo)
                readMsg = readMsg.replace(/\{\{_id}\}/, @_id)
                readMsg = readMsg.replace(/\{\{token}\}/, user.token)
                readMsg
                
        Contato.findOne {profile: @profile._id}, (err, contato) =>
                if not err
                        p = path.join(__dirname, '..', 'mailers/default.html')
                        user.sendMail {to: contato.email, msg: stringer(p)}
                        callback null, user._id
                else
                        callback err
                        
mongoose.model 'Profile', ProfileSchema
Profile = mongoose.model 'Profile'
console.log chalk.yellow "==> #{Profile.modelName} schema loaded"
