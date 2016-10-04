###################
# Composition Model
###################
CompositionSchema = new mongoose.Schema
        name: String
        tag: String 
        path: String
        version: String
        link: String

CompositionSchema.methods.addPath = (p) ->
        this.path = p
        this.save()

CompositionSchema.methods.addVersion = (v) ->
        this.version = v
        this.save()

CompositionSchema.methods.addLink = (l) ->
        this.link = l
        this.save()
        
mongoose.model 'Composition', CompositionSchema
