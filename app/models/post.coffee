###################
# Post Model
###################
PostSchema = new mongoose.Schema
        title: String
        ref: String
        text: String
        authors: [{type: mongoose.Schema.Types.ObjectId, ref: 'User'}]
        wiki: mongoose.Schema.Types.ObjectId
        comments: [{type: mongoose.Schema.Types.ObjectId, ref: 'Comments'}]

PostSchema.plugin timestamps
mongoose.model 'Post', PostSchema
