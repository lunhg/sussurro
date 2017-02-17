### TEST LIBRARIES ###
cheerio  = require 'cheerio'
should   = require 'should'
request  = require 'supertest'

profile_test =
        nome_completo: uuid.v4()
        nome_artistico: uuid.v4()


bio_test =
        data_de_nascimento: Date.now()
        text: uuid.v4()
        data_de_falecimento: Date.now()

locals_test =
        nascimento:
                cidade: uuid.v4()
                estado: uuid.v4()
                "país": uuid.v4()
        falecimento:
                cidade: uuid.v4()
                estado: uuid.v4()
                "país": uuid.v4()

contato_test =
        redes_sociais: ['https://www.facebook.com/'+uuid.v4(), 'https://www.twitter.com/'+uuid.v4()]
        email: uuid.v4()+"@"+uuid.v4()+".net"
        telefone: "+12912345678"
        sites:['https://www.'+uuid.v4()+'.net', 'https://www.'+uuid.v4()+'.net']
        
wiki_test =
        name:uuid.v4()
        description: uuid.v4()
        
post_test =
        title:uuid.v4()
        text: uuid.v4()

console.log chalk.yellow("==> Sussurro test libraries loaded")
