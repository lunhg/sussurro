###  Wiki Model ###
WikiSchema = new mongoose.Schema
        name: String
        description: String
        posts: [{type: mongoose.Schema.Types.ObjectId, ref: 'Posts'}]

WikiSchema.plugin timestamps
                
mongoose.model 'Wiki', WikiSchema
Wiki = mongoose.model 'Wiki'
console.log chalk.yellow "==> #{Wiki.modelName} schema loaded"
