### LOAD LIBRARIES ###
{{boot/libs}}

### LOAD DATABASE ###
{{config/db}}
{{app/models/user}}
{{app/models/wiki}}
{{app/models/post}}
{{app/models/composition}}
{{boot/db}}
{{config/mailer}}
{{config/soundcloud}}
{{boot/firstBoot}}
{{boot/mailer}}
{{boot/init}}
{{boot/passport}}

### CONFIG MAILER ###
{{app/mailers/contact}}
{{app/mailers/signup}}

### CONFIG ROUTES ###
{{app/controllers/index}}
{{app/controllers/login}}
{{app/controllers/user}}

module.exports = app
