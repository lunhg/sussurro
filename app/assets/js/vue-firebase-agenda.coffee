# Agenda de cobranças relacional entre alunos, cursos, matrículas e cobranças
onInitAgenda = (el, type) ->
        new Promise (resolve, reject) ->
                try
                        dp = new DayPilot.Calendar(el)
                        dp.viewType = type
                        dp.init()
                        dp.events.list = []
                        resolve dp
                catch e
                        reject e


onLoadDataAgenda = ->
        new Promise (resolve, reject) ->
                db = firebase.database()
                promises = []
                
                for t in traces
                        promises.push db.ref("estudantes/#{t.estudante}").once('value')
                        promises.push db.ref("cursos/#{t.curso}").once('value')
                        promises.push db.ref("matriculas/#{t.matricula.id}").once('value')
                
                Promise.all(promises).then((results) ->
                        resolve {estudante:results[0], curso: results[1], matricula:results[2]}
                ).catch(reject)

onAddEventToList = (results) ->
        text = ""
        results[0].then (snapshot) ->
                estudante = snapshot.val()
                nome = estudante['Nome'] + estudante['Sobrenome']
                text += nome
        results[1].then (snapshot) ->
                curso = snapshot.val()
                nome = estudante['Nome do curso']
                text += " - "+nome
        results[1].then (snapshot) ->
                matricula = snapshot.val()
                nome = matricula.id
                text += " (matícula "+nome+")"
        period = moment.duration(1, 'hour')
        end = moment().add(traces.date.time, period).toISOString()
        event =
                id:traces.id
                text: text
                start: t.date.time
                end: end
        
        dp.event.list.push event
                
        Promise.all(_promises).then(->
                console.log dp.events.list
        ).catch((e) ->
                console.log e
        )

onCreateEvent = ->
