# GET /signup
app.get '/signup', (req, res) -> res.render 'signup', form: [{name:'email', placeholder:'email'}]

# POST /signup
app.post '/signup', (req, res) ->
        name = req.body.email.split("@")[0]
        
        User.findOne email: req.body.email, (err, users) ->
                console.log users
                if !err
                        console.log "===> user exist"
                        res.redirect "/?flash=false&msg=cadastro&type=notallowed"
                else
                        console.log "===> Creating new user"
                        user = new User(name: name, email: req.body.email, token: uuid.v4())
                        user.save()
                        res.cookie("#{user.token}#{new Date()}", { maxAge: 3600000, path: '/' })
                        console.log("<=== Done: #{user.id}")
                        email =
                                from: MAILBOT
                                to: user.email,
                                subject: "[SussurroBot]: Cadastro"
                                html: """Olá
                                <p>Parece que alguém (#{user.name}), criou uma conta no
                                <a href=\"http://localhost:3000\">Sussurro</a>.</p>
                                <br/>
                                <p>Se vocêr solicitou o serviço, por gentileza, clique no link abaixo e você será redirecionado para nossa página.</p>
                                <br/>
                                <a href=\"http://localhost:3000/verify?token=#{user.token}\">http://localhost:3000/verify?token=#{user.token}</a>"""
                
                        console.log "===> sending email to #{user.id}..."
                        mailer.sendMail email, (_err, info) ->
                                flash = if _err then false else true
                                res.redirect "/?flash=#{flash}&msg=cadastro"

# GET /verify
app.get '/verify', (req, res) ->
        console.log req.query.token
        User.findOne token: req.query.token, (err, user) ->
                if not err
                        user.password = generatePassword(12, null)
                        user.verified = true
                        user.token = uuid.v4()
                        user.save()
                        console.log user
                        email =
                                from: MAILBOT
                                to: user.email,
                                subject: "[SussurroBot]: Cadastro"
                                html: """Olá,
                                        
                                Estamos confirmando sua requisição. Geramos usa senha pra você. Sugerimos que <a href=\"localhost:3000/user/#{user._id}/edit\">troque</a> sua senha assim possível."""

                        console.log "===> sending email to #{user.id}..."
                        u = user
                        mailer.sendMail email, (err, info) ->
                                flash = if err then "erro" else "sucesso"
                                res.redirect "/user/#{u._id}/edit?flash=#{flash}&msg=verificado&token=#{u.token}"
                else
                        console.log "User not found"
                        res.redirect "/?flash=#{flash}"
