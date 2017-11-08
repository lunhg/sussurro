# Única especificidade das variáveis computáveis
onComputedForm = ->
        new Promise (resolve, reject) ->
                if firebase.auth().currentUser
                        ref = "users/#{firebase.auth().currentUser.uid}/formularios"
                        firebase.database()
                                .ref(ref)
                                .once('value')
                                .then (snapshot) ->
                                        resolve snapshot.val()
                                .catch (e) ->
                                        reject e
                else
                        resolve()

# Cada `answer` é um formulário pré-matricula.
# Para cada formulário de pré-matricula temos um aluno
# que deve ser verificado como dos tipos:
#
#   - 0 (não foi aluno e não tem direito a desconto no boleto)
#   - 1 (foi aluno e tem direito a desconto de 25% no boleto)
#   - 2 (caso excepcional com direito a 10% de desconto no boleto)
onQuestions = (result) ->
        self = this
        new Promise (resolve, reject) ->
                promises = []
                db = firebase.database()
                typeformcode = document.getElementById('input_typeform')
                typeformcode = typeformcode.value
                for q in result.data.questions
                        promises.push db.ref("questions/#{typeformcode}/#{q.id}").set(q.question)
                Promise.all(promises).then(->
                        msg = "#{Object.keys(result.data.questions).length} questão(ões) registrada(s)"
                        toast self.$parent, {
                                title: "Typeform #{typeformcode}",
                                msg: msg
                                clickClose: true
                                timeout: 120000
                                position: "toast-top-right",
                                type: "warning"
                        }
                        resolve(result)
                ).catch((err) ->
                        toast self.$parent, {
                                title: err.code,
                                msg: err.message
                                clickClose: true
                                timeout: 120000
                                position: "toast-top-right",
                                type: "error"
                        }
                        reject()
                )

# Respostas são um conjunto de respostas individuais (answers)
onResponses = (result) ->
        self = this
        new Promise (resolve, reject) ->
                promises = []
                db = firebase.database()
                typeformcode = document.getElementById('input_typeform')
                typeformcode = typeformcode.value
                for r in result.data.responses
                        obj = metadata:r.metadata,answers:r.answers,completed:if r.completed is '1' then true else false
                        promise = db.ref("responses/#{typeformcode}/#{r.token}").set(obj)
                        promises.push promise
                Promise.all(promises).then(->
                        toast self.$parent, {
                                title: "Typeform",
                                msg: "Baixados #{result.data.responses.length} formulários de resposta"
                                clickClose: true
                                timeout: 120000
                                position: "toast-top-right",
                                type: "warning"
                        }
                        resolve(result)
                ).catch(->                       
                        toast self.$parent, {
                                title: "#{err.code}"
                                msg: err.message
                                clickClose: true
                                timeout: 20000
                                position: "toast-top-right",
                                type: "error"
                        }
                        reject()
                )
# Registra formulario simples
onRegisterForm = (result) ->
        self = this
        new Promise (resolve, reject) ->
                typeformcode = document.getElementById('input_typeform')
                typeformcode = typeformcode.value
                cursos = document.getElementById('input_curso')
                curso = cursos.options[cursos.selectedIndex or 0].getAttribute('data-value')
                firebase.database().ref("formularios/#{typeformcode}").set(curso: curso).then(->
                        toast self.$parent, {
                                title: "Typeform",
                                msg: "Formulário #{curso} registrado"
                                clickClose: true
                                timeout: 120000
                                position: "toast-top-right",
                                type: "warning"
                        }
                        
                ).then(->
                        firebase.database().ref("formularios/#{typeformcode}").once('value')
                ).then( (snapshot) -> 
                        resolve result
                ).catch((err) ->
                        toast self.$parent, {
                                title: err.code,
                                msg: err.message
                                clickClose: true
                                timeout: 120000
                                position: "toast-top-right",
                                type: "error"
                        }
                        reject()
                )

                                                
# Baixa formularios pre-matricula
onFormularios = (event) ->
        # Database
        db = firebase.database()
        query = ["/typeform/data-api?completed=true"]
        typeformcode = document.getElementById('input_typeform')
        typeformcode = typeformcode.value
        cursos = document.getElementById('input_curso')
        curso = cursos.options[cursos.selectedIndex or 0].getAttribute('data-value')
        query.push "uuid=#{typeformcode}"
        query = query.join('&')
        self = this
                                
        

        # * Capture o typeform
        # * popule as respostas (verificando a existência desse aluno no firebase, dando-lhe uma verificação `isAlumini={0 or 1 or 2}` para cada `answer` )
        # * e registre uma chave para cada formulario
        this.$http.get(query)
                .then onRegisterForm
                .then onQuestions
                .then onResponses
                .then onGetEstudantesInfo
                .then onCheckEstudantes
                .then ->
                        onComputed('formularios')().then (r) ->
                                Vue.set(self, 'formularios', r)
