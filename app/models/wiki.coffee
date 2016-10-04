###################
# Wiki Model
###################
WikiSchema = new mongoose.Schema
        name: String
        description: String
        posts: [{type: mongoose.Schema.Types.ObjectId, ref: 'Posts'}]

mongoose.model 'Wiki', WikiSchema
