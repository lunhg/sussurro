### Initialize a index router ###
index = {}
        

### GET / ###
index.welcome = (req, res) ->
        json = 
                flash: false
                msg: ''
                wikis: []
                
        Wiki.find {}, 'name description posts', (err, wikis) ->
                if err
                        res.json {error: err}
                else
                        j=0
                        each wikis, (wiki, i, a) ->
                                json.wikis.push wiki
                                Post.find {wiki: wiki._id}, 'title text author updatedAt', (err, posts) ->
                                        if err
                                                res.json {error: err}
                                        else
                                                each posts, (post, j, aa) ->
                                                        json.wikis[i].posts[j] =
                                                                text: post.text
                                                                title: post.title
                                                                updatedAt: post.updatedAt

                        res.status 200
                        res.json json

console.log chalk.yellow("==> Index helpers loaded")
