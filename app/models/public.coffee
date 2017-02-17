PublicSchema = new mongoose.Schema
        path: String
        name: String
        profile:
                type: mongoose.Schema.Types.ObjectId
                ref:  'Profile'
        
PublicSchema.plugin timestamps

mongoose.model 'Public', PublicSchema
Public = mongoose.model 'Public'
console.log chalk.yellow "==> #{Public.modelName} schema loaded"
