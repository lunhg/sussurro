### Admin model ###
AdminSchema = mongoose.model 'Admin',
        user: {type: mongoose.Schema.Types.ObjectId, ref: 'User'}
        pwd: String

AdminSchema.plugin timestamps           
AdminSchema.statics.createOne = (user, roles, callback) ->
        Admin.findOne {user: user.id}, (err, admin) ->
                if err
                        admin = new Admin(user: user.id, pwd: uuid.v4(), role: roles)
                        admin.save (e, a) -> callback a
                else
                        console.log "admin #{admin.id} already in use"
                        
mongoose.model 'Admin', AdminSchema
Admin = mongoose.model 'Admin'
console.log chalk.yellow "==> #{Admin.modelName} schema loaded"
