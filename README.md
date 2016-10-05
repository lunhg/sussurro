# Sussurro

Servidor teste para o sussurro

## instalando

    git clone https://www.github.com/jahpd/sussurro.git

## executando

	cd sussurro/
	rake compile
	mkdir db ; mkdir db/data
	mongod --dbpath=./db/data
	node server.js

