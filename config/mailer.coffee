### MAILGUN (https://mailgun.com) ###
_mail_conf = require("./mailgun.json")
MAILBOT = _mail_conf.email
MAILER = 
        auth:
                api_key: _mail_conf.api_key
                domain: _mail_conf.domain
# Booting Mailer
# create reusable transporter object using the default SMTP transport
mailer = nodemailer.createTransport mailgun_transport MAILER
