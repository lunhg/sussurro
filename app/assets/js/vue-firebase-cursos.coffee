# Adiciona turmas
onCursos= (event) ->
        o = {}
        for e in ['nome', 'inicio_matricula','fim_matricula', 'carga_horaria','quantidade_aulas','data_inicio','data_inicio_valor1', 'data_inicio_valor2', 'data_inicio_valor3', 'valor_cheio', 'link_valor1', 'link_valor2', 'link_valor3']
                el = document.getElementById 'input_'+e
                switch(e)
                        when 'nome' then o['Nome do curso'] = el.value or "UNDEFINED"
                        when 'typeformcode' then o['Código Typeform'] = el.value or "UNDEFINED"
                        when 'inicio_matricula' then o['Início das matrículas'] = el.value or "UNDEFINED"
                        when 'fim_matricula' then o['Fim das matrículas'] = el.value or "UNDEFINED"
                        when 'carga_horaria' then o['Carga Horária'] = el.value or "UNDEFINED"
                        when 'quantidade_aulas' then o['Quantidade de Aulas'] = el.value or "UNDEFINED"
                        when 'data_inicio' then o['Data de início das aulas'] = el.value or "UNDEFINED"
                        when 'data_inicio_valor1' then o['Valor para data de início 1 (reais)'] = el.value or "UNDEFINED"
                        when 'data_inicio_valor2' then o['Valor para data de início 2 (reais)'] = el.value or "UNDEFINED"
                        when 'data_inicio_valor3' then o['Valor para data de início 3 (reais)'] = el.value or "UNDEFINED"
                        when 'valor_cheio' then o['Valor Cheio (reais)'] = el.value or "UNDEFINED"
                        when 'link_valor1' then o['Codigo Pagseguro 1'] = el.value or "UNDEFINED"
                        when 'link_valor2' then o['Codigo Pagseguro 2'] = el.value or "UNDEFINED"
                        when 'link_valor3' then o['Codigo Pagseguro 3'] = el.value or "UNDEFINED"
                        
                
        o['ID do Curso'] = uuid.v4()
        self = this
        firebase.database().ref("cursos/#{o['ID do Curso']}").set(o).then(->
                firebase.database().ref("cursos/").once('value').then((snapshot)->
                        Vue.set self.$parent, 'cursos', snapshot.val()
                        toast self.$parent, {
                                title: "Curso",
                                msg: "#{o['ID do Curso']} registrado"
                                clickClose: true
                                timeout: 10000
                                position: "toast-top-right",
                                type: "success"
                        }
                )
        ).catch((err)->
                toast self.$parent, {
                        title: err.code
                        msg: err.message
                        clickClose: true
                        timeout: 10000
                        position: "toast-top-right",
                        type: "success"
                }
        )
