ViewSchema = new mongoose.Schema
        path: String
        engine: String
        profile:
                type: mongoose.Schema.Types.ObjectId
                ref:  'Profile'
        
ViewSchema.plugin timestamps

mongoose.model 'View', ViewSchema
View = mongoose.model 'View'
console.log chalk.yellow "==> #{View.modelName} schema loaded"
