# GET /
app.get '/', (req, res, next) ->
        json =
                filters: [ marked ]
                flash:   if req.query.msg then true else false
                msg:     if req.query.msg then (if req.query.msg is 'contato' then "Mensagem enviada." else (if req.query.msg is 'cadastro' and req.query.type is 'notallowed' then "Usuário já existe" else "Cadastro feito. Verifique seu email!")) else false
       
        Wiki.findOne name: "Sussurro", (err, wiki) ->
                if not err
                        Post.findOne {wiki: wiki._id, ref: (req.query.ref||'about')}, (_err, post) ->
                                if not _err
                                        json.title = post.title
                                        json.text = post.text
                                        json.publishedAt = post.createdAt
                                        json.wikiname = wiki.name
                                        json.wikiref = req.query.ref
                                Post.find()
                                        .where('wiki', wiki._id)
                                        .where('title')
                                        .ne(post.title)
                                        .limit(5)
                                        .exec (_err_, _posts) -> if not _err_ then json.wikiposts = {title: p.title, ref: p.ref} for p in _posts
                                Wiki.find()
                                        .where('name')
                                        .ne(wiki._id)
                                        .limit(5)
                                        .exec (_err, _newikis) -> if not _err then json.newikis = {name: w.name, ref: w.ref} for w in _wikis
                        console.log json
                        res.render 'index', json
                else
                        throw new Error(err)
