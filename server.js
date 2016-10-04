
/* LOAD LIBRARIES */
var Admin, Composition, CompositionSchema, GithubCloudStrategy, LocalStrategy, MAILBOT, MAILER, MongoStore, Post, PostSchema, SOUNDCLOUD_OPTIONS, SOUNDCLOUD_STRATEGY, SoundCloudStrategy, User, UserSchema, Wiki, WikiSchema, _mail_conf, app, bodyParser, cookieParser, encun, express, favicon, generatePassword, j, len, logger, mailer, mailgun_transport, marked, model, mongoose, nodemailer, passport, path, populate, ref, rootAdmin, rootUser, sass, session, timestamps, uuid, wiki;

express = require('express');

session = require('express-session');

mongoose = require('mongoose');

MongoStore = require('connect-mongo')(session);

timestamps = require('mongoose-timestamp');

passport = require('passport');

path = require('path');

favicon = require('serve-favicon');

logger = require('morgan');

cookieParser = require('cookie-parser');

bodyParser = require('body-parser');

sass = require('node-sass-middleware');

SoundCloudStrategy = require('passport-soundcloud').Strategy;

GithubCloudStrategy = require('passport-github').Strategy;

LocalStrategy = require('passport-local').Strategy;

marked = require('jstransformer-marked');

nodemailer = require('nodemailer');

uuid = require('node-uuid');

generatePassword = require("password-generator");

mailgun_transport = require('nodemailer-mailgun-transport');


/* LOAD DATABASE */


/* SETUP NODE_ENV */

process.env.NODE_ENV = process.env.NODE_ENV || 'development';

if (process.env.NODE_ENV === 'development') {
  mongoose.connect('mongodb://localhost/sussurro');
}

if (process.env.NODE_ENV === 'test') {
  mongoose.connect('mongodb://localhost/sussurro');
}

if (process.env.NODE_ENV === 'production') {
  mongoose.connect('mongodb://localhost/sussurro');
}

if (process.env.NODE_ENV === 'deploy') {
  mongoose.connect('mongodb://localhost/sussurro');
}

UserSchema = new mongoose.Schema({
  username: String,
  email: String,
  token: String,
  isActive: Boolean,
  password: String,
  roles: {
    admin: mongoose.Schema.Types.ObjectId
  },
  bio: String,
  img: String,
  wiki: {
    posts: [
      {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Post'
      }
    ],
    compositions: [
      {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Composition'
      }
    ]
  }
});

UserSchema.methods.setPassword = function(pass) {
  this.password = pass;
  return this.save();
};

UserSchema.methods.addBio = function(bio) {
  this.info.bio = bio;
  return this.save();
};

UserSchema.methods.addPost = function(text) {
  this.posts.push(new Post({
    text: text
  }));
  if (callback) {
    return this.save(callback);
  } else {
    return this.save();
  }
};

UserSchema.methods.addComposition = function(o) {
  this.compostion.push(new Composition(o));
  if (callback) {
    return this.save(callback);
  } else {
    return this.save();
  }
};

mongoose.model('User', UserSchema);

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

mongoose.model('Wiki', WikiSchema);

PostSchema = new mongoose.Schema({
  title: String,
  ref: String,
  text: String,
  authors: [
    {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User'
    }
  ],
  wiki: mongoose.Schema.Types.ObjectId,
  comments: [
    {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Comments'
    }
  ]
});

PostSchema.plugin(timestamps);

mongoose.model('Post', PostSchema);

CompositionSchema = new mongoose.Schema({
  name: String,
  tag: String,
  path: String,
  version: String,
  link: String
});

CompositionSchema.methods.addPath = function(p) {
  this.path = p;
  return this.save();
};

CompositionSchema.methods.addVersion = function(v) {
  this.version = v;
  return this.save();
};

CompositionSchema.methods.addLink = function(l) {
  this.link = l;
  return this.save();
};

mongoose.model('Composition', CompositionSchema);

User = mongoose.model('User');

Wiki = mongoose.model('Wiki');

Post = mongoose.model('Post');

Composition = mongoose.model('Composition');


/* MAILGUN (https://mailgun.com) */

_mail_conf = require("./mailgun.json");

MAILBOT = _mail_conf.email;

MAILER = {
  auth: {
    api_key: _mail_conf.api_key,
    domain: _mail_conf.domain
  }
};

mailer = nodemailer.createTransport(mailgun_transport(MAILER));

SOUNDCLOUD_OPTIONS = {
  clientID: "--insert-soundcloud-client-id-here--",
  clientSecret: "--insert-soundcloud-client-secret-here--",
  callbackURL: "http://127.0.0.1:3000/auth/soundcloud/callback"
};

SOUNDCLOUD_STRATEGY = function(accessToken, refreshToken, profile, done) {
  return process.nextTick(function() {
    return done(null, profile);
  });
};

Admin = mongoose.model('Admin', {
  name: {
    first: String,
    last: String,
    full: String
  },
  groups: [],
  user: {
    id: mongoose.Schema.Types.ObjectId,
    name: String
  }
});

rootAdmin = null;

rootUser = null;

ref = [User, Admin, Wiki, Post, Composition];
for (j = 0, len = ref.length; j < len; j++) {
  model = ref[j];
  model.remove({});
}

rootAdmin = new Admin({
  name: {
    first: 'Root',
    last: 'Admin',
    full: 'Root Admin'
  },
  groups: ['root']
});

rootUser = new User({
  username: 'Leverkun-bot',
  isActive: false,
  token: uuid.v4(),
  email: MAILBOT,
  roles: {
    admin: rootAdmin._id
  },
  password: generatePassword(12, null)
});

rootAdmin.user = {
  id: rootUser._id
};

rootAdmin.save();

rootUser.save();

populate = function(wiki, set, user) {
  var i, index, item, k, len1, p;
  index = new Post({
    title: wiki.name + " index",
    ref: 'index',
    authors: [user]
  });
  i = 0;
  for (k = 0, len1 = set.length; k < len1; k++) {
    item = set[k];
    p = new Post(item);
    p.wiki = wiki._id;
    p.authors.push(user);
    p.save();
    index.text += "\n\n   " + i + ". [" + item.title + "](/?wiki=" + wiki.name + "&ref=" + item.ref + ")";
    wiki.posts.push(p);
    i++;
  }
  index.save();
  return wiki.save();
};


/* SUSSSURRO */

wiki = new Wiki({
  name: "Sussurro",
  description: "Wiki do Sussurro."
});

populate(wiki, [
  {
    title: "Sussurro: Acervo Digital",
    ref: 'about',
    text: "O atual [Sussurro](http://sussurro.musica.ufrj.br/) é um acervo de música contemporânea produzida no Brasil. Foi criado em 2006 por [Rodolfo Caesar](http://buscatextual.cnpq.br/buscatextual/visualizacv.do?id=K4783960P4) com o objetivo de ser um espaço acessível de divulgação.\n\n"
  }, {
    title: "Pesquisa",
    ref: 'research',
    text: "Aqui você poderá pesquisar as produções de diversos artistas, compositores e pesquisadores, eventualmente baixando obras completas ou apenas amostras (respeitando os direitos de reprodução - copyright ou copyleft), ou entrar em contato com seus [autores](/users)."
  }, {
    title: 'Produção',
    ref: 'production',
    text: "A produção apresentada gira em torno do repertório das artes sônicas: músicas experimentais, sejam acusmáticas, mistas, live, auxiliadas-por-computador, algorítmicas, música-vídeo, multimídia, intermídia, músicas instrumentais com vetores experimentais, poesia, etc. (inexistindo um recorte tecnológico). A ideia é oferecer documentação e divulgação a uma produção que, para manter o que lhe é específico, não pode correr no mesmo passo do mercado."
  }, {
    title: 'Cadastro',
    ref: 'signup',
    text: "O cadastro é realizado ao acessar a página de [cadastro](/signup). Por sua vez, o usuário receberá um email com um [token](https://en.wikipedia.org/wiki/Chain_of_trust) para verificação.\n\nUma vez feita a verificação, o usuário pode [modificar sua senha](/?wiki=main&ref=senha)."
  }, {
    title: 'Login',
    ref: 'login',
    text: "O sussurro é um sistema [wiki](https://pt.wikipedia.org/wiki/Wiki), cuja base de dados é construída por [usuários](/?wiki=main&ref=users) e [administradores](/?wiki=main&ref=admin).\n\nO usuário pode então construir outros wikis, cujo documentos textuais podem fazer referêcia a outros [documentos](/?wiki=main&ref=post) e [composições](/?wiki=main&ref=composicao)."
  }, {
    title: 'Administradores',
    ref: 'admin',
    text: "*Página em construção*"
  }, {
    title: 'Usuários',
    ref: 'users',
    text: "*Página em construção*"
  }, {
    title: 'Senha',
    ref: 'senha',
    text: "*Página em construção*"
  }
]);


/* ENCUN */

encun = new Wiki({
  name: "Encun",
  description: "Assuntos para o Encun"
});

populate(encun, [
  {
    title: "Encontro Nacional de Compositores Universitários",
    ref: 'about',
    text: " *Página em construção*"
  }, {
    title: "Encun I",
    ref: 'I',
    text: " *Página em construção*"
  }, {
    title: "Encun II",
    ref: 'II',
    text: " *Página em construção*"
  }, {
    title: "Encun III",
    ref: 'III',
    text: " *Página em construção*"
  }, {
    title: "Encun IV",
    ref: 'IV',
    text: " *Página em construção*"
  }, {
    title: "Encun V",
    ref: 'V',
    text: " *Página em construção*"
  }, {
    title: "Encun VI",
    ref: 'VI',
    text: " *Página em construção*"
  }, {
    title: "Encun VII",
    ref: 'VII',
    text: " *Página em construção*"
  }, {
    title: "Encun VIII",
    ref: 'VIII',
    text: " *Página em construção*"
  }, {
    title: "Encun IX",
    ref: 'IX',
    text: " *Página em construção*"
  }, {
    title: "Encun X",
    ref: 'X',
    text: " *Página em construção*"
  }, {
    title: "Encun V",
    ref: 'V',
    text: " *Página em construção*"
  }
]);

console.log("===> sending boot email...");

Admin.find(function(err, admins, next) {
  var admin, email, k, len1;
  if (!err && process.env.NODE_ENV === 'test' || process.env.NODE_ENV === 'production') {
    for (k = 0, len1 = admins.length; k < len1; k++) {
      admin = admins[k];
      email = {
        from: MAILBOT,
        to: admin.email,
        subject: 'Sussurro booted',
        html: '<h1>Wow!!!</h1> <b>Big powerful letters</b><br/><p>Mailgun rocks, pow pow!</p>'
      };
      email.bcc = admin.user.email;
      mailer.sendMail(email, function(err, info) {
        if (err) {
          return console.log(err);
        } else {
          return console.log(info);
        }
      });
    }
    return next();
  }
});


/* STARTING EXPRESS */

app = express();

app.set('views', path.join(__dirname, 'app/views'));

app.set('view engine', 'pug');


/* uncomment after placing your favicon in /public */


/* app.use(favicon(path.join(__dirname, 'public', 'favicon.ico'))) */

app.use(logger('dev'));

app.use(bodyParser.json());

app.use(bodyParser.urlencoded({
  extended: false
}));

app.use(cookieParser());

app.use(sass({
  src: path.join(__dirname, '/app/assets'),
  dest: path.join(__dirname, '/public'),
  indentedSyntax: true,
  sourceMap: true,
  debug: true,
  outputStyle: 'compressed'
}));

app.use(express["static"](path.join(__dirname, 'public')));

app.use(session({
  secret: 'keyboard cat',
  maxAge: new Date(Date.now() + 3600000),
  store: new MongoStore({
    mongooseConnection: mongoose.connection
  }),
  saveUninitialized: true,
  resave: false
}));

app.use(passport.initialize());

app.use(passport.session());

passport.serializeUser(function(user, done) {});

passport.deserializeUser(function(obj, done) {
  return User.findOne({
    id: id
  }, function(err, user) {
    return done(err, user);
  });
});

passport.use(new SoundCloudStrategy(SOUNDCLOUD_OPTIONS, SOUNDCLOUD_STRATEGY));

passport.use(new LocalStrategy(function(username, password, done) {
  return User.findOne({
    name: username,
    password: password
  }, function(err, user) {
    if (!user) {
      done(null, false, {
        message: 'Incorrect username.'
      });
    }
    if (!user.validPassword(password)) {
      done(null, false, {
        message: 'Incorrect password.'
      });
    }
    return done(null, user);
  });
}));


/* CONFIG MAILER */

app.get('/mail', function(req, res) {
  return res.render('mail', {
    form: [
      {
        name: 'email',
        placeholder: 'vc@email'
      }, {
        name: 'subject',
        placeholder: 'subject'
      }, {
        name: 'text',
        placeholder: 'Mensagem.'
      }
    ]
  });
});

app.post('/mail', function(req, res) {
  var email;
  console.log("===> sending email");
  email = {
    from: req.body.email,
    to: MAILBOT,
    subject: "[SussurroBot]: " + req.body.subject,
    text: req.body.text
  };
  return mailer.sendMail(email, function(err, info) {
    return res.redirect("/#contato?flash=true&msg=contato");
  });
});

app.get('/signup', function(req, res) {
  return res.render('signup', {
    form: [
      {
        name: 'email',
        placeholder: 'email'
      }
    ]
  });
});

app.post('/signup', function(req, res) {
  var name;
  name = req.body.email.split("@")[0];
  return User.findOne({
    email: req.body.email
  }, function(err, users) {
    var email, user;
    console.log(users);
    if (!err) {
      console.log("===> user exist");
      return res.redirect("/?flash=false&msg=cadastro&type=notallowed");
    } else {
      console.log("===> Creating new user");
      user = new User({
        name: name,
        email: req.body.email,
        token: uuid.v4()
      });
      user.save();
      res.cookie("" + user.token + (new Date()), {
        maxAge: 3600000,
        path: '/'
      });
      console.log("<=== Done: " + user.id);
      email = {
        from: MAILBOT,
        to: user.email,
        subject: "[SussurroBot]: Cadastro",
        html: "Olá\n<p>Parece que alguém (" + user.name + "), criou uma conta no\n<a href=\"http://localhost:3000\">Sussurro</a>.</p>\n<br/>\n<p>Se vocêr solicitou o serviço, por gentileza, clique no link abaixo e você será redirecionado para nossa página.</p>\n<br/>\n<a href=\"http://localhost:3000/verify?token=" + user.token + "\">http://localhost:3000/verify?token=" + user.token + "</a>"
      };
      console.log("===> sending email to " + user.id + "...");
      return mailer.sendMail(email, function(_err, info) {
        var flash;
        flash = _err ? false : true;
        return res.redirect("/?flash=" + flash + "&msg=cadastro");
      });
    }
  });
});

app.get('/verify', function(req, res) {
  console.log(req.query.token);
  return User.findOne({
    token: req.query.token
  }, function(err, user) {
    var email, u;
    if (!err) {
      user.password = generatePassword(12, null);
      user.verified = true;
      user.token = uuid.v4();
      user.save();
      console.log(user);
      email = {
        from: MAILBOT,
        to: user.email,
        subject: "[SussurroBot]: Cadastro",
        html: "Olá,\n        \nEstamos confirmando sua requisição. Geramos usa senha pra você. Sugerimos que <a href=\"localhost:3000/user/" + user._id + "/edit\">troque</a> sua senha assim possível."
      };
      console.log("===> sending email to " + user.id + "...");
      u = user;
      return mailer.sendMail(email, function(err, info) {
        var flash;
        flash = err ? "erro" : "sucesso";
        return res.redirect("/user/" + u._id + "/edit?flash=" + flash + "&msg=verificado&token=" + u.token);
      });
    } else {
      console.log("User not found");
      return res.redirect("/?flash=" + flash);
    }
  });
});


/* CONFIG ROUTES */

app.get('/', function(req, res, next) {
  var json;
  json = {
    filters: [marked],
    flash: req.query.msg ? true : false,
    msg: req.query.msg ? (req.query.msg === 'contato' ? "Mensagem enviada." : (req.query.msg === 'cadastro' && req.query.type === 'notallowed' ? "Usuário já existe" : "Cadastro feito. Verifique seu email!")) : false
  };
  return Wiki.findOne({
    name: "Sussurro"
  }, function(err, wiki) {
    if (!err) {
      Post.findOne({
        wiki: wiki._id,
        ref: req.query.ref || 'about'
      }, function(_err, post) {
        if (!_err) {
          json.title = post.title;
          json.text = post.text;
          json.publishedAt = post.createdAt;
          json.wikiname = wiki.name;
          json.wikiref = req.query.ref;
        }
        Post.find().where('wiki', wiki._id).where('title').ne(post.title).limit(5).exec(function(_err_, _posts) {
          var k, len1, p, results;
          if (!_err_) {
            results = [];
            for (k = 0, len1 = _posts.length; k < len1; k++) {
              p = _posts[k];
              results.push(json.wikiposts = {
                title: p.title,
                ref: p.ref
              });
            }
            return results;
          }
        });
        return Wiki.find().where('name').ne(wiki._id).limit(5).exec(function(_err, _newikis) {
          var k, len1, results, w;
          if (!_err) {
            results = [];
            for (k = 0, len1 = _wikis.length; k < len1; k++) {
              w = _wikis[k];
              results.push(json.newikis = {
                name: w.name,
                ref: w.ref
              });
            }
            return results;
          }
        });
      });
      console.log(json);
      return res.render('index', json);
    } else {
      throw new Error(err);
    }
  });
});

app.get('/auth/soundcloud', passport.authenticate('soundcloud', function(req, res) {}));

app.get('/auth/soundcloud/callback', passport.authenticate('soundcloud', {
  failureRedirect: '/login'
}), function(req, res) {
  console.log(res.body);
  return res.redirect('/users/#{req.user.id}');
});

app.get('/login', function(req, res) {
  return res.render('login', {
    form: [
      {
        name: 'email',
        placeholder: 'vc@email'
      }, {
        name: 'subject',
        placeholder: 'subject'
      }
    ]
  });
});

app.get('/login/soundcloud', function(req, res) {
  return res.redirect('/auth/soundcloud');
});

app.post('/login', function(req, res) {
  return passport.authenticate('local', {
    successRedirect: '/user/:id',
    failureRedirect: '/login',
    failureFlash: true
  });
});

app.get('/logout', function(req, res) {
  req.logout();
  return res.redirect('/');
});

app.get('/users', function(req, res, next) {
  return User.find(function(err, users) {
    if (!err) {
      return res.render('users', {
        users: users
      });
    } else {
      return res.render('users', {
        result: false,
        msg: "Nenhum usuário cadastrado. Seja o primeiro!"
      });
    }
  });
});

app.get('/users/profile', function(req, res) {});

module.exports = app;
