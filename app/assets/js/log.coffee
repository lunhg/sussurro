# A mensagem de carregamento inicial
# deve ser atualizada
loader = document.getElementById('masterLoader')

log = (msg) ->
        p = loader.children[9]
        console.log msg
        
        # Give to main page a percept of fluxus
        fluxus = -> p.innerHTML = msg.toString()
        setTimeout fluxus, 750

toast = (root, obj) ->
        obj.title = "#{moment().format('MMMM Do YYYY, h:mm:ss a')} \n #{obj.title}"
        root.$refs.toastr.Add(obj)
