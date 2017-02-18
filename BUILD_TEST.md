# TOC
   - [config/db](#configdb)
   - [config/app](#configapp)
   - [boot/db](#bootdb)
   - [app/models/profile](#appmodelsprofile)
   - [app/models/bio](#appmodelsbio)
   - [app/models/local](#appmodelslocal)
   - [app/models/contato](#appmodelscontato)
   - [app/models/user](#appmodelsuser)
   - [app/models/wiki](#appmodelswiki)
   - [app/models/post](#appmodelspost)
   - [app/models/session](#appmodelssession)
   - [boot/app](#bootapp)
   - [app/controllers/profile](#appcontrollersprofile)
   - [app/controllers/bio](#appcontrollersbio)
   - [app/controllers/local](#appcontrollerslocal)
   - [app/controllers/contato](#appcontrollerscontato)
   - [app/controllers/wiki](#appcontrollerswiki)
   - [app/controllers/post](#appcontrollerspost)

# config/db
url should be correct.

```js
var reg;
reg = new RegExp("mongodb://([a-z]+):(\d+)/" + process.env['SUSSURRO_COL_' + process.env.NODE_ENV]);
return reg.should.match(reg);
```

boot user should be valid.

```js
var reg;
reg = new RegExp("[a-zA-Z0-9]+");
return process.env['SUSSURRO_USER_' + process.env.NODE_ENV].should.match(reg);
```

boot password should be /^([a-zA-Z0-9@*#]{8,20})$/ : Match all alphanumeric character and predefined wild characters. Password must consists of at least 8 characters and not more than 20 characters..

```js
return new Promise(function(resolve) {
  return keychain.getPassword({
    account: process.env['SUSSURRO_USER_' + process.env.NODE_ENV],
    service: 'sussurro.mongodb.' + process.env.NODE_ENV
  }, function(err, pass) {
    var reg;
    reg = new RegExp("^([a-zA-Z0-9@*#]{8,20})$");
    should(pass).match(reg);
    return resolve();
  });
});
```

<a name="configapp"></a>
# config/app
should be disconnected.

```js
return mongoose.connection.readyState.should.is.equal(0);
```

<a name="bootdb"></a>
# boot/db
should be able to connect.

```js
return _sussurro_.connect().then(function(db) {
  return mongoose.connection.readyState.should.be.equal(1);
});
```

should be able to disconnect.

```js
return _sussurro_.disconnect().then(function(readyState) {
  return readyState.should.be.equal(3);
});
```

<a name="appmodelsprofile"></a>
# app/models/profile
should empty Profiles.

```js
return new Promise(function(resolve, reject) {
  Profile.findOne({}).remove().exec();
  return count({}, function(c) {
    c.should.be.equal(0);
    return resolve();
  });
});
```

should create a simple Profile.

```js
return new Promise(function(resolve, reject) {
  return create(profile_test, function(err, profile) {
    profile.save();
    profile.should.have.property('nome_completo');
    profile.should.have.property('nome_artistico');
    firstProfile = profile._id;
    return count({}, function(c) {
      c.should.be.equal(1);
      return resolve();
    });
  });
});
```

<a name="appmodelsbio"></a>
# app/models/bio
should empty Bios.

```js
return new Promise(function(resolve, reject) {
  Bio.find({}).remove().exec();
  return count({}, function(c) {
    c.should.be.equal(0);
    return resolve();
  });
});
```

should create a simple Bio.

```js
return new Promise(function(resolve, reject) {
  return Profile.findOne({}, function(err, profile) {
    return Bio.create(bio_test, function(err, bio) {
      if (!err) {
        bio.profile = profile._id;
        profile.bio = bio._id;
        bio.save();
        profile.save();
        return count({}, function(c) {
          c.should.be.equal(1);
          return resolve();
        });
      } else {
        return reject(err);
      }
    });
  });
});
```

<a name="appmodelslocal"></a>
# app/models/local
should empty Locals.

```js
return new Promise(function(resolve, reject) {
  Local.find({}).remove().exec();
  return count({}, function(c) {
    c.should.be.equal(0);
    return resolve();
  });
});
```

should create a nascimento Local.

```js
return new Promise(function(resolve, reject) {
  return Bio.findOne({}, function(err, bio) {
    return create(locals_test.nascimento, function(err, local) {
      local.bio = bio._id;
      bio.local_de_nascimento = local._id;
      local.tipo = 'nascimento';
      local.save();
      bio.save();
      return count({}, function(c) {
        c.should.be.equal(1);
        return resolve();
      });
    });
  });
});
```

should create a falecimento Local.

```js
return new Promise(function(resolve, reject) {
  return Bio.findOne({}, function(err, bio) {
    locals_test.falecimento.bio = bio._id;
    return create(locals_test.falecimento, function(err, local) {
      local.bio = bio._id;
      bio.local_de_falecimento = local._id;
      local.tipo = 'falecimento';
      local.save();
      bio.save();
      return count({}, function(c) {
        c.should.be.equal(2);
        return resolve();
      });
    });
  });
});
```

<a name="appmodelscontato"></a>
# app/models/contato
should empty Contato.

```js
return new Promise(function(resolve, reject) {
  Contato.find({}).remove().exec();
  return count({}, function(c) {
    c.should.be.equal(0);
    return resolve();
  });
});
```

should create a Contato.

```js
return new Promise(function(resolve, reject) {
  return Contato.create(contato_test, function(err, contato) {
    return Profile.findById(firstProfile, '_id', function(err, profile) {
      if (!err) {
        contato.profile = profile._id;
        profile.contato = contato._id;
        contato.save();
        profile.save();
        return count({}, function(c) {
          c.should.be.equal(1);
          return resolve();
        });
      }
    });
  });
});
```

<a name="appmodelsuser"></a>
# app/models/user
should empty Users.

```js
return new Promise(function(resolve, reject) {
  User.find({}).remove().exec();
  return count({}, function(c) {
    c.should.be.equal(0);
    return resolve();
  });
});
```

should create a simple User.

```js
return new Promise(function(resolve, reject) {
  return Profile.findOne({}, function(err, profile) {
    return create({
      profile: profile._id
    }, function(err, user) {
      if (!err) {
        profile.user = user._id;
        user.profile = profile._id;
        profile.save();
        user.save();
        return count({}, function(c) {
          c.should.be.equal(1);
          return resolve();
        });
      } else {
        return reject(err);
      }
    });
  });
});
```

<a name="appmodelswiki"></a>
# app/models/wiki
should empty Wikis.

```js
return new Promise(function(resolve, reject) {
  Wiki.find({}).remove().exec();
  return count({}, function(c) {
    c.should.be.equal(0);
    return resolve();
  });
});
```

should create a Wiki.

```js
return new Promise(function(resolve, reject) {
  return create(wiki_test, function(err, wiki) {
    if (!err) {
      wiki.save();
    }
    return count({}, function(c) {
      c.should.be.equal(1);
      return resolve();
    });
  });
});
```

<a name="appmodelspost"></a>
# app/models/post
should empty Posts.

```js
return new Promise(function(resolve, reject) {
  Post.find({}).remove().exec();
  return count({}, function(c) {
    c.should.be.equal(0);
    return resolve();
  });
});
```

should create a post.

```js
return new Promise(function(resolve, reject) {
  return Wiki.findOne({}, function(err, wiki) {
    return Profile.findOne({}, function(err2, profile) {
      return create(post_test, function(err, post) {
        if (!err) {
          post.wiki = wiki._id;
          wiki.posts.push(post._id);
          post.author = profile._id;
          profile.posts.push(post._id);
          post.save();
          wiki.save();
          profile.save();
          return count({}, function(c) {
            c.should.be.equal(1);
            should(wiki.posts.length).is.equal(1);
            return resolve();
          });
        }
      });
    });
  });
});
```

should create another post.

```js
return new Promise(function(resolve, reject) {
  return Wiki.findOne({}, function(err, wiki) {
    return Profile.findOne({}, function(err2, profile) {
      return create(post_test, function(err, post) {
        if (!err) {
          post.wiki = wiki._id;
          wiki.posts.push(post._id);
          post.author = profile._id;
          profile.posts.push(post._id);
          post.save();
          wiki.save();
          profile.save();
          return count({}, function(c) {
            c.should.be.equal(2);
            should(wiki.posts.length).is.equal(2);
            return resolve();
          });
        }
      });
    });
  });
});
```

should create a third post.

```js
return new Promise(function(resolve, reject) {
  return Wiki.findOne({}, function(err, wiki) {
    return Profile.findOne({}, function(err2, profile) {
      return create(post_test, function(err, post) {
        if (!err) {
          post.wiki = wiki._id;
          wiki.posts.push(post._id);
          post.author = profile._id;
          profile.posts.push(post._id);
          post.save();
          wiki.save();
          profile.save();
          count({}, function(c) {
            c.should.be.equal(3);
            return should(wiki.posts.length).is.equal(3);
          });
          return resolve();
        }
      });
    });
  });
});
```

<a name="appmodelssession"></a>
# app/models/session
should empty Sessions.

```js
return new Promise(function(resolve, reject) {
  Session.find().remove().exec();
  return count({}, function(c) {
    c.should.be.equal(0);
    return resolve();
  });
});
```

should create a simple Session.

```js
return new Promise(function(resolve, reject) {
  return Profile.findOne({}, function(err, profile) {
    return create({
      profile: profile._id
    }, function(err, session) {
      if (!err) {
        session.profile = profile._id;
        session.save();
        return count({}, function(c) {
          c.should.be.equal(1);
          return resolve();
        });
      } else {
        return reject(err);
      }
    });
  });
});
```

<a name="bootapp"></a>
# boot/app
<a name="appcontrollersprofile"></a>
# app/controllers/profile
should GET /api/profiles.

```js
return request(sussurro.app).get('/api/profiles').expect('Content-Type', /json/).expect(200).expect(function(res) {
  var i, len, profile, ref;
  res.body.should.is.Array();
  ref = res.body;
  for (i = 0, len = ref.length; i < len; i++) {
    profile = ref[i];
    profile.should.have.property('updatedAt');
    profile.should.have.property('nome_artistico');
    profile.should.have.property('nome_completo');
    profile.should.have.property('posts');
  }
  return id1 = res.body[0]._id;
});
```

should POST /api/profiles/create with a form.

```js
return request(sussurro.app).post("/api/profiles/create").query({
  nome_completo: uuid.v4()
}).query({
  nome_artistico: uuid.v4()
}).query({
  email: "gcravista@gmail.com"
}).query({
  telefone: "+5515998006760"
}).query({
  sites: "https://www.github.com/sussurro/sussurro||https://sussurro.github.io/"
}).query({
  redes_sociais: "https://www.facebook.com/sussuro"
}).query({
  nome_completo: uuid.v4()
}).query({
  nome_completo: uuid.v4()
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
  return m.msg.should.be.equal("Email enviado para gcravista@gmail.com");
});
```

should GET /api/profiles get two profiles.

```js
return request(sussurro.app).get('/api/profiles').expect('Content-Type', /json/).expect(200).expect(function(res) {
  res.body.should.be.an.Array();
  res.body.should.be.not.empty();
  res.body.should.have.length(2);
  return id2 = res.body[1]._id;
});
```

should GET /api/profiles/:id(first).

```js
return request(sussurro.app).get('/api/profiles/' + id1).expect('Content-Type', /json/).expect(200).expect(function(res) {
  var profile;
  profile = res.body;
  profile.should.not.have.property('err');
  profile.should.have.property('updatedAt');
  profile.should.have.property('nome_artistico');
  profile.should.have.property('nome_completo');
  return profile.should.have.property('posts');
});
```

should GET /api/profile/:id(second).

```js
return request(sussurro.app).get('/api/profiles/' + id2).expect('Content-Type', /json/).expect(200).expect(function(res) {
  var profile;
  profile = res.body;
  profile.should.not.have.property('err');
  profile.should.have.property('updatedAt');
  profile.should.have.property('nome_artistico');
  profile.should.have.property('nome_completo');
  return profile.should.have.property('posts');
});
```

<a name="appcontrollersbio"></a>
# app/controllers/bio
should GET /api/bios.

```js
return request(sussurro.app).get('/api/bios').expect(200).expect('Content-Type', /application\/json/).expect(function(res) {
  var bio, i, len, ref, results;
  res.body.should.is.Array();
  ref = res.body;
  results = [];
  for (i = 0, len = ref.length; i < len; i++) {
    bio = ref[i];
    bio.should.have.property('updatedAt');
    bio.should.have.property('text');
    bio.should.have.property('local_de_nascimento');
    bio.should.have.property('local_de_falecimento');
    bio.should.have.property('data_de_falecimento');
    results.push(bio.should.have.property('data_de_falecimento'));
  }
  return results;
});
```

should GET /api/bios/:id.

```js
return Bio.find({}, '_id', function(err, bios) {
  var bio, i, len, results;
  results = [];
  for (i = 0, len = bios.length; i < len; i++) {
    bio = bios[i];
    results.push(request(sussurro.app).get('/api/bios/' + bio._id).expect(200).expect('Content-Type', /application\/json/).expect(function(res) {
      bio = res.body;
      bio.should.have.not.property('err');
      bio.should.have.property('text');
      bio.should.have.property('local_de_nascimento');
      bio.should.have.property('local_de_falecimento');
      bio.should.have.property('data_de_falecimento');
      return bio.should.have.property('data_de_falecimento');
    }));
  }
  return results;
});
```

<a name="appcontrollerslocal"></a>
# app/controllers/local
should GET /api/locals.

```js
return request(sussurro.app).get('/api/locals').expect(200).expect('Content-Type', /application\/json/).expect(function(res) {
  var i, len, local, ref, results;
  res.body.should.is.Array();
  ref = res.body;
  results = [];
  for (i = 0, len = ref.length; i < len; i++) {
    local = ref[i];
    local.should.have.not.property('err');
    local.should.have.property('cidade');
    local.should.have.property('estado');
    local.should.have.property('país');
    results.push(local.should.have.property('updatedAt'));
  }
  return results;
});
```

should GET /api/locals/:id.

```js
return Local.find({}, '_id', function(err, locals) {
  var i, len, local, results;
  results = [];
  for (i = 0, len = locals.length; i < len; i++) {
    local = locals[i];
    results.push(request(sussurro.app).get('/api/locals/' + local._id).expect(200).expect('Content-Type', /application\/json/).expect(function(res) {
      local = res.body;
      local.should.have.not.property('err');
      local.should.have.property('cidade');
      local.should.have.property('estado');
      local.should.have.property('país');
      return local.should.have.property('updatedAt');
    }));
  }
  return results;
});
```

<a name="appcontrollerscontato"></a>
# app/controllers/contato
should GET /api/contatos.

```js
return request(sussurro.app).get('/api/contatos').expect(200).expect('Content-Type', /application\/json/).expect(function(res) {
  var contato, i, len, ref, results;
  res.body.should.is.Array();
  ref = res.body;
  results = [];
  for (i = 0, len = ref.length; i < len; i++) {
    contato = ref[i];
    contato.should.have.property('updatedAt');
    contato.should.have.property('email');
    contato.should.have.property('sites');
    results.push(contato.should.have.property('redes_sociais'));
  }
  return results;
});
```

should GET /api/contatos/:id.

```js
return Contato.find({}, '_id', function(err, contatos) {
  var contato, i, len, results;
  results = [];
  for (i = 0, len = contatos.length; i < len; i++) {
    contato = contatos[i];
    results.push(request(sussurro.app).get('/api/contato/' + contato._id).expect(200).expect('Content-Type', /application\/json/).expect(function(res) {
      contato = res.body;
      contato.should.have.not.property('err');
      contato.should.have.property('updatedAt');
      contato.should.have.property('email');
      contato.should.have.property('sites');
      return contato.should.have.property('redes_sociais');
    }));
  }
  return results;
});
```

<a name="appcontrollerswiki"></a>
# app/controllers/wiki
should GET /api/wikis.

```js
return request(sussurro.app).get('/api/wikis').expect(200).expect('Content-Type', /application\/json/).expect(function(res) {
  var i, len, ref, results, wiki;
  res.body.should.is.Array();
  ref = res.body;
  results = [];
  for (i = 0, len = ref.length; i < len; i++) {
    wiki = ref[i];
    wiki.should.have.property('updatedAt');
    wiki.should.have.property('description');
    results.push(wiki.should.have.property('posts'));
  }
  return results;
});
```

should GET /api/wikis/:id.

```js
return Wiki.find({}, '_id', function(err, wikis) {
  var i, len, results, wiki;
  results = [];
  for (i = 0, len = wikis.length; i < len; i++) {
    wiki = wikis[i];
    results.push(request(sussurro.app).get('/api/wikis/' + wiki._id).expect(200).expect('Content-Type', /application\/json/).expect(function(res) {
      wiki = res.body;
      wiki.should.have.not.property('err');
      wiki.should.have.property('updatedAt');
      wiki.should.have.property('description');
      return wiki.should.have.property('posts');
    }));
  }
  return results;
});
```

<a name="appcontrollerspost"></a>
# app/controllers/post
should GET /api/posts.

```js
return request(sussurro.app).get('/api/posts').expect(200).expect('Content-Type', /application\/json/).expect(function(res) {
  var i, len, post, ref, results;
  res.body.should.is.Array();
  ref = res.body;
  results = [];
  for (i = 0, len = ref.length; i < len; i++) {
    post = ref[i];
    post.should.have.property('updatedAt');
    post.should.have.property('text');
    post.should.have.property('title');
    results.push(post.should.have.property('author'));
  }
  return results;
});
```

should GET /api/posts/:id.

```js
return Post.find({}, '_id', function(err, posts) {
  var i, len, post, results;
  results = [];
  for (i = 0, len = posts.length; i < len; i++) {
    post = posts[i];
    results.push(request(sussurro.app).get('/api/posts/' + post._id).expect(200).expect('Content-Type', /application\/json/).expect(function(res) {
      post = res.body;
      post.should.have.not.property('err');
      post.should.have.property('updatedAt');
      post.should.have.property('text');
      post.should.have.property('title');
      return post.should.have.property('author');
    }));
  }
  return results;
});
```

Disconnect from mongodb.

```js
return sussurro.connection.disconnect().then(function(readyState) {
  return readyState.should.be.equal(3);
});
```

==> Sussurro libraries loaded
==> Mongodb helper loaded
==> App helper loaded
==> MongoDB once open loaded
==> Profile schema loaded
==> Bio schema loaded
==> Local schema loaded
==> Contato schema loaded
==> User schema loaded
==> Wiki schema loaded
==> Post schema loaded
==> Session schema loaded
==> App boot helpers loaded
==> Profile controller loaded
==> Bio controller loaded
==> Local controller loaded
==> Contato controller loaded
==> Wiki controller loaded
==> Post controller loaded
==> Index helpers loaded
==> Sussurro ready
==> Sussurro test libraries loaded
==> Config db helpers loaded
==> App config test loaded
==> Boot db test loaded
==> Profile DB test loaded
==> Bio test loaded
==> Local DB test loaded
==> Contato DB test loaded
==> User DB test loaded
==> Wiki DB test loaded
==> Post DB test loaded
==> App boot test loaded
==> Profile app test loaded
==> Bio app test loaded
==> Local app test loaded
==> Contato app test loaded
==> Index app test loaded
==> sussurro database disconnected
==> sussurro data base connected
==> sussurro database disconnected
==> sussurro data base connected
==> sussurro database disconnected
==> sussurro data base connected
==> sussurro database disconnected
==> sussurro data base connected
==> sussurro database disconnected
==> sussurro data base connected
==> sussurro database disconnected
==> sussurro data base connected
==> sussurro database disconnected
==> sussurro data base connected
==> sussurro database disconnected
==> sussurro data base connected
==> sussurro database disconnected
==> sussurro data base connected
==> sussurro database disconnected
==> sussurro data base connected
==> sussurro database disconnected
==> sussurro data base connected
==> sussurro database disconnected
==> sussurro data base connected
==> sussurro database disconnected
==> sussurro data base connected
==> sussurro database disconnected
==> sussurro data base connected
==> sussurro database disconnected
==> sussurro data base connected
==> sussurro database disconnected
==> sussurro data base connected
==> sussurro database disconnected
==> sussurro data base connected
==> sussurro database disconnected
==> sussurro data base connected
==> sussurro database disconnected
==> sussurro data base connected
==> sussurro database disconnected
==> sussurro data base connected
==> sussurro database disconnected
# TOC
   - [config/db](#configdb)
   - [config/app](#configapp)
   - [boot/db](#bootdb)
   - [app/models/profile](#appmodelsprofile)
   - [app/models/bio](#appmodelsbio)
   - [app/models/local](#appmodelslocal)
   - [app/models/contato](#appmodelscontato)
   - [app/models/user](#appmodelsuser)
   - [app/models/wiki](#appmodelswiki)
   - [app/models/post](#appmodelspost)
   - [app/models/session](#appmodelssession)
   - [boot/app](#bootapp)
   - [app/controllers/profile](#appcontrollersprofile)
   - [app/controllers/bio](#appcontrollersbio)
   - [app/controllers/local](#appcontrollerslocal)
   - [app/controllers/contato](#appcontrollerscontato)
   - [app/controllers/wiki](#appcontrollerswiki)
   - [app/controllers/post](#appcontrollerspost)
   - [app/controllers/index](#appcontrollersindex)
<a name=""></a>
 
<a name="configdb"></a>
# config/db
url should be correct.

```js
var reg;
reg = new RegExp("mongodb://([a-z]+):(\d+)/" + process.env['SUSSURRO_COL_' + process.env.NODE_ENV]);
return reg.should.match(reg);
```

boot user should be valid.

```js
var reg;
reg = new RegExp("[a-zA-Z0-9]+");
return process.env['SUSSURRO_USER_' + process.env.NODE_ENV].should.match(reg);
```

boot password should be /^([a-zA-Z0-9@*#]{8,20})$/ : Match all alphanumeric character and predefined wild characters. Password must consists of at least 8 characters and not more than 20 characters..

```js
return new Promise(function(resolve) {
  return keychain.getPassword({
    account: process.env['SUSSURRO_USER_' + process.env.NODE_ENV],
    service: 'sussurro.mongodb.' + process.env.NODE_ENV
  }, function(err, pass) {
    var reg;
    reg = new RegExp("^([a-zA-Z0-9@*#]{8,20})$");
    should(pass).match(reg);
    return resolve();
  });
});
```

<a name="configapp"></a>
# config/app
should be disconnected.

```js
return mongoose.connection.readyState.should.is.equal(0);
```

<a name="bootdb"></a>
# boot/db
should be able to connect.

```js
return _sussurro_.connect().then(function(db) {
  return mongoose.connection.readyState.should.be.equal(1);
});
```

should be able to disconnect.

```js
return _sussurro_.disconnect().then(function(readyState) {
  return readyState.should.be.equal(3);
});
```

<a name="appmodelsprofile"></a>
# app/models/profile
should empty Profiles.

```js
return new Promise(function(resolve, reject) {
  Profile.findOne({}).remove().exec();
  return count({}, function(c) {
    c.should.be.equal(0);
    return resolve();
  });
});
```

should create a simple Profile.

```js
return new Promise(function(resolve, reject) {
  return create(profile_test, function(err, profile) {
    profile.save();
    profile.should.have.property('nome_completo');
    profile.should.have.property('nome_artistico');
    firstProfile = profile._id;
    return count({}, function(c) {
      c.should.be.equal(1);
      return resolve();
    });
  });
});
```

<a name="appmodelsbio"></a>
# app/models/bio
should empty Bios.

```js
return new Promise(function(resolve, reject) {
  Bio.find({}).remove().exec();
  return count({}, function(c) {
    c.should.be.equal(0);
    return resolve();
  });
});
```

should create a simple Bio.

```js
return new Promise(function(resolve, reject) {
  return Profile.findOne({}, function(err, profile) {
    return Bio.create(bio_test, function(err, bio) {
      if (!err) {
        bio.profile = profile._id;
        profile.bio = bio._id;
        bio.save();
        profile.save();
        return count({}, function(c) {
          c.should.be.equal(1);
          return resolve();
        });
      } else {
        return reject(err);
      }
    });
  });
});
```

<a name="appmodelslocal"></a>
# app/models/local
should empty Locals.

```js
return new Promise(function(resolve, reject) {
  Local.find({}).remove().exec();
  return count({}, function(c) {
    c.should.be.equal(0);
    return resolve();
  });
});
```

should create a nascimento Local.

```js
return new Promise(function(resolve, reject) {
  return Bio.findOne({}, function(err, bio) {
    return create(locals_test.nascimento, function(err, local) {
      local.bio = bio._id;
      bio.local_de_nascimento = local._id;
      local.tipo = 'nascimento';
      local.save();
      bio.save();
      return count({}, function(c) {
        c.should.be.equal(1);
        return resolve();
      });
    });
  });
});
```

should create a falecimento Local.

```js
return new Promise(function(resolve, reject) {
  return Bio.findOne({}, function(err, bio) {
    locals_test.falecimento.bio = bio._id;
    return create(locals_test.falecimento, function(err, local) {
      local.bio = bio._id;
      bio.local_de_falecimento = local._id;
      local.tipo = 'falecimento';
      local.save();
      bio.save();
      return count({}, function(c) {
        c.should.be.equal(2);
        return resolve();
      });
    });
  });
});
```

<a name="appmodelscontato"></a>
# app/models/contato
should empty Contato.

```js
return new Promise(function(resolve, reject) {
  Contato.find({}).remove().exec();
  return count({}, function(c) {
    c.should.be.equal(0);
    return resolve();
  });
});
```

should create a Contato.

```js
return new Promise(function(resolve, reject) {
  return Contato.create(contato_test, function(err, contato) {
    return Profile.findById(firstProfile, '_id', function(err, profile) {
      if (!err) {
        contato.profile = profile._id;
        profile.contato = contato._id;
        contato.save();
        profile.save();
        return count({}, function(c) {
          c.should.be.equal(1);
          return resolve();
        });
      }
    });
  });
});
```

<a name="appmodelsuser"></a>
# app/models/user
should empty Users.

```js
return new Promise(function(resolve, reject) {
  User.find({}).remove().exec();
  return count({}, function(c) {
    c.should.be.equal(0);
    return resolve();
  });
});
```

should create a simple User.

```js
return new Promise(function(resolve, reject) {
  return Profile.findOne({}, function(err, profile) {
    return create({
      profile: profile._id
    }, function(err, user) {
      if (!err) {
        profile.user = user._id;
        user.profile = profile._id;
        profile.save();
        user.save();
        return count({}, function(c) {
          c.should.be.equal(1);
          return resolve();
        });
      } else {
        return reject(err);
      }
    });
  });
});
```

<a name="appmodelswiki"></a>
# app/models/wiki
should empty Wikis.

```js
return new Promise(function(resolve, reject) {
  Wiki.find({}).remove().exec();
  return count({}, function(c) {
    c.should.be.equal(0);
    return resolve();
  });
});
```

should create a Wiki.

```js
return new Promise(function(resolve, reject) {
  return create(wiki_test, function(err, wiki) {
    if (!err) {
      wiki.save();
    }
    return count({}, function(c) {
      c.should.be.equal(1);
      return resolve();
    });
  });
});
```

<a name="appmodelspost"></a>
# app/models/post
should empty Posts.

```js
return new Promise(function(resolve, reject) {
  Post.find({}).remove().exec();
  return count({}, function(c) {
    c.should.be.equal(0);
    return resolve();
  });
});
```

should create a post.

```js
return new Promise(function(resolve, reject) {
  return Wiki.findOne({}, function(err, wiki) {
    return Profile.findOne({}, function(err2, profile) {
      return create(post_test, function(err, post) {
        if (!err) {
          post.wiki = wiki._id;
          wiki.posts.push(post._id);
          post.author = profile._id;
          profile.posts.push(post._id);
          post.save();
          wiki.save();
          profile.save();
          return count({}, function(c) {
            c.should.be.equal(1);
            should(wiki.posts.length).is.equal(1);
            return resolve();
          });
        }
      });
    });
  });
});
```

should create another post.

```js
return new Promise(function(resolve, reject) {
  return Wiki.findOne({}, function(err, wiki) {
    return Profile.findOne({}, function(err2, profile) {
      return create(post_test, function(err, post) {
        if (!err) {
          post.wiki = wiki._id;
          wiki.posts.push(post._id);
          post.author = profile._id;
          profile.posts.push(post._id);
          post.save();
          wiki.save();
          profile.save();
          return count({}, function(c) {
            c.should.be.equal(2);
            should(wiki.posts.length).is.equal(2);
            return resolve();
          });
        }
      });
    });
  });
});
```

should create a third post.

```js
return new Promise(function(resolve, reject) {
  return Wiki.findOne({}, function(err, wiki) {
    return Profile.findOne({}, function(err2, profile) {
      return create(post_test, function(err, post) {
        if (!err) {
          post.wiki = wiki._id;
          wiki.posts.push(post._id);
          post.author = profile._id;
          profile.posts.push(post._id);
          post.save();
          wiki.save();
          profile.save();
          count({}, function(c) {
            c.should.be.equal(3);
            return should(wiki.posts.length).is.equal(3);
          });
          return resolve();
        }
      });
    });
  });
});
```

<a name="appmodelssession"></a>
# app/models/session
should empty Sessions.

```js
return new Promise(function(resolve, reject) {
  Session.find().remove().exec();
  return count({}, function(c) {
    c.should.be.equal(0);
    return resolve();
  });
});
```

should create a simple Session.

```js
return new Promise(function(resolve, reject) {
  return Profile.findOne({}, function(err, profile) {
    return create({
      profile: profile._id
    }, function(err, session) {
      if (!err) {
        session.profile = profile._id;
        session.save();
        return count({}, function(c) {
          c.should.be.equal(1);
          return resolve();
        });
      } else {
        return reject(err);
      }
    });
  });
});
```

<a name="bootapp"></a>
# boot/app
should be connect with mongodb.

```js
return sussurro.connection.connect().then(sussurro.configure).then(function(readyState) {
  return readyState.should.be.equal(1);
});
```

<a name="appcontrollersprofile"></a>
# app/controllers/profile
should GET /api/profiles.

```js
return request(sussurro.app).get('/api/profiles').expect('Content-Type', /json/).expect(200).expect(function(res) {
  var k, len, profile, ref;
  res.body.should.is.Array();
  ref = res.body;
  for (k = 0, len = ref.length; k < len; k++) {
    profile = ref[k];
    profile.should.have.property('updatedAt');
    profile.should.have.property('nome_artistico');
    profile.should.have.property('nome_completo');
    profile.should.have.property('posts');
  }
  return id1 = res.body[0]._id;
});
```

should POST /api/profiles/create with a form.

```js
return request(sussurro.app).post("/api/profiles/create").query({
  nome_completo: uuid.v4()
}).query({
  nome_artistico: uuid.v4()
}).query({
  email: "gcravista@gmail.com"
}).query({
  telefone: "+5515998006760"
}).query({
  sites: "https://www.github.com/sussurro/sussurro||https://sussurro.github.io/"
}).query({
  redes_sociais: "https://www.facebook.com/sussuro"
}).query({
  nome_completo: uuid.v4()
}).query({
  nome_completo: uuid.v4()
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
  return m.msg.should.be.equal("Email enviado para gcravista@gmail.com");
});
```

should GET /api/profiles get two profiles.

```js
return request(sussurro.app).get('/api/profiles').expect('Content-Type', /json/).expect(200).expect(function(res) {
  res.body.should.be.an.Array();
  res.body.should.be.not.empty();
  res.body.should.have.length(2);
  return id2 = res.body[1]._id;
});
```

should GET /api/profiles/:id(first).

```js
return request(sussurro.app).get('/api/profiles/' + id1).expect('Content-Type', /json/).expect(200).expect(function(res) {
  var profile;
  profile = res.body;
  profile.should.not.have.property('err');
  profile.should.have.property('updatedAt');
  profile.should.have.property('nome_artistico');
  profile.should.have.property('nome_completo');
  return profile.should.have.property('posts');
});
```

should GET /api/profile/:id(second).

```js
return request(sussurro.app).get('/api/profiles/' + id2).expect('Content-Type', /json/).expect(200).expect(function(res) {
  var profile;
  profile = res.body;
  profile.should.not.have.property('err');
  profile.should.have.property('updatedAt');
  profile.should.have.property('nome_artistico');
  profile.should.have.property('nome_completo');
  return profile.should.have.property('posts');
});
```

<a name="appcontrollersbio"></a>
# app/controllers/bio
should GET /api/bios.

```js
return request(sussurro.app).get('/api/bios').expect(200).expect('Content-Type', /application\/json/).expect(function(res) {
  var bio, k, len, ref, results;
  res.body.should.is.Array();
  ref = res.body;
  results = [];
  for (k = 0, len = ref.length; k < len; k++) {
    bio = ref[k];
    bio.should.have.property('updatedAt');
    bio.should.have.property('text');
    bio.should.have.property('local_de_nascimento');
    bio.should.have.property('local_de_falecimento');
    bio.should.have.property('data_de_falecimento');
    results.push(bio.should.have.property('data_de_falecimento'));
  }
  return results;
});
```

should GET /api/bios/:id.

```js
return Bio.find({}, '_id', function(err, bios) {
  var bio, k, len, results;
  results = [];
  for (k = 0, len = bios.length; k < len; k++) {
    bio = bios[k];
    results.push(request(sussurro.app).get('/api/bios/' + bio._id).expect(200).expect('Content-Type', /application\/json/).expect(function(res) {
      bio = res.body;
      bio.should.have.not.property('err');
      bio.should.have.property('text');
      bio.should.have.property('local_de_nascimento');
      bio.should.have.property('local_de_falecimento');
      bio.should.have.property('data_de_falecimento');
      return bio.should.have.property('data_de_falecimento');
    }));
  }
  return results;
});
```

<a name="appcontrollerslocal"></a>
# app/controllers/local
should GET /api/locals.

```js
return request(sussurro.app).get('/api/locals').expect(200).expect('Content-Type', /application\/json/).expect(function(res) {
  var k, len, local, ref, results;
  res.body.should.is.Array();
  ref = res.body;
  results = [];
  for (k = 0, len = ref.length; k < len; k++) {
    local = ref[k];
    local.should.have.not.property('err');
    local.should.have.property('cidade');
    local.should.have.property('estado');
    local.should.have.property('país');
    results.push(local.should.have.property('updatedAt'));
  }
  return results;
});
```

should GET /api/locals/:id.

```js
return Local.find({}, '_id', function(err, locals) {
  var k, len, local, results;
  results = [];
  for (k = 0, len = locals.length; k < len; k++) {
    local = locals[k];
    results.push(request(sussurro.app).get('/api/locals/' + local._id).expect(200).expect('Content-Type', /application\/json/).expect(function(res) {
      local = res.body;
      local.should.have.not.property('err');
      local.should.have.property('cidade');
      local.should.have.property('estado');
      local.should.have.property('país');
      return local.should.have.property('updatedAt');
    }));
  }
  return results;
});
```

<a name="appcontrollerscontato"></a>
# app/controllers/contato
should GET /api/contatos.

```js
return request(sussurro.app).get('/api/contatos').expect(200).expect('Content-Type', /application\/json/).expect(function(res) {
  var contato, k, len, ref, results;
  res.body.should.is.Array();
  ref = res.body;
  results = [];
  for (k = 0, len = ref.length; k < len; k++) {
    contato = ref[k];
    contato.should.have.property('updatedAt');
    contato.should.have.property('email');
    contato.should.have.property('sites');
    results.push(contato.should.have.property('redes_sociais'));
  }
  return results;
});
```

should GET /api/contatos/:id.

```js
return Contato.find({}, '_id', function(err, contatos) {
  var contato, k, len, results;
  results = [];
  for (k = 0, len = contatos.length; k < len; k++) {
    contato = contatos[k];
    results.push(request(sussurro.app).get('/api/contato/' + contato._id).expect(200).expect('Content-Type', /application\/json/).expect(function(res) {
      contato = res.body;
      contato.should.have.not.property('err');
      contato.should.have.property('updatedAt');
      contato.should.have.property('email');
      contato.should.have.property('sites');
      return contato.should.have.property('redes_sociais');
    }));
  }
  return results;
});
```

<a name="appcontrollerswiki"></a>
# app/controllers/wiki
should GET /api/wikis.

```js
return request(sussurro.app).get('/api/wikis').expect(200).expect('Content-Type', /application\/json/).expect(function(res) {
  var k, len, ref, results, wiki;
  res.body.should.is.Array();
  ref = res.body;
  results = [];
  for (k = 0, len = ref.length; k < len; k++) {
    wiki = ref[k];
    wiki.should.have.property('updatedAt');
    wiki.should.have.property('description');
    results.push(wiki.should.have.property('posts'));
  }
  return results;
});
```

should GET /api/wikis/:id.

```js
return Wiki.find({}, '_id', function(err, wikis) {
  var k, len, results, wiki;
  results = [];
  for (k = 0, len = wikis.length; k < len; k++) {
    wiki = wikis[k];
    results.push(request(sussurro.app).get('/api/wikis/' + wiki._id).expect(200).expect('Content-Type', /application\/json/).expect(function(res) {
      wiki = res.body;
      wiki.should.have.not.property('err');
      wiki.should.have.property('updatedAt');
      wiki.should.have.property('description');
      return wiki.should.have.property('posts');
    }));
  }
  return results;
});
```

<a name="appcontrollerspost"></a>
# app/controllers/post
should GET /api/posts.

```js
return request(sussurro.app).get('/api/posts').expect(200).expect('Content-Type', /application\/json/).expect(function(res) {
  var k, len, post, ref, results;
  res.body.should.is.Array();
  ref = res.body;
  results = [];
  for (k = 0, len = ref.length; k < len; k++) {
    post = ref[k];
    post.should.have.property('updatedAt');
    post.should.have.property('text');
    post.should.have.property('title');
    results.push(post.should.have.property('author'));
  }
  return results;
});
```

should GET /api/posts/:id.

```js
return Post.find({}, '_id', function(err, posts) {
  var k, len, post, results;
  results = [];
  for (k = 0, len = posts.length; k < len; k++) {
    post = posts[k];
    results.push(request(sussurro.app).get('/api/posts/' + post._id).expect(200).expect('Content-Type', /application\/json/).expect(function(res) {
      post = res.body;
      post.should.have.not.property('err');
      post.should.have.property('updatedAt');
      post.should.have.property('text');
      post.should.have.property('title');
      return post.should.have.property('author');
    }));
  }
  return results;
});
```

<a name="appcontrollersindex"></a>
# app/controllers/index
should welcome GET /.

```js
return request(sussurro.app).get('/').expect(200).expect('Content-Type', /json/).expect(function(res) {
  var k, len, ref, results, wiki;
  res.body.should.have.property('flash').which.is.equal(false);
  res.body.should.have.property('msg', '');
  res.body.should.have.property('wikis');
  res.body.wikis.should.be.Array();
  ref = res.body.wikis;
  results = [];
  for (k = 0, len = ref.length; k < len; k++) {
    wiki = ref[k];
    wiki.should.have.property('posts');
    results.push(wiki.posts.should.be.Array());
  }
  return results;
});
```

Disconnect from mongodb.

```js
return sussurro.connection.disconnect().then(function(readyState) {
  return readyState.should.be.equal(3);
});
```

