### ROUTES ###
sussurro.app.param 'id', profiles.id
sussurro.app.param 'contact_id', contatos.id
sussurro.app.param 'bio_id', contatos.id
sussurro.app.param 'local_id', locals.id
### Start app ###
sussurro.app.param 'wiki_id', wikis.id
sussurro.app.param 'post_id', posts.id

### Welcome ###
sussurro.app.get '/', index.welcome

### Profiles ###
sussurro.app.get   "/api/profiles", profiles.index
sussurro.app.get   "/api/profiles/:id", profiles.profile
sussurro.app.post  "/api/profiles/create", profiles.create

### Contatos ###
sussurro.app.get   "/api/contatos", contatos.index
sussurro.app.get   "/api/contatos/:contact_id", contatos.contato

### Bio ###
sussurro.app.get   "/api/bios", bios.index
sussurro.app.get   "/api/bios/:bio_id", bios.bio

### Local ###
sussurro.app.get   "/api/locals", locals.index
sussurro.app.get   "/api/locals/:local_id", locals.local

### Wiki ###
sussurro.app.get   "/api/wikis", wikis.index
sussurro.app.get   "/api/contatos/:wiki_id", wikis.wiki

### Bio ###
sussurro.app.get   "/api/posts", posts.index
sussurro.app.get   "/api/posts/:posts_id", posts.post

console.log chalk.cyan("==> Sussurro ready")
