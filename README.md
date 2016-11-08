# Sussurro

Servidor teste para o sussurro. Desenvolvido como uma simulação de aplicação MVC-Rails, mas escrita completamente escrita em CoffeeScript e Ruby.

## Instalando

    git clone https://www.github.com/jahpd/sussurro.git

## Executando

Antes de tudo, instale um servidor [MongoDB](https://docs.mongodb.com/manual/installation/). 

Vá para o diretório principal:

    cd sussurro/

Instale todos os pacotes necessários:

    npm install

Crie um diretório apropriado para a base de dados:

    mkdir ./db
    mkdir ./db/data


Você pode inicializar a base de dados, compilar e executar o servidor, na ordem respectiva:
        
    rake compile	
    mongod --dbpath=./db/data
    node server.js


## Executando tudo isso que estava em cima de uma vez:

    npm start

