# Comment these lines in test or production mode. #
AdminSchema = mongoose.Schema
        name:
                first: String
                last:  String
                full:  String
        groups: []
        user:
                id: mongoose.Schema.Types.ObjectId
                name: String
                
AdminSchema.plugin mongoose_timestamp
mongoose.model 'Admin', AdminSchema
