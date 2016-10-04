# GET /mail
app.get '/mail', (req, res) -> res.render 'mail', form: [{name:'email', placeholder:'vc@email'}, {name:'subject', placeholder:'subject'}, {name:'text', placeholder:'Mensagem.'}]

###########
# POST /mail
############
app.post '/mail', (req,res)->
        console.log "===> sending email"
        email =
                from: req.body.email
                to: MAILBOT,
                subject: "[SussurroBot]: #{req.body.subject}"
                text: req.body.text
                
         mailer.sendMail email, (err, info) ->
                res.redirect "/#contato?flash=true&msg=contato"



        
                
        
