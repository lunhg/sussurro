# Para cada estudante observado em traces/
# verifique se a matricula foi criada (de forma que existe um pre-registro).
# Se não tiver sido criada, utilize um pré-registro para cadastrar
# um curso e um aluno nessa matrícula.
onTraces = (traces, root) ->
        new Promise (resolve, reject) ->
                promises = []
                db = firebase.database()
                
                for k, t of traces
                        m = t.matricula.id
                        created = t.matricula.created
                        e = t.estudante
                        sent_mail = t.sent_mail
                        if not created
                                promises.push(db.ref("matriculas/#{m}").set({id:m, estudante:e, curso: t.curso}).then((->
                                        db.ref("traces/#{this.t.id}/matricula/created").set(true)
                                        toast root, {
                                                title: "Matrícula"
                                                msg: "#{this.m} registrada",
                                                clickClose: true
                                                timeout: 200000
                                                position: "toast-top-right",
                                                type: "warning"
                                        }
                                ).bind(t:t, m:m)).then((->
                                        self = this
                                        new Promise (resolve, reject) ->
                                                ref = "estudantes/#{self.t.estudante}"
                                                email = {}
                                                self = this
                                                db.ref(ref).once('value').then( (e) ->
                                                        estudante = e.val()
                                                        console.log estudante
                                                        email.to = estudante['Email1']
                                                        email.nome = estudante['Nome']
                                                        email.nome += " #{estudante['Sobrenome']}"
                                                        resolve email
                                                ).catch reject
                                ).bind(t:t)).then(((email) ->
                                        self = this
                                        new Promise (resolve, reject) ->
                                                ref = "cursos/#{self.t.curso}"
                                                db.ref(ref).once('value').then (c) ->
                                                        _curso = c.val()
                                                        email.curso = _curso['Nome do curso']
                                                        if e['Alumni(Sim_Não)'] is "Sim"
                                                                email.link = _curso['Código Pagseguro 1']
                                                        else
                                                                email.link = _curso['Código Pagseguro 3']
                                                        try
                                                                if email.link.match /https:\/\/pag\.ae\/\w+/
                                                                        email.link = email.link.split("https://pag.ae/")[1]
                                                                        resolve email
                                                                else
                                                                        reject new Error("link pagseguro inválido: #{email.link}")
                                                        catch e
                                                                reject e 
                                ).bind(t:t)).then((email)->
                                        new Promise (resolve, reject) ->
                                                url = '/mailer/send/boleto?'
                                                url += "curso=#{email.curso}"
                                                url += "&to=#{email.to}"
                                                url += "&nome=#{email.nome}"
                                                url += "&link=#{email.link}"
                                                resolve url
                                ).then((url)->
                                        Vue.http.post(url)
                                ).then(((response) ->
                                        data = response.data
                                        console.log data
                                        db.ref("traces/#{this.t.id}/sent_mail").set(true)
                                        time = (new Date()).toISOString()
                                        db.ref("traces/#{this.t.id}/date").set(time:time)
                                        
                                        toast root, {
                                                title: "Email de cobrança"
                                                msg: "<span id='#{data.id.split('@')[1]}'>#{data.id}\n#{data.message}</span>",
                                                clickClose: true
                                                timeout: 200000
                                                position: "toast-top-right",
                                                type: "warning"
                                        }
                                ).bind(t:t)).then(resolve).catch((err) ->
                                        toast root, {
                                                title: err.code
                                                msg: "#{err.message}\n#{err.stack}"
                                                clickClose: true
                                                timeout: 200000
                                                position: "toast-top-right",
                                                type: "error"
                                        }
                                        console.log err
                                ))
                                
                Promise.all(promises).then(resolve).catch(reject)


# # Rastreio de estudantes qe se matricularam
# - Matricula feira
# - Cobrança feita
# - Cobrança Paga
onTrace = (estudante, curso)->
        new Promise (resolve, reject) ->
                promises = []
                db = firebase.database()
                db.ref("traces/").once('value').then (snapshot) ->
                        if snapshot.val() isnt null
                                for k,v of snapshot.val()
                                        b = v.estudante is est['ID User']
                                        b = b and not v.matricula.created
                                        if b
                                                _newid = uuid.v4()
                                                newid = uuid.v4()
                                        
                                                # Pré-criar uma matrícula
                                                promises.push db.ref("traces/#{_newid}").set({
                                                        id: _newid
                                                        estudante:estudante['ID User']
                                                        curso:curso['ID do curso']
                                                        matricula:
                                                                id:newid
                                                                created:false
                                                        sent_mail: false
                                                        paid: false
                                                        date: (new Date()).toISOString()
                                                })
                                                        
                        else
                                _newid = uuid.v4()
                                newid = uuid.v4()
                                promises.push db.ref("traces/#{_newid}").set({
                                        # Pré-criar uma matrícula
                                        id: _newid
                                        estudante:estudante['ID User']
                                        curso:curso['ID do curso']
                                        matricula:
                                                id:newid
                                                created:false
                                        sent_mail: false
                                        paid: false
                                        date: (new Date()).toISOString()
                                })
                                        
                Promise.all(promises).then(-> resolve(estudante)).catch(reject)
