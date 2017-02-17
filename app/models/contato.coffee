### Contato Model ###
validateLocalStrategyProperty = (property) -> ((@provider isnt 'local' and not @updated) or property.length)

ContatoSchema = new mongoose.Schema
        profile: {type: mongoose.Schema.Types.ObjectId, ref: 'Profile'}
        sites: String
        redes_sociais: String
        'referências': String
        email:
                type: String,
                trim: true,
                default: '',
                unique: true,
                validate: [validateLocalStrategyProperty, 'Please fill in your email'],
                match: [new RegExp(".+\@.+\..+"), 'Please fill a valid email address']
        telefone: String

ContatoSchema.plugin timestamps

onValidate = (value, done) ->
        Contato.count email: value, (err, count) ->
                if err then done(err) else done(!count)
                        
ContatoSchema.path('email').validate(onValidate, 'Email already exists')

mongoose.model 'Contato', ContatoSchema
Contato = mongoose.model 'Contato'
console.log chalk.yellow "==> #{Contato.modelName} schema loaded"
