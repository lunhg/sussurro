
/* MAIN LIBRARIES */
var App, Bio, BioSchema, Contato, ContatoSchema, GithubCloudStrategy, Local, LocalSchema, LocalStrategy, MongoStore, Post, PostSchema, Profile, ProfileSchema, Session, SessionSchema, SoundCloudStrategy, SussurroConn, User, UserSchema, Wiki, WikiSchema, _schema, bios, bodyParser, chalk, compression, connectAssets, contatos, cookieParser, crypto, each, express, favicon, fs, generatePassword, keychain, locals, logger, mailgun_transport, marked, mongoose, nodemailer, onValidate, passport, path, posts, profiles, roles, session, sussurro, timestamps, uuid, validateLocalStrategyPassword, validateLocalStrategyProperty, wikis;

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


/* Export express app */

sussurro.connection.connect().then(function(db) {
  return sussurro.configure(function(readyState) {
    if (readyState !== 1) {
      return process.exit(1);
    }
  });
});

module.exports = sussurro.app;
