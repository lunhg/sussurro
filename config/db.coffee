### Database connection ###             
class SussurroConn
        constructor:  ->
                
        connect: ->
                new Promise (resolve, reject) ->
                        key = {
                                account: process.env['SUSSURRO_USER_'+process.env.NODE_ENV]
                                service: 'sussurro.mongodb.'+ process.env.NODE_ENV
                        }
                        mdb = {
                                host   : process.env['SUSSURRO_HOST_'+process.env.NODE_ENV]
                                port   : process.env['SUSSURRO_PORT_'+process.env.NODE_ENV]
                                db     : process.env['SUSSURRO_COL_'+process.env.NODE_ENV]
                        }
                        keychain.getPassword key, (err, pass) ->       
                                mongoose.connect "mongodb://#{mdb.host}:#{mdb.port}/#{mdb.db}", {
                                        user: key.account
                                        pwd: pass
                                        uri_decode_auth: true
                                }, (error, db) ->
                                        if error
                                                reject error
                                        else
                                                resolve mongoose.connection.readyState

        
        disconnect: (callback) ->
                new Promise (resolve, reject) ->
                        mongoose.disconnect()
                        resolve  mongoose.connection.readyState

console.log chalk.yellow("==> Mongodb helper loaded")
