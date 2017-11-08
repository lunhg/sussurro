# Configure o motor que alimenta os cursos,
# seus pontos de acesso, templates baixados
# do servidor e o controlador que que gerencia
# coisas como o que aparece na tela e o que
# é executado pelo firebase
makeRoutes = (results) ->
        a = for r in results
                console.log r.data
                if typeof r.data is 'object'
                        r.data.component.props= ['autorizado', 'user']
                        r.data.props = true
                        
                        r.data.component.props.push r.data.name
                        r.data.component.props.push "modelos"
                        r.data.component.props.push "atualizar"
                
                        #console.log Vue2Autocomplete
                        r.data.component.components = 
                                accordion: VueStrap.accordion
                                panel: VueStrap.panel
                                        
        
                        r.data.component.methods =
                                getDocumentValue: (id) -> document.getElementById(id).value
                                edit:edit       
                                update: update
                                _delete: _delete
                                filter:  filter         
                        
                r.data
                
        # return to promise 
        new VueRouter
                history: true,
                linkActiveClass: 'active-class'
                routes: a


buildRoutes = (result) ->
        a = for e in result.data
                log e
                Vue.http.get("/templates/routes/#{e}")
                
fetchRoutes = ->
        log "Loading templates..."
        Vue.http.get('/templates/index/routes')
                .then buildRoutes
                .then (results) -> Promise.all results
                .then makeRoutes
                
               
        
