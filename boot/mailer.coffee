Admin.find (err, admins, next) ->
        
        if not err and process.env.NODE_ENV is 'test' or process.env.NODE_ENV is 'production'
                for admin in admins
                        email =
                                from: MAILBOT
                                to:  admin.user.email
                                subject: 'Sussurro booted'
                                html: '<h1>Wow!!!</h1> <b>Big powerful letters</b><br/><p>Mailgun rocks, pow pow!</p>'
                                bcc : admin.user.email
                        console.log "===> sending boot email to #{email.to}..."
                        mailer.sendMail email, (err, info) ->
                                if err
                                        console.log(err)
                                else
                                        console.log(info)
                next()
