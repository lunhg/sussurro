# # Processo de Registro de uma Matricula
# Com o status de não matriculado, e não certificado
# com o nome correspondente à matrícula do curso referido
# no campo ID curso para cada resposta, que será relacionada
# à um novo estudante
onGetEstudantesInfo = (result) ->
        new Promise (resolve, reject) ->
                estudantes = []
                for r in result.data.responses
                        estudante = null
                        for q, question of result.data.questions
                                if estudante is null then estudante = {}
                                if estudante[question.question] is undefined
                                        estudante[question.question] = r.answers[question.id]
                        estudantes.push estudante
                resolve estudantes

# Adiciona Estudante
onEstudantes= (event) ->
        o = {}
        for e in ['nome', 'sobrenome', 'email1', 'email2', 'email3', 'profissao','graduacao', 'idade', 'genero', 'telefone', 'estado', 'cidade', 'isAlumni' ]
                el = document.getElementById 'input_'+e
                switch(e)
                        when 'nome' then o['Nome'] = el.value or "UNDEFINED"
                        when 'sobrenome' then o['Sobrenome'] = el.value or "UNDEFINED"
                        when 'email1' then o['Email1'] = el.value or "UNDEFINED"
                        when 'email2' then o['Email2'] = el.value or "UNDEFINED"
                        when 'email3' then o['Email3'] = el.value or "UNDEFINED"
                        when 'profissao' then o['Profissão'] = el.value or "UNDEFINED"
                        when 'graduacao' then o['Graduação'] = el.value or "UNDEFINED"
                        when 'genero' then o['Gênero'] = el.value or "UNDEFINED"
                        when 'telefone' then o['Telefone'] = el.value or "UNDEFINED"
                        when 'isAlumni' then o['Alumni(Sim_Não)'] = el.value or "UNDEFINED"
        
        o['Cidade_Estado_País'] = "#{o['cidade']}, #{o['estado']}, Brasil"
        delete o['cidade']
        delete o['estado']
        delete o['cidade']                     
        o['ID User'] = uuid.v4()
        self = this
        firebase.database().ref("estudantes/#{o['ID User']}").set(o).then(->
                firebase.database().ref("estudantes/").once('value').then((snapshot)->
                        Vue.set self.$parent, 'estudantes', snapshot.val()
                        toast self.$parent, {
                                title: "Estudante",
                                msg: "#{o['ID User']} registrado"
                                clickClose: true
                                timeout: 10000
                                position: "toast-top-right",
                                type: "success"
                        }
                )
        ).catch((err)->
                toast self.$parent, {
                        title: err.code
                        msg: "#<p>{err.message}:</p></br><p>#{err.stack}</p>"
                        clickClose: true
                        timeout: 10000
                        position: "toast-top-right",
                        type: "success"
                }
        )


onCheckEstudantes = (estudantes) ->
        self = this
        new Promise (resolve, reject) ->
                promises = []
                make = (e) ->
                        estudante = {}
                        a = 'Email2 Email3 Gênero Telefone'
                        b = 'Nome Sobrenome Idade Profissão'
                        for p in a.split(' ')
                                estudante[p] = "UNDEFINED"
                        for p in b.split(' ')
                                estudante[p] = e[p]
                        estudante['ID User'] = uuid.v4()
                        estudante['Alumni(Sim_Não)'] = "Não"
                        estudante['Email1'] = e['Email']
                        estudante['Graduação'] = e['Escolaridade']
                        estudante['Cidade_Estado_País'] = "#{e['Cidade']} #{e['Estado']} Brasil"
                        estudante
                                
                save = (e) ->
                        new Promise (_resolve, _reject) ->
                                db = firebase.database()
                                firebase.database().ref("/estudantes/#{e['ID User']}").set(e).then(->
                                        toast self.$parent, {
                                                title: "Estudante"
                                                msg: "#{e['ID User']} registrado",
                                                clickClose: true
                                                timeout: 200000
                                                position: "toast-top-right",
                                                type: "warning"
                                        }
                                ).then(_resolve).catch(_reject)

                makeAndSave = (e) ->
                        estudante = make(e)
                        save(estudante).then(onTrace(estudante).then(->
                                toast self.$parent, {
                                        title: "Cobrança/Matrícula"
                                        msg: "pré-registrada para estudante #{estudante['ID User']} ",
                                        clickClose: true
                                        timeout: 200000
                                        position: "toast-top-right",
                                        type: "success"
                                }
                        ).catch((err) ->
                                toast self.$parent, {
                                        title: err.code
                                        msg: "#<p>{err.message}:</p></br><p>#{err.stack}</p>"
                                        clickClose: true
                                        timeout: 200000
                                        position: "toast-top-right",
                                        type: "error"
                                }
                        ))

                firebase.database().ref("estudantes/").once('value').then (snapshot) ->
                        for e in estudantes
                                if snapshot.val() is null
                                        promise = makeAndSave(e)
                                        promises.push p
                                else
                                        alreadyFound = false

                                        # Primeiro crie se nenhum for encontrado na base de dados
                                        for k,v of snapshot.val()
                                                if e['Email'] is v['Email1'] and not alreadyFound
                                                        alreadyFound = true
                                                        msg = "#{v['ID User']} já existe"
                                                        p = Promise.resolve(v).then(->
                                                                toast self.$parent, {
                                                                        title: "Estudante"
                                                                        msg: msg
                                                                        clickClose: true
                                                                        timeout: 200000
                                                                        position: "toast-top-right",
                                                                        type: "warning"
                                                                }
                                                        )
                                                        promise.push p
                                                if e['Email'] isnt v['Email1'] and not alreadyFound
                                                        alreadyFound = true
                                                        onTrace(e).then ->
                                                                p = save(estudante).then ->
                                                                        toast self.$parent, {
                                                                                title: "Estudante"
                                                                                msg: msg
                                                                                clickClose: true
                                                                                timeout: 200000
                                                                                position: "toast-top-right"
                                                                                type: "warning"
                                                                        }
                                                                prommises.push p
                                                
                                                                  
                Promise.all(promises).then(resolve).catch((err)->
                        toast self.$parent, {
                                title: err.code
                                msg: "#<p>{err.message}:</p></br><p>#{err.stack}</p>"
                                clickClose: true
                                timeout: 200000
                                position: "toast-top-right",
                                type: "error"
                        }
                        reject()
                )
