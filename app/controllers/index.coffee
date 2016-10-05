# GET /
app.get '/', (req, res) ->
        Wiki.findOne name: "Sussurro", (err, wiki) ->
                if not err     
                        Post.findOne {wiki: wiki._id, ref: (req.query.ref||'about')}, (_err, post) ->
                                if not _err
                                        json =
                                                filters: [ marked ]
                                                flash:   if req.query.msg then true else false
                                                msg:     if req.query.msg then (if req.query.msg is 'contato' then "Mensagem enviada." else (if req.query.msg is 'cadastro' and req.query.type is 'notallowed' then "Usuário já existe" else "Cadastro feito. Verifique seu email!")) else ""
                                                title: post.title
                                                text:  post.text
                                                updatedAt: post.updatedAt or post.createdAt
                                                authors: post.authors
                                                name: wiki.name
                                                ref : req.query.ref or "about"
                                                index: []
                                                posts: []
                                                
                                        onWiki = (_err, wikis) ->
                                                for w in wikis
                                                        json.index.push o=
                                                                name: w.name
                                                                ref:  w.ref
                                                console.log json
                                                res.render 'index', json
                                                
                                        onPosts = (_err, posts) ->
                                                if not _err
                                                        for p in posts
                                                                post = json.posts.push o=
                                                                        title: p.title
                                                                        ref: p.ref
                                                else
                                                        res.render 'error', error: _err
                                                              
                                        Post.find()
                                                .where('wiki', wiki._id)
                                                .where('title')
                                                .ne(post.title)
                                                .exec onPosts

                                        Wiki.find()
                                                .ne('wiki', wiki._id)
                                                .exec onWiki
                                else
                                        res.render 'error', error: _err
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

