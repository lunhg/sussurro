# Adiciona matriculas
onMatriculas = (event) ->
        o = {}
        for e in ['input_curso', 'input_estudante' ]
                el = document.getElementById 'list-'+e
                val = el.options[el.selectedIndex or 0].getAttribute('data-value')
                if e is 'input_curso' then o.curso = val 
                if e is 'input_estudante' then o.estudante = val
        o.certificado = false
        o.id = uuid.v4()
        self = this
        db = firebase.database()
        db.ref("/estudantes/#{o.estudante}").once('value').then((snapshot) ->
                estudante = snapshot.val()
        ).then((e)->
                db.ref("/cursos/#{o.curso}").once('value').then((snapshot) ->
                        onTrace(e, snapshot.val()).then -> 
                                toast self.$parent, {
                                        title: "Cobrança/Matrícula"
                                        msg: "pré-registrada para estudante #{e['ID User']} ",
                                        clickClose: true
                                        timeout: 200000
                                        position: "toast-top-right",
                                        type: "success"
                                }
                )
                e
        ).then((e)->
                ref = firebase.database().ref("matriculas/#{o.id}/")
                ref.set(o).then ->
                        toast self.$parent, {
                                title: "Matrícula"
                                msg: "#{o.id} registrada para estudante #{e['ID User']}",
                                clickClose: true
                                timeout: 200000
                                position: "toast-top-right",
                                type: "warning"
                        }
        ).then(->
                onComputed('matriculas')().then (matriculas) ->
                        Vue.set self.$parent, 'matriculas', matriculas
        ).catch((err) ->
                toast self.$parent, {
                        title: err.code
                        msg: "#<p>{err.message}:</p></br><p>#{err.stack}</p>"
                        clickClose: true
                        timeout: 200000
                        position: "toast-top-right",
                        type: "error"
                }
        )

       
