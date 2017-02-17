describe chalk.green("config/db"), ->

        it "url should be correct",->
                reg = new RegExp "mongodb://([a-z]+):(\d+)/#{process.env['SUSSURRO_COL_'+process.env.NODE_ENV]}"
                reg.should.match reg

        it 'boot user should be valid', ->
                reg = new RegExp "[a-zA-Z0-9]+"
                process.env['SUSSURRO_USER_'+process.env.NODE_ENV].should.match(reg)

        it 'boot password should be /^([a-zA-Z0-9@*#]{8,20})$/ : Match all alphanumeric character and predefined wild characters. Password must consists of at least 8 characters and not more than 20 characters.', ->
                new Promise (resolve) ->
                        keychain.getPassword {
                                account: process.env['SUSSURRO_USER_'+process.env.NODE_ENV]
                                service: 'sussurro.mongodb.'+ process.env.NODE_ENV
                        }, (err, pass) ->
                                reg = new RegExp "^([a-zA-Z0-9@*#]{8,20})$"
                                should(pass).match reg
                                resolve()

console.log chalk.yellow("==> Config db helpers loaded")
