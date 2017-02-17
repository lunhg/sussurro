
/* MAIN LIBRARIES */
var App, Bio, BioSchema, Contato, ContatoSchema, GithubCloudStrategy, Local, LocalSchema, LocalStrategy, MongoStore, Post, PostSchema, Profile, ProfileSchema, Session, SessionSchema, SoundCloudStrategy, SussurroConn, User, UserSchema, Wiki, WikiSchema, _schema, bio_test, bios, bodyParser, chalk, cheerio, compression, connectAssets, contato_test, contatos, cookieParser, crypto, each, express, favicon, firstProfile, fs, generatePassword, keychain, locals, locals_test, logger, mailgun_transport, marked, mongoose, nodemailer, onValidate, passport, path, post_test, posts, profile_test, profiles, request, roles, session, should, sussurro, timestamps, uuid, validateLocalStrategyPassword, validateLocalStrategyProperty, wiki_test, wikis;

fs = require('fs');

connectAssets = require("connect-assets");

compression = require("compression");

chalk = require('chalk');

crypto = require('crypto');

each = require('foreach');

express = require('express');

session = require('express-session');

mongoose = require('mongoose').set('debug', false);

MongoStore = require('connect-mongo')(session);

timestamps = require('mongoose-timestamp');

passport = require('passport');

path = require('path');

favicon = require('serve-favicon');

logger = require('morgan');

cookieParser = require('cookie-parser');

bodyParser = require('body-parser');

SoundCloudStrategy = require('passport-soundcloud').Strategy;

GithubCloudStrategy = require('passport-github').Strategy;

LocalStrategy = require('passport-local').Strategy;

marked = require('jstransformer-marked');

nodemailer = require('nodemailer');

uuid = require('node-uuid');

generatePassword = require("password-generator");

mailgun_transport = require('nodemailer-mailgun-transport');

roles = require('mongoose-role');

keychain = require('xkeychain');

console.log(chalk.yellow("==> Sussurro libraries loaded"));

process.env.NODE_ENV = process.env.NODE_ENV || 'DEV';


/* Database connection */

SussurroConn = (function() {
  function SussurroConn() {}

  SussurroConn.prototype.connect = function() {
    return new Promise(function(resolve, reject) {
      var key, mdb;
      key = {
        account: process.env['SUSSURRO_USER_' + process.env.NODE_ENV],
        service: 'sussurro.mongodb.' + process.env.NODE_ENV
      };
      mdb = {
        host: process.env['SUSSURRO_HOST_' + process.env.NODE_ENV],
        port: process.env['SUSSURRO_PORT_' + process.env.NODE_ENV],
        db: process.env['SUSSURRO_COL_' + process.env.NODE_ENV]
      };
      return keychain.getPassword(key, function(err, pass) {
        return mongoose.connect("mongodb://" + mdb.host + ":" + mdb.port + "/" + mdb.db, {
          user: key.account,
          pwd: pass,
          uri_decode_auth: true
        }, function(error, db) {
          if (error) {
            return reject(error);
          } else {
            return resolve(mongoose.connection.readyState);
          }
        });
      });
    });
  };

  SussurroConn.prototype.disconnect = function(callback) {
    return new Promise(function(resolve, reject) {
      mongoose.disconnect();
      return resolve(mongoose.connection.readyState);
    });
  };

  return SussurroConn;

})();

console.log(chalk.yellow("==> Mongodb helper loaded"));

App = (function() {
  function App() {
    this.connection = new SussurroConn();
    this.isConnected = false;
    this.isConfigured = false;
    this.app = express();
  }

  return App;

})();

console.log(chalk.yellow("==> App helper loaded"));


/* MONGODB ON CONNECTION */

mongoose.connection.once('open', function() {
  mongoose.connection.on('connected', function() {
    return console.log(chalk.yellow("==> sussurro data base connected"));
  });
  mongoose.connection.on('disconnected', function() {
    return console.log(chalk.cyan("==> sussurro database disconnected"));
  });
  mongoose.connection.on('reconnected', function() {
    return console.log(chalk.cyan("==> sussurro database reconnected"));
  });
  return mongoose.connection.on('error', function(err) {
    return console.log(chalk.red(err.stack));
  });
});

console.log(chalk.yellow("==> MongoDB once open loaded"));


/* Profile Model */

ProfileSchema = new mongoose.Schema({
  nome_completo: {
    type: String,
    required: true
  },
  nome_artistico: {
    type: String,
    required: true
  },
  bio: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Bio'
  },
  contato: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Contato'
  },
  user: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User'
  },
  posts: [
    {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Post'
    }
  ]
});

ProfileSchema.plugin(timestamps);

ProfileSchema.methods.hasUser = function(data) {
  var stringer, user;
  user = new User(data);
  user.save();
  stringer = function(p) {
    var readMsg;
    readMsg = fs.readFileSync(p);
    readMsg = readMsg.replace(/\{\{nome}\}/, this.nome_completo);
    readMsg = readMsg.replace(/\{\{_id}\}/, this._id);
    readMsg = readMsg.replace(/\{\{token}\}/, user.token);
    return readMsg;
  };
  return Contato.findOne({
    profile: this.profile._id
  }, (function(_this) {
    return function(err, contato) {
      var p;
      if (!err) {
        p = path.join(__dirname, '..', 'mailers/default.html');
        user.sendMail({
          to: contato.email,
          msg: stringer(p)
        });
        return callback(null, user._id);
      } else {
        return callback(err);
      }
    };
  })(this));
};

mongoose.model('Profile', ProfileSchema);

Profile = mongoose.model('Profile');

console.log(chalk.yellow("==> " + Profile.modelName + " schema loaded"));


/* Bio Model */

_schema = {
  profile: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Profile'
  },
  data_de_nascimento: {
    type: Date,
    required: true
  },
  local_de_nascimento: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Local'
  },
  data_de_falecimento: {
    type: Date
  },
  local_de_falecimento: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Local'
  },
  text: {
    type: String,
    required: true
  }
};

BioSchema = new mongoose.Schema(_schema);

BioSchema.plugin(timestamps);

mongoose.model('Bio', BioSchema);

Bio = mongoose.model('Bio');

console.log(chalk.yellow("==> " + Bio.modelName + " schema loaded"));


/* Local Model */

LocalSchema = new mongoose.Schema({
  bio: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Bio'
  },
  tipo: String,
  cidade: String,
  estado: String,
  "país": String
});

LocalSchema.plugin(timestamps);

mongoose.model('Local', LocalSchema);

Local = mongoose.model('Local');

console.log(chalk.yellow("==> " + Local.modelName + " schema loaded"));


/* Contato Model */

validateLocalStrategyProperty = function(property) {
  return (this.provider !== 'local' && !this.updated) || property.length;
};

ContatoSchema = new mongoose.Schema({
  profile: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Profile'
  },
  sites: String,
  redes_sociais: String,
  'referências': String,
  email: {
    type: String,
    trim: true,
    "default": '',
    unique: true,
    validate: [validateLocalStrategyProperty, 'Please fill in your email'],
    match: [new RegExp(".+\@.+\..+"), 'Please fill a valid email address']
  },
  telefone: String
});

ContatoSchema.plugin(timestamps);

onValidate = function(value, done) {
  return Contato.count({
    email: value
  }, function(err, count) {
    if (err) {
      return done(err);
    } else {
      return done(!count);
    }
  });
};

ContatoSchema.path('email').validate(onValidate, 'Email already exists');

mongoose.model('Contato', ContatoSchema);

Contato = mongoose.model('Contato');

console.log(chalk.yellow("==> " + Contato.modelName + " schema loaded"));


/* User Model: http://stackoverflow.com/questions/30416170/how-to-perform-a-mongoose-validate-function-only-for-create-user-page-and-not-edA Validation function for local strategy properties */

validateLocalStrategyPassword = function(password) {
  return this.provider !== 'local' || (password && password.length > 6);
};

UserSchema = new mongoose.Schema({
  profile: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Profile'
  },
  password: {
    type: String,
    validate: [validateLocalStrategyPassword, 'Password should be longer']
  },
  salt: String,
  isActive: Boolean,
  token: String,
  mailSent: Boolean
});

UserSchema.plugin(timestamps);

UserSchema.pre('save', function(next) {
  if (!this.password) {
    this.password = uuid.v4();
  }
  if (this.password.length > 6) {
    this.salt = new Buffer(crypto.randomBytes(16).toString('base64'), 'base64');
    this.password = this.hashPassword(this.password);
    this.token = uuid.v4();
    this.isActive = false;
    this.mailSent = false;
  }
  return next();
});

UserSchema.methods.hashPassword = function(password) {
  if (this.salt && password) {
    return crypto.pbkdf2Sync(password, this.salt, 10000, 64).toString('base64');
  } else {
    return password;
  }
};

UserSchema.methods.authenticate = function(password) {
  return this.password === this.hashPassword(password);
};

UserSchema.methods.sendMail = function(mail, callback) {
  console.log("===> sending email to " + mail.to + "...");
  mail.from = MAILBOT;
  return mailer.sendMail(mail, (function(_this) {
    return function(err, info) {
      if (err) {
        return console.log(chalk.red(err));
      } else {
        _this.mailSent = true;
        return console.log(chalk.yellow(info));
      }
    };
  })(this));
};

mongoose.model('User', UserSchema);

User = mongoose.model('User');

console.log(chalk.yellow("==> " + User.modelName + " schema loaded"));


/*  Wiki Model */

WikiSchema = new mongoose.Schema({
  name: String,
  description: String,
  posts: [
    {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Posts'
    }
  ]
});

WikiSchema.plugin(timestamps);

mongoose.model('Wiki', WikiSchema);

Wiki = mongoose.model('Wiki');

console.log(chalk.yellow("==> " + Wiki.modelName + " schema loaded"));


/* Post model */

PostSchema = new mongoose.Schema({
  title: String,
  text: String,
  ref: String,
  author: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Profile'
  },
  wiki: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Wiki'
  }
});

PostSchema.plugin(timestamps);

mongoose.model('Post', PostSchema);

Post = mongoose.model('Post');

console.log(chalk.yellow("==> " + Post.modelName + " schema loaded"));

SessionSchema = new mongoose.Schema({
  pass: String,
  salt: String,
  profile: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Profile'
  }
});

SessionSchema.plugin(timestamps);

SessionSchema.pre('save', function(next) {
  if (!this.pass) {
    this.pass = uuid.v4();
  }
  if (this.pass.length > 6) {
    this.salt = new Buffer(crypto.randomBytes(16).toString('base64'), 'base64');
    this.pass = crypto.pbkdf2Sync(this.pass, this.salt, 10000, 64).toString('base64');
  }
  return next();
});

mongoose.model('Session', SessionSchema);

Session = mongoose.model('Session');

console.log(chalk.yellow("==> " + Session.modelName + " schema loaded"));

sussurro = new App();

App.prototype.configure = function(readyState) {
  this.app.set('views', path.join(__dirname, '..', 'app/views/'));
  this.app.engine('pug', function(file_path, options, _callback) {
    return fs.readFile(file_path, 'utf8', function(err, content) {
      var fn;
      if (err) {
        _callback(err);
      }
      fn = require('pug').compile(content, {
        filename: file_path,
        doctype: 'html'
      });
      return _callback(null, fn({
        filters: [marked]
      }));
    });
  });
  this.app.set('view engine', 'pug');
  this.app.set('img path', path.join(__dirname, '..', 'app/assets/img'));
  this.app.set('css path', path.join(__dirname, '..', 'app/assets/css'));
  this.app.set('js path', path.join(__dirname, '..', 'app/assets/js'));
  this.app.set('favicon path', path.join(__dirname, '..', 'app/assets/favicon.ico'));
  this.app.use(function(req, res, next) {
    return res.on('finish', function() {
      var color, encoding, msg;
      color = this.statusCode !== '200' ? chalk.red : chalk.green;
      msg = color(this.statusCode) + ' ' + req.originalUrl;
      encoding = this._headers && this._headers['content-encoding'];
      if (encoding) {
        msg += chalk.gray(' (' + encoding + ')');
        console.log(msg);
      }
      return next();
    });
  });
  this.app.use(favicon(this.app.get('favicon path')));
  this.app.use(compression());
  this.app.use(bodyParser.json());
  this.app.use(bodyParser.urlencoded({
    extended: false
  }));
  this.app.use(connectAssets({
    paths: [this.app.get('img path'), this.app.get('css path'), this.app.get('js path')]
  }));
  return Session.findOne({}, (function(_this) {
    return function(err, _session) {
      return _this.app.use(session({
        secret: _session.pass,
        maxAge: new Date(Date.now() + 3600000),
        store: new MongoStore({
          mongooseConnection: mongoose.connection
        }),
        saveUninitialized: true,
        resave: false
      }));
    };
  })(this));
};

console.log(chalk.yellow("==> App boot helpers loaded"));

profiles = {};


/* GET /api/profiles */

profiles.index = function(req, res) {
  var allowed;
  allowed = 'id nome_completo nome_artistico posts updatedAt';
  return Profile.find({}, allowed, function(err, profiles) {
    if ((err || !err) && !profiles) {
      res.status(404);
      console.log(chalk.red(err));
      return res.json({
        error: err
      });
    } else {
      if (profiles) {
        res.status(200);
        return res.json(profiles);
      } else {
        res.status(404);
        return res.json({
          error: "profiles is a " + (typeof profiles)
        });
      }
    }
  });
};


/* POST /api/profiles/new */

profiles.create = function(req, res) {
  var _local, bio, contato, i, j, kv, len, len1, local, profile, ref, ref1, user, v;
  profile = new Profile({
    nome_completo: req.query.nome_completo,
    nome_artistico: req.query.nome_artistico
  });
  profile.save();
  contato = new Contato({
    email: req.query.email,
    telefone: req.query.telefone,
    sites: req.query.sites.split("||"),
    redes_sociais: req.query.redes_sociais.split("||"),
    profile: profile._id
  });
  contato.profile = profile._id;
  contato.save();
  profile.contato = contato._id;
  profile.save();
  bio = new Bio({
    profile: profile._id,
    text: req.query.bio
  });
  bio.save();
  ref = 'nascimento falecimento'.split(' ');
  for (i = 0, len = ref.length; i < len; i++) {
    local = ref[i];
    if (req.query['local_de_' + local]) {
      _local = new Local();
      _local.tipo = local;
      ref1 = req.query['local_de_' + local].split("||");
      for (j = 0, len1 = ref1.length; j < len1; j++) {
        v = ref1[j];
        kv = v.split(":");
        _local[kv[0]] = kv[1];
      }
      _local.save();
      _local.bio = bio._id;
      bio['local_de_' + local] = _local._id;
    }
    if (req.query['data_de_' + local]) {
      console.log(local);
      bio['data_de_' + local] = req.query['data_de_' + local];
      bio.save();
    }
  }
  user = new User({
    profile: profile._id
  });
  user.save();
  res.status(201);
  return res.json({
    msg: "Email enviado para " + contato.email
  });
};


/* GET /api/profile/:id */

profiles.profile = function(req, res) {
  var query;
  query = mongoose.Schema.Types.ObjectId(req.params.id);
  return Profile.findOne(query, 'nome_completo nome_artistico posts updatedAt', function(err, profile) {
    if (!err) {
      res.status(200);
      return res.json(profile);
    } else {
      return res.json({
        err: err,
        status: 404
      });
    }
  });
};


/* Some helper */

profiles.id = function(req, res, next, id) {
  req.params.id = id;
  return next();
};

console.log(chalk.yellow("==> Profile controller loaded"));

bios = {};


/* GET /api/bios */

bios.index = function(req, res) {
  return Bio.find({}, req.fields, function(err, bios) {
    if (!err) {
      res.status(200);
      return res.json(bios);
    } else {
      res.status(404);
      return res.json({
        err: err
      });
    }
  });
};


/* GET /api/bio/:bid */

bios.bio = function(req, res) {
  if (mongoose.Types.ObjectId.isValid(req.params.bio_id)) {
    return Bio.findById(mongoose.Types.ObjectId(req.params.bio_id), function(err, bio) {
      if (!err) {
        res.status(200);
        return res.json(bio);
      } else {
        res.status(404);
        return res.json({
          err: err
        });
      }
    });
  } else {
    return res.json({
      err: "id " + req.params.bio_id + " isnt valid"
    });
  }
};


/* /api/bio helper */

bios.id = function(req, res, next, id) {
  req.params.bio_id = id;
  req.fields = 'updatedAt text local_de_nascimento local_de_falecimento data_de_nascimento data_de_falecimento';
  return next();
};

console.log(chalk.yellow("==> Bio controller loaded"));

locals = {};


/* GET /api/locals */

locals.index = function(req, res) {
  return Local.find({}, 'updatedAt cidade estado país', function(err, locals) {
    if (!err) {
      res.status(200);
      return res.json(locals);
    } else {
      res.status(404);
      return res.json({
        err: err
      });
    }
  });
};


/* GET /api/local/:bid */

locals.local = function(req, res) {
  if (mongoose.Types.ObjectId.isValid(req.params.local_id)) {
    return Local.findById(mongoose.Types.ObjectId(req.params.local_id), function(err, local) {
      if (!err) {
        res.status(200);
        return res.json(local);
      } else {
        res.status(404);
        return res.json({
          err: err
        });
      }
    });
  } else {
    return res.json({
      err: "id " + req.params.local_id + " isnt valid"
    });
  }
};


/* /api/local helper */

locals.id = function(req, res, next, id) {
  req.params.local_id = id;
  return next();
};

console.log(chalk.yellow("==> Local controller loaded"));

contatos = {};


/* GET /api/contatos */

contatos.index = function(req, res) {
  return Contato.find({}, 'email redes_sociais sites updatedAt', function(err, contatos) {
    if (!err) {
      res.status(200);
      return res.json(contatos);
    } else {
      res.status(404);
      return res.json({
        err: err
      });
    }
  });
};


/* GET /api/contato/:cid */

contatos.contato = function(req, res) {
  if (mongoose.Types.ObjectId.isValid(req.params.contact_id)) {
    return Contato.findById(mongoose.Types.ObjectId(req.params.contact_id), function(err, contato) {
      if (!err) {
        res.status(200);
        return res.json(contato);
      } else {
        res.status(404);
        return res.json({
          err: err
        });
      }
    });
  } else {
    return res.json({
      err: "id " + req.params.contatct_id + " isnt valid"
    });
  }
};


/* /api/contato helper */

contatos.id = function(req, res, next, id) {
  req.params.contact_id = id;
  return next();
};

console.log(chalk.yellow("==> Contato controller loaded"));

wikis = {};


/* GET /api/wikis */

wikis.index = function(req, res) {
  return Wiki.find({}, 'updatedAt name description posts', function(err, wikis) {
    if (!err) {
      res.status(200);
      return res.json(wikis);
    } else {
      res.status(404);
      return res.json({
        err: err
      });
    }
  });
};


/* GET /api/wiki/:bid */

wikis.wiki = function(req, res) {
  if (mongoose.Types.ObjectId.isValid(req.params.wiki_id)) {
    return Wiki.findById(mongoose.Types.ObjectId(req.params.wiki_id), function(err, wiki) {
      if (!err) {
        res.status(200);
        return res.json(wiki);
      } else {
        res.status(404);
        return res.json({
          err: err
        });
      }
    });
  } else {
    return res.json({
      err: "id " + req.params.wiki_id + " isnt valid"
    });
  }
};


/* /api/wiki helper */

wikis.id = function(req, res, next, id) {
  req.params.wiki_id = id;
  return next();
};

console.log(chalk.yellow("==> Wiki controller loaded"));

posts = {};


/* GET /api/posts */

posts.index = function(req, res) {
  return Post.find({}, 'updatedAt title text author', function(err, posts) {
    if (!err) {
      res.status(200);
      return res.json(posts);
    } else {
      res.status(404);
      return res.json({
        err: err
      });
    }
  });
};


/* GET /api/post/:bid */

posts.post = function(req, res) {
  if (mongoose.Types.ObjectId.isValid(req.params.post_id)) {
    return Post.findById(mongoose.Types.ObjectId(req.params.post_id), function(err, post) {
      if (!err) {
        res.status(200);
        return res.json(post);
      } else {
        res.status(404);
        return res.json({
          err: err
        });
      }
    });
  } else {
    return res.json({
      err: "id " + req.params.post_id + " isnt valid"
    });
  }
};


/* /api/post helper */

posts.id = function(req, res, next, id) {
  req.params.post_id = id;
  return next();
};

console.log(chalk.yellow("==> Post controller loaded"));


/* ROUTES */

sussurro.app.param('id', profiles.id);

sussurro.app.param('contact_id', contatos.id);

sussurro.app.param('bio_id', contatos.id);

sussurro.app.param('local_id', locals.id);


/* Start app */

sussurro.app.param('wiki_id', wikis.id);

sussurro.app.param('post_id', posts.id);


/* Welcome */

sussurro.app.get('/', function(req, res) {
  return res.render('index');
});


/* Profiles */

sussurro.app.get("/api/profiles", profiles.index);

sussurro.app.get("/api/profiles/:id", profiles.profile);

sussurro.app.post("/api/profiles/create", profiles.create);


/* Contatos */

sussurro.app.get("/api/contatos", contatos.index);

sussurro.app.get("/api/contatos/:contact_id", contatos.contato);


/* Bio */

sussurro.app.get("/api/bios", bios.index);

sussurro.app.get("/api/bios/:bio_id", bios.bio);


/* Local */

sussurro.app.get("/api/locals", locals.index);

sussurro.app.get("/api/locals/:local_id", locals.local);


/* Wiki */

sussurro.app.get("/api/wikis", wikis.index);

sussurro.app.get("/api/contatos/:wiki_id", wikis.wiki);


/* Bio */

sussurro.app.get("/api/posts", posts.index);

sussurro.app.get("/api/posts/:posts_id", posts.post);

console.log(chalk.cyan("==> Sussurro ready"));


/* TEST LIBRARIES */

cheerio = require('cheerio');

should = require('should');

request = require('supertest');

profile_test = {
  nome_completo: uuid.v4(),
  nome_artistico: uuid.v4()
};

bio_test = {
  data_de_nascimento: Date.now(),
  text: uuid.v4(),
  data_de_falecimento: Date.now()
};

locals_test = {
  nascimento: {
    cidade: uuid.v4(),
    estado: uuid.v4(),
    "país": uuid.v4()
  },
  falecimento: {
    cidade: uuid.v4(),
    estado: uuid.v4(),
    "país": uuid.v4()
  }
};

contato_test = {
  redes_sociais: ['https://www.facebook.com/' + uuid.v4(), 'https://www.twitter.com/' + uuid.v4()],
  email: uuid.v4() + "@" + uuid.v4() + ".net",
  telefone: "+12912345678",
  sites: ['https://www.' + uuid.v4() + '.net', 'https://www.' + uuid.v4() + '.net']
};

wiki_test = {
  name: uuid.v4(),
  description: uuid.v4()
};

post_test = {
  title: uuid.v4(),
  text: uuid.v4()
};

console.log(chalk.yellow("==> Sussurro test libraries loaded"));

describe(chalk.green("config/db"), function() {
  it("url should be correct", function() {
    var reg;
    reg = new RegExp("mongodb://([a-z]+):(\d+)/" + process.env['SUSSURRO_COL_' + process.env.NODE_ENV]);
    return reg.should.match(reg);
  });
  it('boot user should be valid', function() {
    var reg;
    reg = new RegExp("[a-zA-Z0-9]+");
    return process.env['SUSSURRO_USER_' + process.env.NODE_ENV].should.match(reg);
  });
  return it('boot password should be /^([a-zA-Z0-9@*#]{8,20})$/ : Match all alphanumeric character and predefined wild characters. Password must consists of at least 8 characters and not more than 20 characters.', function() {
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
  });
});

console.log(chalk.yellow("==> Config db helpers loaded"));

describe(chalk.green("config/app"), function() {
  return it('should be disconnected', function() {
    return mongoose.connection.readyState.should.is.equal(0);
  });
});

console.log(chalk.yellow("==> App config test loaded"));

describe(chalk.green('boot/db'), function() {
  var _sussurro_;
  _sussurro_ = new SussurroConn();
  it('should be able to connect', function() {
    return _sussurro_.connect().then(function(db) {
      return mongoose.connection.readyState.should.be.equal(1);
    });
  });
  return it('should be able to disconnect', function() {
    return _sussurro_.disconnect().then(function(readyState) {
      return readyState.should.be.equal(3);
    });
  });
});

console.log(chalk.yellow("==> Boot db test loaded"));

firstProfile = null;

describe(chalk.green("app/models/profile"), function() {
  var _sussurro_, count, create;
  count = function(query, callback) {
    return mongoose.model('Profile').count(query, function(err, count) {
      return callback(count);
    });
  };
  create = function(data, callback) {
    return mongoose.model('Profile').create(data, function(err, profile) {
      if (!err) {
        return callback(null, profile);
      } else {
        return callback(err);
      }
    });
  };
  _sussurro_ = new SussurroConn();
  beforeEach(function() {
    return _sussurro_.connect().then(function(db) {
      return mongoose.connection.readyState.should.be.equal(1);
    });
  });
  afterEach(function() {
    return _sussurro_.disconnect().then(function(readyState) {
      return readyState.should.be.equal(3);
    });
  });
  it('should empty Profiles', function() {
    return new Promise(function(resolve, reject) {
      Profile.findOne({}).remove().exec();
      return count({}, function(c) {
        c.should.be.equal(0);
        return resolve();
      });
    });
  });
  return it("should create a simple Profile", function() {
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
  });
});

console.log(chalk.yellow("==> Profile DB test loaded"));

describe(chalk.green("app/models/bio"), function() {
  var _sussurro_, count, create;
  count = function(query, callback) {
    return mongoose.model('Bio').count(query, function(err, count) {
      return callback(count);
    });
  };
  create = function(data, callback) {
    return mongoose.model('Bio').create(data, function(err, profile) {
      if (!err) {
        return callback(null, profile);
      } else {
        return callback(err);
      }
    });
  };
  _sussurro_ = new SussurroConn();
  beforeEach(function() {
    return _sussurro_.connect().then(function(db) {
      return mongoose.connection.readyState.should.be.equal(1);
    });
  });
  afterEach(function() {
    return _sussurro_.disconnect().then(function(readyState) {
      return readyState.should.be.equal(3);
    });
  });
  it('should empty Bios', function() {
    return new Promise(function(resolve, reject) {
      Bio.find({}).remove().exec();
      return count({}, function(c) {
        c.should.be.equal(0);
        return resolve();
      });
    });
  });
  return it("should create a simple Bio", function() {
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
  });
});

console.log(chalk.yellow("==> Bio test loaded"));

describe(chalk.green("app/models/local"), function() {
  var _sussurro_, count, create;
  count = function(query, callback) {
    return mongoose.model('Local').count(query, function(err, count) {
      return callback(count);
    });
  };
  create = function(data, callback) {
    return mongoose.model('Local').create(data, function(err, profile) {
      if (!err) {
        return callback(null, profile);
      } else {
        return callback(err);
      }
    });
  };
  _sussurro_ = new SussurroConn();
  beforeEach(function() {
    return _sussurro_.connect().then(function(db) {
      return mongoose.connection.readyState.should.be.equal(1);
    });
  });
  afterEach(function() {
    return _sussurro_.disconnect().then(function(readyState) {
      return readyState.should.be.equal(3);
    });
  });
  it('should empty Locals', function() {
    return new Promise(function(resolve, reject) {
      Local.find({}).remove().exec();
      return count({}, function(c) {
        c.should.be.equal(0);
        return resolve();
      });
    });
  });
  it("should create a nascimento Local", function() {
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
  });
  return it("should create a falecimento Local", function() {
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
  });
});

console.log(chalk.yellow("==> Local DB test loaded"));

describe(chalk.green("app/models/contato"), function() {
  var _sussurro_, count, create;
  count = function(query, callback) {
    return mongoose.model('Contato').count(query, function(err, count) {
      return callback(count);
    });
  };
  create = function(data, callback) {
    return mongoose.model('Contato').create(data, function(err, profile) {
      if (!err) {
        return callback(null, profile);
      } else {
        return callback(err);
      }
    });
  };
  _sussurro_ = new SussurroConn();
  beforeEach(function() {
    return _sussurro_.connect().then(function(db) {
      return mongoose.connection.readyState.should.be.equal(1);
    });
  });
  afterEach(function() {
    return _sussurro_.disconnect().then(function(readyState) {
      return readyState.should.be.equal(3);
    });
  });
  it('should empty Contato', function() {
    return new Promise(function(resolve, reject) {
      Contato.find({}).remove().exec();
      return count({}, function(c) {
        c.should.be.equal(0);
        return resolve();
      });
    });
  });
  return it("should create a Contato", function() {
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
  });
});

console.log(chalk.yellow("==> Contato DB test loaded"));

describe(chalk.green("app/models/user"), function() {
  var _sussurro_, count, create;
  count = function(query, callback) {
    return mongoose.model('User').count(query, function(err, count) {
      return callback(count);
    });
  };
  create = function(data, callback) {
    return mongoose.model('User').create(data, function(err, profile) {
      if (!err) {
        return callback(null, profile);
      } else {
        return callback(err);
      }
    });
  };
  _sussurro_ = new SussurroConn();
  beforeEach(function() {
    return _sussurro_.connect().then(function(db) {
      return mongoose.connection.readyState.should.be.equal(1);
    });
  });
  afterEach(function() {
    return _sussurro_.disconnect().then(function(readyState) {
      return readyState.should.be.equal(3);
    });
  });
  it('should empty Users', function() {
    return new Promise(function(resolve, reject) {
      User.find({}).remove().exec();
      return count({}, function(c) {
        c.should.be.equal(0);
        return resolve();
      });
    });
  });
  return it("should create a simple User", function() {
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
  });
});

console.log(chalk.yellow("==> User DB test loaded"));

describe(chalk.green("app/models/wiki"), function() {
  var _sussurro_, count, create;
  count = function(query, callback) {
    return mongoose.model('Wiki').count(query, function(err, count) {
      return callback(count);
    });
  };
  create = function(data, callback) {
    return mongoose.model('Wiki').create(data, function(err, wiki) {
      if (!err) {
        return callback(null, wiki);
      } else {
        return callback(err);
      }
    });
  };
  _sussurro_ = new SussurroConn();
  beforeEach(function() {
    return _sussurro_.connect().then(function(db) {
      return mongoose.connection.readyState.should.be.equal(1);
    });
  });
  afterEach(function() {
    return _sussurro_.disconnect().then(function(readyState) {
      return readyState.should.be.equal(3);
    });
  });
  it('should empty Wikis', function() {
    return new Promise(function(resolve, reject) {
      Wiki.find({}).remove().exec();
      return count({}, function(c) {
        c.should.be.equal(0);
        return resolve();
      });
    });
  });
  return it("should create a Wiki", function() {
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
  });
});

console.log(chalk.yellow("==> Wiki DB test loaded"));

describe(chalk.green("app/models/post"), function() {
  var _sussurro_, count, create;
  count = function(query, callback) {
    return mongoose.model('Post').count(query, function(err, count) {
      return callback(count);
    });
  };
  create = function(data, callback) {
    return mongoose.model('Post').create(data, function(err, post) {
      if (!err) {
        return callback(null, post);
      } else {
        return callback(err);
      }
    });
  };
  _sussurro_ = new SussurroConn();
  beforeEach(function() {
    return _sussurro_.connect().then(function(db) {
      return mongoose.connection.readyState.should.be.equal(1);
    });
  });
  afterEach(function() {
    return _sussurro_.disconnect().then(function(readyState) {
      return readyState.should.be.equal(3);
    });
  });
  it('should empty Posts', function() {
    return new Promise(function(resolve, reject) {
      Post.find({}).remove().exec();
      return count({}, function(c) {
        c.should.be.equal(0);
        return resolve();
      });
    });
  });
  it("should create a post", function() {
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
  });
  it("should create another post", function() {
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
  });
  return it("should create a third post", function() {
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
  });
});

console.log(chalk.yellow("==> Post DB test loaded"));

describe(chalk.green("app/models/session"), function() {
  var _sussurro_, count, create;
  count = function(query, callback) {
    return mongoose.model('Session').count(query, function(err, count) {
      return callback(count);
    });
  };
  create = function(data, callback) {
    return mongoose.model('Session').create(data, function(err, session) {
      if (!err) {
        return callback(null, session);
      } else {
        return callback(err);
      }
    });
  };
  _sussurro_ = new SussurroConn();
  beforeEach(function() {
    return _sussurro_.connect().then(function(db) {
      return mongoose.connection.readyState.should.be.equal(1);
    });
  });
  afterEach(function() {
    return _sussurro_.disconnect().then(function(readyState) {
      return readyState.should.be.equal(3);
    });
  });
  it('should empty Sessions', function() {
    return new Promise(function(resolve, reject) {
      Session.find().remove().exec();
      return count({}, function(c) {
        c.should.be.equal(0);
        return resolve();
      });
    });
  });
  return it("should create a simple Session", function() {
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
  });
});

describe(chalk.green("boot/app"), function() {
  return it('should be connect with mongodb', function() {
    return new Promise(function(resolve, reject) {
      return sussurro.connection.connect().then(sussurro.configure).then(function(readyState) {
        readyState.should.be.equal(1);
        return resolve();
      });
    });
  });
});

console.log(chalk.yellow("==> App boot test loaded"));

describe(chalk.green("app/controllers/profile"), function() {
  var id1, id2;
  id1 = "0";
  id2 = "0";
  it('should GET /api/profiles', function() {
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
  });
  it("should POST /api/profiles/create with a form", function() {
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
  });
  it("should GET /api/profiles get two profiles", function() {
    return request(sussurro.app).get('/api/profiles').expect('Content-Type', /json/).expect(200).expect(function(res) {
      res.body.should.be.an.Array();
      res.body.should.be.not.empty();
      res.body.should.have.length(2);
      return id2 = res.body[1]._id;
    });
  });
  it("should GET /api/profiles/:id(first)", function() {
    return request(sussurro.app).get('/api/profiles/' + id1).expect('Content-Type', /json/).expect(200).expect(function(res) {
      var profile;
      profile = res.body;
      profile.should.not.have.property('err');
      profile.should.have.property('updatedAt');
      profile.should.have.property('nome_artistico');
      profile.should.have.property('nome_completo');
      return profile.should.have.property('posts');
    });
  });
  return it("should GET /api/profile/:id(second)", function() {
    return request(sussurro.app).get('/api/profiles/' + id2).expect('Content-Type', /json/).expect(200).expect(function(res) {
      var profile;
      profile = res.body;
      profile.should.not.have.property('err');
      profile.should.have.property('updatedAt');
      profile.should.have.property('nome_artistico');
      profile.should.have.property('nome_completo');
      return profile.should.have.property('posts');
    });
  });
});

console.log(chalk.yellow("==> Profile app test loaded"));

describe(chalk.green("app/controllers/bio"), function() {
  it("should GET /api/bios", function() {
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
  });
  return it("should GET /api/bios/:id", function() {
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
  });
});

console.log(chalk.yellow("==> Bio app test loaded"));

describe(chalk.green("app/controllers/local"), function() {
  it("should GET /api/locals", function() {
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
  });
  return it("should GET /api/locals/:id", function() {
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
  });
});

console.log(chalk.yellow("==> Local app test loaded"));

describe(chalk.green("app/controllers/contato"), function() {
  it("should GET /api/contatos", function() {
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
  });
  return it("should GET /api/contatos/:id", function() {
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
  });
});

console.log(chalk.yellow("==> Contato app test loaded"));

describe(chalk.green("app/controllers/wiki"), function() {
  it("should GET /api/wikis", function() {
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
  });
  return it("should GET /api/wikis/:id", function() {
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
  });
});

describe(chalk.green("app/controllers/post"), function() {
  it("should GET /api/posts", function() {
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
  });
  it("should GET /api/posts/:id", function() {
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
  });
  return it("Disconnect from mongodb", function() {
    return sussurro.connection.disconnect().then(function(readyState) {
      return readyState.should.be.equal(3);
    });
  });
});
