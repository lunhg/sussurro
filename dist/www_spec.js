var app, chalk, debug, each, http, mongoose, normalizePort, port, request, server, should, uuid;

app = require('../dist/build');

debug = require('debug')('sussurro:server');

http = require('http');

chalk = require('chalk');

console.log(chalk.yellow("==> Sussurro server libraries loaded"));


/* Get port from environment and store in Express */

normalizePort = function(val) {
  var port;
  port = parseInt(val, 10);
  if (isNaN(port)) {
    return val;
  }
  if (port >= 0) {
    return port;
  }
  return false;
};

port = normalizePort(process.env.PORT || '3000');

app.set('port', port);


/* Create HTTP server */

server = http.createServer(app);


/* Listen on provided port, on all network interfaces */

server.on('error', function(error) {
  var bind, fn;
  if (error.syscall !== 'listen') {
    throw error;
  }
  bind = typeof port === 'string' ? 'Pipe ' + port : 'Port ' + port;
  fn = function(msg) {
    console.error(bind + ' ' + msg);
    return process.exit(1);
  };
  if (error.code === 'EACCES') {
    return fn('requires elevated privileges');
  } else if (error.code === 'EADDRINUSE') {
    return fn('is already in use');
  } else {
    throw error;
  }
});

server.on('listening', function() {
  var addr, bind;
  addr = server.address();
  bind = typeof addr === 'string' ? 'pipe ' + addr : 'port ' + addr.port;
  return console.log(chalk.cyan('==>Listening server in ' + bind));
});

server.listen(port);


/* TEST SERVER LIBRARIES */

should = require('should');

request = require('supertest');

uuid = require('node-uuid');

mongoose = require('mongoose');

each = require('foreach');

console.log(chalk.yellow("==> Sussurro server test libraries loaded"));

describe(chalk.green("Sussurro server"), function() {
  it('should GET http://localhost:3000/', function() {
    return request("http://localhost:3000").get('/').expect(200).expect(function(res) {
      var j, len, ref, results, wiki;
      res.body.should.have.property('flash', false);
      res.body.should.have.property('msg', '');
      res.body.should.have.property('wikis');
      res.body.wikis.should.be.Array();
      ref = res.body.wikis;
      results = [];
      for (j = 0, len = ref.length; j < len; j++) {
        wiki = ref[j];
        wiki.should.have.property('name');
        wiki.should.have.property('description');
        wiki.should.have.property('posts');
        results.push(wiki.posts.should.be.Array());
      }
      return results;
    });
  });
  it('should GET http://localhost:3000/api/profiles', function() {
    return request("http://localhost:3000").get('/api/profiles').expect('Content-Type', /json/).expect(200).expect(function(res) {
      var j, len, profile, ref, results;
      res.body.should.is.Array();
      res.body.should.have.length(2);
      ref = res.body;
      results = [];
      for (j = 0, len = ref.length; j < len; j++) {
        profile = ref[j];
        profile.should.have.property('updatedAt');
        profile.should.have.property('nome_artistico');
        profile.should.have.property('nome_completo');
        results.push(profile.should.have.property('posts'));
      }
      return results;
    });
  });
  it("should POST http://localhost:3000/api/profiles/create with a form", function() {
    return request("http://localhost:3000").post("/api/profiles/create").query({
      nome_completo: "Guilherme Martins Lunhani"
    }).query({
      nome_artistico: "Cravista"
    }).query({
      email: "lunhg@gmail.com"
    }).query({
      telefone: "+5515998006760"
    }).query({
      sites: "https://www.github.com/sussurro/sussurro||https://sussurro.github.io/"
    }).query({
      redes_sociais: "https://www.facebook.com/sussuro"
    }).query({
      bio: uuid.v4()
    }).query({
      data_nascimento: Date.now()
    }).query({
      data_falecimento: Date.now()
    }).query({
      local_de_nascimento: "país:Brasil||estado:SP||cidade:Sorocaba"
    }).query({
      local_de_falecimento: "país:null||estado:null||cidade:null"
    }).expect('Content-Type', 'application/json; charset=utf-8').expect(201).expect(function(res) {
      var m;
      m = res.body;
      m.should.have.property('msg');
      return m.msg.should.be.equal("Email enviado para lunhg@gmail.com");
    });
  });
  it("should GET http://localhost:3000/api/profiles get three profiles", function() {
    return request("http://localhost:3000").get('/api/profiles').expect('Content-Type', /json/).expect(200).expect(function(res) {
      res.body.should.be.an.Array();
      res.body.should.be.not.empty();
      return res.body.should.have.length(3);
    });
  });
  it("should GET all http://localhost:3000/api/profiles/:id", function() {
    return mongoose.model('Profile').find({}, function(err, profiles) {
      return each(profiles, function(profile, i, p) {
        return request("http://localhost:3000").get('/api/profiles/' + profile._id).expect('Content-Type', /json/).expect(200).expect(function(res) {
          profile = res.body;
          profile.should.not.have.property('err');
          profile.should.have.property('updatedAt');
          profile.should.have.property('nome_artistico');
          profile.should.have.property('nome_completo');
          return profile.should.have.property('posts');
        });
      });
    });
  });
  it('should GET http://localhost:3000/api/contatos get three contatos', function() {
    return request("http://localhost:3000").get('/api/contatos').expect('Content-Type', /json/).expect(200).expect(function(res) {
      var contato, j, len, ref, results;
      res.body.should.is.Array();
      res.body.should.have.length(3);
      ref = res.body;
      results = [];
      for (j = 0, len = ref.length; j < len; j++) {
        contato = ref[j];
        contato.should.have.property('email');
        contato.should.have.property('sites');
        contato.should.have.property('redes_sociais');
        results.push(contato.should.have.property('telefone'));
      }
      return results;
    });
  });
  it("should GET all http://localhost:3000/api/contatos/:id", function() {
    return mongoose.model('Contato').find({}, function(err, contatos) {
      return each(contatos, function(contato, i, p) {
        return request("http://localhost:3000").get('/api/contatos/' + contato._id).expect('Content-Type', /json/).expect(200).expect(function(res) {
          res.body.should.have.property('email');
          res.body.should.have.property('sites');
          res.body.should.have.property('redes_sociais');
          return res.body.should.have.property('telefone');
        });
      });
    });
  });
  it('should GET http://localhost:3000/api/bios get three bios', function() {
    return request("http://localhost:3000").get('/api/bios').expect('Content-Type', /json/).expect(200).expect(function(res) {
      var bio, j, len, ref, results;
      res.body.should.is.Array();
      res.body.should.have.length(3);
      ref = res.body;
      results = [];
      for (j = 0, len = ref.length; j < len; j++) {
        bio = ref[j];
        res.body.should.have.property('data_de_nascimento');
        res.body.should.have.property('data_de_falecimento');
        res.body.should.have.property('text');
        res.body.should.have.property('local_de_nascimento');
        results.push(res.body.should.have.property('local_de_falecimento'));
      }
      return results;
    });
  });
  it("should GET all http://localhost:3000/api/bios/:id", function() {
    return mongoose.model('Bio').find({}, function(err, bios) {
      return each(bios, function(bio, i, p) {
        return request("http://localhost:3000").get('/api/bios/' + bio._id).expect('Content-Type', /json/).expect(200).expect(function(res) {
          res.body.should.have.property('data_de_nascimento');
          res.body.should.have.property('data_de_falecimento');
          res.body.should.have.property('text');
          res.body.should.have.property('local_de_nascimento');
          return res.body.should.have.property('local_de_falecimento');
        });
      });
    });
  });
  it('should GET http://localhost:3000/api/locals get six locals', function() {
    return request("http://localhost:3000").get('/api/locals').expect('Content-Type', /json/).expect(200).expect(function(res) {
      var j, len, local, ref, results;
      res.body.should.is.Array();
      res.body.should.have.length(6);
      ref = res.body;
      results = [];
      for (j = 0, len = ref.length; j < len; j++) {
        local = ref[j];
        local.should.have.property('cidade');
        local.should.have.property('estado');
        results.push(local.should.have.property('país'));
      }
      return results;
    });
  });
  it("should GET all http://localhost:3000/api/locals/:id", function() {
    return mongoose.model('Local').find({}, function(err, locals) {
      return each(locals, function(local, i, p) {
        return request("http://localhost:3000").get('/api/locals/' + local._id).expect('Content-Type', /json/).expect(200).expect(function(res) {
          res.body.should.have.property('cidade');
          res.body.should.have.property('estado');
          return res.body.should.have.property('país');
        });
      });
    });
  });
  it('should GET http://localhost:3000/api/wikis get one wiki', function() {
    return request("http://localhost:3000").get('/api/wikis').expect('Content-Type', /json/).expect(200).expect(function(res) {
      var j, len, ref, results, wiki;
      res.body.should.is.Array();
      res.body.should.have.length(1);
      ref = res.body;
      results = [];
      for (j = 0, len = ref.length; j < len; j++) {
        wiki = ref[j];
        wiki.should.have.property('description');
        wiki.should.have.property('name');
        results.push(wiki.should.have.property('posts').which.have.length(3));
      }
      return results;
    });
  });
  it("should GET all http://localhost:3000/api/wikis/:id", function() {
    return mongoose.model('Wiki').find({}, function(err, wikis) {
      return each(wikis, function(wiki, i, p) {
        return request("http://localhost:3000").get('/api/wikis/' + wiki._id).expect('Content-Type', /json/).expect(200).expect(function(res) {
          wiki.should.have.property('description');
          wiki.should.have.property('name');
          return wiki.should.have.property('posts').which.have.length(3);
        });
      });
    });
  });
  it('should GET http://localhost:3000/api/posts get three posts', function() {
    return request("http://localhost:3000").get('/api/posts').expect('Content-Type', /json/).expect(200).expect(function(res) {
      var j, len, post, ref, results;
      res.body.should.is.Array();
      res.body.should.have.length(3);
      ref = res.body;
      results = [];
      for (j = 0, len = ref.length; j < len; j++) {
        post = ref[j];
        results.push(post.should.have.property('text'));
      }
      return results;
    });
  });
  return it("should GET all http://localhost:3000/api/posts/:id", function() {
    return mongoose.model('Post').find({}, function(err, posts) {
      return each(posts, function(post, i, p) {
        return request("http://localhost:3000").get('/api/posts/' + post._id).expect('Content-Type', /json/).expect(200).expect(function(res) {
          return post.should.have.property('text');
        });
      });
    });
  });
});

console.log(chalk.yellow("==> Sussurro server test loaded"));
