# Comment these lines in test or production mode. #
Admin = mongoose.model 'Admin',
        name:
                first: String
                last:  String
                full:  String
        groups: []
        user:
                id: mongoose.Schema.Types.ObjectId
                name: String
