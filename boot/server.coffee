# LOAD LIBRARIES
{{boot/libs}}

# LOAD DATABASE
{{config/db}}
{{app/models/admin}}
{{app/models/user}}
{{app/models/wiki}}
{{app/models/post}}
{{app/models/composition}}
{{boot/db}}

# MAILER, SOUNDCLOUD, FACEBOOK APIS
{{config/mailer}}
{{config/soundcloud}}
{{boot/populate}}
{{boot/mailer}}
{{boot/init}}
{{boot/passport}}

# CONFIG MAILER
{{app/mailers/contact}}
{{app/mailers/signup}}

# CONFIG ROUTES
{{app/controllers/index}}
{{app/controllers/login}}
{{app/controllers/user}}

module.exports = app
