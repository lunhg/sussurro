### Bio Model ###
_schema = 
        profile: {type: mongoose.Schema.Types.ObjectId, ref: 'Profile'}
        data_de_nascimento: {type: Date, required: true}
        local_de_nascimento: {type: mongoose.Schema.Types.ObjectId, ref: 'Local'}
        data_de_falecimento: {type:Date}
        local_de_falecimento: {type: mongoose.Schema.Types.ObjectId, ref: 'Local'}
        text: {type:String, required:true}
    
BioSchema = new mongoose.Schema _schema    
BioSchema.plugin timestamps     

mongoose.model 'Bio', BioSchema
Bio = mongoose.model 'Bio'
console.log chalk.yellow "==> #{Bio.modelName} schema loaded"
