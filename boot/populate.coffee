rootAdmin = null
rootUser = null

# Remove all current data
# Comment in test, deploy or production mode
model.remove({}) for model in [User, Admin, Wiki, Post, Composition]

console.log "===> Creating root admin"
rootAdmin = new Admin
                name: {first: 'Root', last: 'Admin', full: 'Root Admin'}
                groups: ['root']
                
rootUser = new User
        username: 'Leverkun-bot'
        isActive: false
        token: uuid.v4()
        email: MAILBOT,
        roles: {admin: rootAdmin._id}
        password: generatePassword(12, null)

rootAdmin.user = id: rootUser._id
rootAdmin.save()
rootUser.save()

console.log "===> Created #{rootUser.username}"
populate = (wiki, user, set) ->
        console.log "      Creating #{wiki.name}"
        index = new Post(title:"#{wiki.name} index", ref: 'index', authors: [user])
        each set, (v,k,a) ->
                p = new Post v
                p.wiki = wiki._id
                p.authors.push user 
                p.save()
                index.text += "\n\n   #{k}. [#{v.title}](/?wiki=#{wiki.name}&ref=#{v.ref})"
                console.log "            Creating #{v.title}"
                wiki.posts.push p

        index.save()
        wiki.save()     

# Sussurro
wiki = new Wiki(name: "Sussurro", description: "Wiki do Sussurro.")
populate wiki, rootUser.username, [{title: "Sussurro: Acervo Digital", ref: 'about', text: "O atual [Sussurro](http://sussurro.musica.ufrj.br/) é um acervo de música contemporânea produzida no Brasil. Foi criado em 2006 por [Rodolfo Caesar](http://buscatextual.cnpq.br/buscatextual/visualizacv.do?id=K4783960P4) com o objetivo de ser um espaço acessível de divulgação.\n\n"},{title: "Pesquisa", ref: 'research', text: "Aqui você poderá pesquisar as produções de diversos artistas, compositores e pesquisadores, eventualmente baixando obras completas ou apenas amostras (respeitando os direitos de reprodução - copyright ou copyleft), ou entrar em contato com seus [autores](/users)."}, {title:'Produção', ref: 'production', text:"A produção apresentada gira em torno do repertório das artes sônicas: músicas experimentais, sejam acusmáticas, mistas, live, auxiliadas-por-computador, algorítmicas, música-vídeo, multimídia, intermídia, músicas instrumentais com vetores experimentais, poesia, etc. (inexistindo um recorte tecnológico). A ideia é oferecer documentação e divulgação a uma produção que, para manter o que lhe é específico, não pode correr no mesmo passo do mercado."},{title:'Cadastro', ref: 'signup', text:"O cadastro é realizado ao acessar a página de [cadastro](/signup). Por sua vez, o usuário receberá um email com um [token](https://en.wikipedia.org/wiki/Chain_of_trust) para verificação.\n\nUma vez feita a verificação, o usuário pode [modificar sua senha](/?wiki=main&ref=senha)."},{title:'Login', ref: 'login', text:"O sussurro é um sistema [wiki](https://pt.wikipedia.org/wiki/Wiki), cuja base de dados é construída por [usuários](/?wiki=main&ref=users) e [administradores](/?wiki=main&ref=admin).\n\nO usuário pode então construir outros wikis, cujo documentos textuais podem fazer referêcia a outros [documentos](/?wiki=main&ref=post) e [composições](/?wiki=main&ref=composicao)."},{title:'Administradores', ref: 'admin', text:"*Página em construção*"},{title:'Usuários', ref: 'users', text:"*Página em construção*"},{title:'Senha', ref: 'senha', text:"*Página em construção*"}]

# Encun
encun = new Wiki(name:"Encun", description: "Assuntos para o Encun")
populate encun, rootUser.username, [{title: "Encontro Nacional de Compositores Universitários", ref: 'about', text: " *Página em construção*"},{title: "Encun I", ref: 'I', text: " *Página em construção*"},{title: "Encun II", ref: 'II', text: " *Página em construção*"},{title: "Encun III", ref: 'III', text: " *Página em construção*"},{title: "Encun IV", ref: 'IV', text: " *Página em construção*"},{title: "Encun V", ref: 'V', text: " *Página em construção*"},{title: "Encun VI", ref: 'VI', text: " *Página em construção*"},{title: "Encun VII", ref: 'VII', text: " *Página em construção*"},{title: "Encun VIII", ref: 'VIII', text: " *Página em construção*"},{title: "Encun IX", ref: 'IX', text: " *Página em construção*"},{title: "Encun X", ref: 'X', text: " *Página em construção*"},{title: "Encun V", ref: 'V', text: " *Página em construção*"}]
