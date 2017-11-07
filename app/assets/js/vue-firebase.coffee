# Variáveis computáveis
onComputed = (type) ->
        ->
                _type = type
                new Promise (resolve, reject) ->
                        if firebase.auth().currentUser
                                ref = _type+'/'
                                firebase.database()
                                        .ref(ref)
                                        .once('value')
                                        .then (snapshot) ->
                                                resolve snapshot.val()
                                        .catch (e) ->
                                                reject e
                        else
                                resolve()

# Editar ou atualizar campos de qq modelo
edit = (event) ->
        k = event.target.getAttribute('name')
        Vue.set this.atualizar, k, true

update = (event) ->
        k = event.target.getAttribute('name')
        f = this.$route.path.split('/')[1]
        o = {}
        i = 0

                
        for input in document.getElementsByClassName 'form-control'
                keys = input.id.split('@')
                if input.attributes.getNamedItem('type').value is 'date'
                        o[keys[1]] = input.valueAsDate
                else
                        o[keys[1]] = input.value
        self = this
        for key, val of o
                firebase.database()
                        .ref(f+'/'+k+'/'+key)
                        .set(val)

                Vue.set self[f][k], key, val

        Vue.set self.atualizar, k, false

# Editar ou atualizar campos de qq modelo
_delete = (event) ->
        k = event.target.getAttribute('name')
        f = this.$route.path.split('/')[1]
        if f is 'cobrancas'
                f = 'traces'
        console.log "Deleting #{f}/#{k}"
        self = this
        db = firebase.database()
        
        db.ref("#{f}/#{k}").set(null).then ->
                if f is 'formularios'
                        for e in ['questions', 'responses']
                                db.ref("#{e}/#{k}").set(null).then(->
                                        toast self.$parent, {
                                                title: e,
                                                msg: "#{k} deletado"
                                                clickClose: true
                                                timeout: 10000
                                                position: "toast-top-right",
                                                type: "success"
                                        }
                                )
                toast self.$parent, {
                        title: f,
                        msg: "#{k} deletado"
                        clickClose: true
                        timeout: 10000
                        position: "toast-top-right",
                        type: "success"
                }

        firebase.database().ref("#{f}/").once('value').then((snapshot) ->       
                Vue.nextTick ->
                        if f is 'traces'
                                f = 'cobrancas'
                        Vue.set self.$parent, f, snapshot.val()
        )
               
                

        
                
filter = (j,k) ->
        ref = k.split(j)[1]
        if ref is 'curso' or ref is 'estudante' or ref is 'matricula' then ref = ref+'s'
        if ref is  'typeform' then ref = 'formularios'
        if ref is  'typeform' then ref = 'formularios'
        return this[ref]
        
schedule = ->
        fn = ->
               
                onComputed('traces')().then (r) ->
                        console.log r
                        Vue.set(self.$parent, 'cobrancas', r)
                onComputed('estudantes')().then (r) ->
                        Vue.set(self, 'estudantes', r)
        
                onComputed('responses')().then (r) ->
                        Vue.set(self, 'responses', r)

                onComputed('formularios')().then (r) ->
                        Vue.set(self, 'formularios', r)

                onComputed('questions')().then (q) ->
                        Vue.set(self, 'questions', q)
        
                onComputed('cursos')().then (q) ->
                        Vue.set(self, 'cursos', q)
        sob.timeout(fn, 1000)

create_event = (start, end) ->
        

# https://stackoverflow.com/questions/400212/how-do-i-copy-to-the-clipboard-in-javascript
copyToClipboard = ->
        copyTextareaBtn = document.querySelector '.toast-container'
        copyTextareaBtn.addEventListener 'click', (event) ->
                copyTextarea = document.querySelector('##{data.id}')
                copyTextarea.select()
                try
                        successful = document.execCommand 'copy'
                        msg = if successful then 'successful' else 'unsuccessful'
                        toast root, {
                                title: "Texto copiado"
                                clickClose: true
                                timeout: 200000
                                position: "toast-top-right",
                                type: "warning"
                        }
                
                catch err
                        toast root, {
                                title: "Não foi possível copiar o texto"
                                msg: err
                                clickClose: true
                                timeout: 200000
                                position: "toast-top-right",
                                type: "error"
                        }
