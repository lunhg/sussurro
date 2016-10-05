# Sussurro

Servidor teste para o sussurro. Desenvolvido como uma simulação de aplicação MVC-Rails, mas escrita completamente escrita em CoffeeScript e Ruby.

## instalando

    git clone https://www.github.com/jahpd/sussurro.git

## executando

- Antes de tudo, instale um servidor [MongoDB](https://docs.mongodb.com/manual/installation/)

- Vá para o diretório principal


    cd sussurro/


- Instale todos os pacotes necessários


	npm install

- Crie um diretório apropriado para a base de dados


    mkdir ./db
	mkdir ./db/data


- Você pode inicializar a base de dados, compilar e correr


	rake compile	
	mongod --dbpath=./db/data
	node server.js


- Ou simplismente


    npm start

