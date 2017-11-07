#Booting Mailer
# create reusable transporter object using the default SMTP transport
mailer = nodemailer.createTransport(nodemailer_mailgun_transport({
        auth:
                api_key: process.env.MAILGUN_APIKEY
                domain: process.env.MAILGUN_DOMAIN
}))
