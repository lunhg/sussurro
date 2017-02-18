# Sussurro

Servidor de API para o [Sussurro](http://www.sussurro.musica.ufrj.br/).

## Sumário deste README

- [Desenvolvimento](#desenvolvimento)
  - [Download](#download)
- [Instalação](#instalacao)
  - [MONGODB](#mongodb)
  - [NVM e Node.js](#nvm_e_node.js)
  - [Variáveis do sussurro](#variaveis_do_sussurro)
- [Execução](#execucao)
  - [Construção](#construcao)
  - [Testes](#testes)
  - [Servidor](#servidor)
  - [Começar](#comecar)
  
# Desenvolvimento

Foi desenvolvido a partir do conceito [MVC](https://pt.wikipedia.org/wiki/MVC), com uma estrutura semelhante àquela do aplicativo [Ruby on Rails](http://rubyonrails.org/), mas escrita completamente escrita em [CoffeeScript](http://coffeescript.org/).

## Download

Em um terminal linux ou macosx, copie e cole, ou digite o seguinte comando:

    git clone https://www.github.com/jahpd/sussurro.git
	cd sussurro
	npm install


# Instalação

Para instalar um servidor sussurro na sua máquina, são necessários três _softwares_, que descreveremos a seguir, a partir de um computador linux ou macosx.

## MONGODB

Antes de tudo, instale o servidor de base de dados NoSQL, [MongoDB](https://docs.mongodb.com/manual/installation/):

    sudo apt-get install mongodb

Espere a instalação concluir, e então execute o seguinte comando:

    sudo mongod

## NVM e Node.js

O gerenciador de versões [Node.js](https://nodejs.org/en/), [NVM](https://github.com/creationix/nvm), foi usado ao invés do correspondente em outros gerenciadores de pacotes (como o `apt-get`):

    curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.0/install.sh | bash

Se você usar outro gerenciador, modifique o [`Gruntfile`](https://github.com/jahpd/sussurro/blob/master/Gruntfile.coffee#L42).

Adicione essas linhas ao seu arquivo `~/.bashrc`, `~/.profile`, ou `~/.zshrc` para carregar automaticamente, em cada nova sessão, fontes importantes:

    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm

Execute o seguinte comando. Você pode usar outra versão, mas tenha consciência que um mal-funcionamento pode ocorrer:

    nvm install node 4.2.2


## Variáveis do sussurro

Adicionalmente, adicione as seguintes variáveis no seu arquivo  `~/.bashrc`, `~/.profile`, ou `~/.zshrc`. Modifique as variáveis com o indicativo _*_

	export SUSSURRO_USER_DEV='nome_de_usuario'* 
    export SUSSURRO_HOST_DEV='localhost'
	export SUSSURRO_PORT_DEV=27017
	export SUSSURRO_COL_DEV='sussurro'


# Execução

Os comandos abaixo são executados pelo [NPM](https://www.npmjs.com/).

## Construção

Compila todos arquivos em `app/`, `boot/` `config/` em dois testes (_app_ e _servidor_) e em dois executáveis, o primeiro em `dist/` e o segundo em `bin/`,

    npm run build

## Testes

Executa os testes localizados em `app/**.test.coffee`, `boot/*.test.coffee` `config/*.test.coffee` 

    npm test

Todos os testes podem ser verificados em [BUILD_TEST](BUILD_TEST.md) e [WWW_TEST](WWW_TEST.md)

## Servidor

Executa o binário `node` localizado em `bin/www`:

	npm run serve

## Começar

Executa todos os três comandos acima:

	npm start

