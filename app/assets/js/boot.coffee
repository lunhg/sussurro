window.app = null
fetchConfig().then fetchMenu
        .then fetchRoutes
        .then makeApp
        .then (_app) ->
                window.app = _app
                window.app.$mount("#app")                      
        .then ->
                document.getElementById('masterLoader').classList.add('hide')
                
                $ ->
                        $('.navbar-toggle').click ->
                                $('.navbar-nav').toggleClass('slide-in')
                                $('.side-body').toggleClass('body-slide-in')
                                $('#search').removeClass('in').addClass('collapse').slideUp(200)

        .catch (e) ->
                loader.children[8].setAttribute('src', '/assets/images/giphy.gif')
                reg = new RegExp("(at\W+\w+\W+[\w+\:\/\.\-]*\W+)")
                stack = for x in e.stack.split("\n")
                        "<span>#{x}</span><br/>"
                log "<h1> Error: #{e.code}</h1><br/><p>#{e.message}</p><br/>#{stack.join("")}"


