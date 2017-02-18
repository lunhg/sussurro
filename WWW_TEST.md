# TOC
   - [Sussurro server](#sussurro-server)
<a name=""></a>
 
<a name="sussurro-server"></a>
# Sussurro server
should GET http://localhost:3000/.

```js
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
```

should GET http://localhost:3000/api/profiles.

```js
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
```

should POST http://localhost:3000/api/profiles/create with a form.

```js
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
```

should GET http://localhost:3000/api/profiles get three profiles.

```js
return request("http://localhost:3000").get('/api/profiles').expect('Content-Type', /json/).expect(200).expect(function(res) {
  res.body.should.be.an.Array();
  res.body.should.be.not.empty();
  return res.body.should.have.length(3);
});
```

should GET all http://localhost:3000/api/profiles/:id.

```js
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
```

should GET all http://localhost:3000/api/contatos/:id.

```js
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
```

should GET all http://localhost:3000/api/bios/:id.

```js
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
```

should GET http://localhost:3000/api/locals get six locals.

```js
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
```

should GET all http://localhost:3000/api/locals/:id.

```js
return mongoose.model('Local').find({}, function(err, locals) {
  return each(locals, function(local, i, p) {
    return request("http://localhost:3000").get('/api/locals/' + local._id).expect('Content-Type', /json/).expect(200).expect(function(res) {
      res.body.should.have.property('cidade');
      res.body.should.have.property('estado');
      return res.body.should.have.property('país');
    });
  });
});
```

should GET http://localhost:3000/api/wikis get one wiki.

```js
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
```

should GET all http://localhost:3000/api/wikis/:id.

```js
return mongoose.model('Wiki').find({}, function(err, wikis) {
  return each(wikis, function(wiki, i, p) {
    return request("http://localhost:3000").get('/api/wikis/' + wiki._id).expect('Content-Type', /json/).expect(200).expect(function(res) {
      wiki.should.have.property('description');
      wiki.should.have.property('name');
      return wiki.should.have.property('posts').which.have.length(3);
    });
  });
});
```

should GET http://localhost:3000/api/posts get three posts.

```js
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
```

should GET all http://localhost:3000/api/posts/:id.

```js
return mongoose.model('Post').find({}, function(err, posts) {
  return each(posts, function(post, i, p) {
    return request("http://localhost:3000").get('/api/posts/' + post._id).expect('Content-Type', /json/).expect(200).expect(function(res) {
      return post.should.have.property('text');
    });
  });
});
```

