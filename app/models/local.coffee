### Local Model ###
LocalSchema = new mongoose.Schema
        bio: {type: mongoose.Schema.Types.ObjectId, ref: 'Bio'}
        tipo: String
        cidade: String
        estado: String
        "país": String
     
LocalSchema.plugin timestamps

mongoose.model 'Local', LocalSchema
Local = mongoose.model 'Local'
console.log chalk.yellow "==> #{Local.modelName} schema loaded"
