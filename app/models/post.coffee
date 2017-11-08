### Post model ###
PostSchema = new mongoose.Schema
        title: String
        text: String
        ref: String
        author: {type: mongoose.Schema.Types.ObjectId, ref: 'Profile'}
        wiki:{type: mongoose.Schema.Types.ObjectId, ref: 'Wiki'}
        

PostSchema.plugin mongoose_timestamp
mongoose.model 'Post', PostSchema
Post = mongoose.model 'Post'
console.log chalk.yellow "==> #{Post.modelName} schema loaded"
