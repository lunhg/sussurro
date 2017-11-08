# Valida Login
emailRE = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/


validation = -> {
        name:!!@user.name.trim()
        email:emailRE.test(@user.name)
}

isValid = ->
        val = @validation
        Object.keys(val).every (key) -> val[key]

onErr = (err) ->
        toast {
                title: err.code,
                msg: "#<p>{err.message}:</p></br><p>#{err.stack}</p>"
                clickClose: true
                timeout: 5000
                position: "toast-top-right",
                type: "error"
        }
# Login
login = ->
        id_login = 'input_login_email'
        id_password = 'input_login_password'
        self = this
        email = document.getElementById(id_login).value

        if email.match(emailRE)
                firebase.auth()
                        .signInWithEmailAndPassword(email,(document.getElementById(id_password).value))
                        .then((user) ->
                                toast {
                                        title: "Bem-vindo(a)",
                                        msg: user.name or user.email
                                        clickClose: true
                                        timeout: 5000
                                        position: "toast-top-right",
                                        type: "success"
                                }
                        ).catch(onErr)
        else
                 onErr new Error "Email inválido"

# Signup
signup = ->
        id_login = 'input_signup_email'
        id_password = 'input_signup_senha'
        self = this
        email = document.getElementById(id_login).value
        if email.match(emailRE)
                firebase.auth()
                        .createUserWithEmailAndPassword(email, document.getElementById(id_password).value)
                        .then((user) ->
                                toast {
                                        title: "Bem-vindo(a)",
                                        msg: user.name or user.email
                                        clickClose: true
                                        timeout: 5000
                                        position: "toast-top-right",
                                        type: "success"
                                }
                        ).catch(onErr)
        else
                onErr new Error("Password not match")
# Logout
logout = ->
        self = this
        onSignout = ->
                self.$router.push '/login'
                toast {
                        title: "Você saiu",
                        msg: "com sucesso do Sussurro"
                        clickClose: true
                        timeout: 5000
                        position: "toast-top-right",
                        type: "success"
                }
        firebase.auth().signOut().then(onSignout).catch (err) ->
                toast self.$parent, {
                        title: err.code
                        msg: "#<p>{err.message}:</p></br><p>#{err.stack}</p>"
                        clickClose: true
                        timeout: 200000
                        position: "toast-top-right",
                        type: "error"
                }

# Adiciona ou remove usuários


# Quando firebase for criado ou montado
onAuthStateChanged = ->
        self = this
        firebase.auth().onAuthStateChanged (user) ->
                if user
                        self.autorizado = true
                        for e in 'displayName email photoURL telephone'.split(' ')
                                Vue.set self.user, e, self.user[e]
                                                
                        self.$router.push '/'
                else 
                        Vue.set self, 'autorizado', false
