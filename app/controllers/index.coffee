# GET /
app.get '/', (req, res) ->
        json =
                filters: [ marked ]
                flash:   if req.query.msg then true else false
                msg:     if req.query.msg then (if req.query.msg is 'contato' then "Mensagem enviada." else (if req.query.msg is 'cadastro' and req.query.type is 'notallowed' then "Usuário já existe" else "Cadastro feito. Verifique seu email!")) else ""

        Wiki.findOne name: "Sussurro", (err, wiki) ->
                if not err     
                        Post.findOne {wiki: wiki._id, ref: (req.query.ref||'about')}, (_err, post) ->
                                if not _err
                                        json.title = post.title
                                        json.text = post.text
                                        if post.updatedAt then json.publishedAt = post.updatedAt else json.publishedAt = post.createdAt
                                        json.wiki =
                                                name: wiki.name
                                                ref : req.query.ref
                                                index: []
                                                posts: []

                                        onIndex = (_err, wikis) ->
                                                if not _err
                                                        json.wiki.index.push {name:w.name,ref:w.ref} for w in wikis
                                                        Post.find()
                                                                .where('wiki', wiki._id)
                                                                .where('title')
                                                                .ne(post.title)
                                                                .limit(10)
                                                                .exec onPosts
                                                else
                                                        res.render 'error', error: _err
                                                        
                                        onPosts = (_err_, posts) ->
                                                if not _err_
                                                        json.wiki.posts.push {title: p.title, ref: p.ref, publishedAt: p.publishedAt} for p in posts
                                                        console.log json.wiki.index
                                                        console.log json.wiki.posts
                                                        res.render 'index', json
                                                else
                                                        res.render 'error', error: _err_

                                        
                                        Wiki.find()
                                                .where('name')
                                                .ne(wiki._id)
                                                .limit(10)
                                                .exec onIndex
    
                                else
                                        res.render 'error', error: err
                else
                        res.render 'error', error: err
                               
             
                                                                       
                        #                        Wiki.find()
                        #                                .where('name')
                        #                                .ne(wiki._id)
                        #                                .limit(5)
                        #                                .exec (_err, _newikis) ->
                        #                                        if not _err
                        #                                                for w in _newikis
                        #                                                        json.wiki.wikis.push {
                        #                                                                name: w.name
                        #                                                                ref: w.ref
                        #                                                        } 
                        #                                                res.render 'index', json
                        #                                        else
                        #                                                res.render 'error', error: _err
                        #                catch e
                        #                        res.render 'error',
                        #                                message: 'Error!'
                        #                                error:
                        #                                        status: 'Unknow'
                        #                                        stack: e.stack
                        #                        next()
                        #        else
                        #                res.render 'error', error: _err
                #else
                        #res.render 'error', error: err

