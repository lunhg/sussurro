# # makeApp
# Cria uma intância Vue de acordo com um `router`
# - Ver mais em: `app/assets/js/routes`
# - Ver mais em: `app/assets/js/vue-firebase` 
makeApp = (router) ->
        Vue.use(VueRouter)

        # # Inicialização
        # - Capture as definicoes da página em GET `/templates/index/page`
        # - Capture as configurações da página em GET `/templates/index/data`
        Promise.all([
                Vue.http.get("/templates/index/page")
                Vue.http.get("/templates/index/data")
        ]).then (results) ->
                new Promise (resolve, reject) ->
                        # Resolve em um novo aplicativo Vue
                        resolve new Vue
                                # Roteador definido em `app/assets/js/router.coffee`
                                router: router

                                # O componente `vanessador-menu` é definido no arquivo `app/assets/js/menu`
                                # enquanto o componente `router-view` é definido no arquivo precedente
                                template: results[0].data
                                components:
                                        'vue-toastr': window.vueToastr
                                        
                                # Função executada quando o aplicativo Vue.js for criado
                                # Deve registrar que, quando o usuário estiver logado,
                                # as variáveis de data e computados deverão ser atualizadas
                                created: onAuthStateChanged
                        
                                # Os dados apresentados pelo Vue de acordo com o firebase,
                                # typeform e pagseguro.
                                data: ->
                                        o = results[1].data
                                        #o[e] = {} for e in ['responses', 'questions', 'formularios', 'estudantes', 'cursos', 'matriculas', 'cobrancas']
                                        #o
                                        
                                # # Watch (variaveis)
                                # Em caso de mudanças nas variáveis e rotas,
                                # aplique as transformações específicas
                                watch: 
                                        '$route': (to, from) ->
                                                #if not this.autorizado then this.$router.push '/login'
                                                f = to.path.split('/')[1]
                                                self = this
                                                                        
                                                                
                                                                
                                # Métodos iniciais de Login e Logout
                                methods:
                                        login: login
                                        logout: logout
                                        signup: signup
