# GET /
app.get '/', (req, res) ->
        try
                res.render 'index'
        catch e
                res.render 'error', {message: e.message, stack: e.stack, status: e.status} 
