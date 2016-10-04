app.get '/users', (req, res, next) ->
        User.find (err, users) ->
                if not err
                        #res.render 'compositores', compositores
                        res.render 'users', {users: users}
                else
                        res.render 'users', {result: false, msg: "Nenhum usuário cadastrado. Seja o primeiro!"}
                
app.get '/users/profile', (req, res) ->
        
                                
