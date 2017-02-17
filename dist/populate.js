var Migrate, Post, PostSchema, Profile, ProfileSchema, User, UserSchema, Wiki, WikiSchema, chalk, cheerio, each, fs, mongoose, path, permission, populate, select, timestamps,
  slice = [].slice;

select = require('cheerio-select');

cheerio = require('cheerio');

fs = require('fs');

path = require('path');

each = require('each');

chalk = require('chalk');

mongoose = require('mongoose');

timestamps = require('mongoose-timestamp');

permission = require('mongoose-permission');

console.log(chalk.yellow("==> populate libs loaded"));


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

mongoose.connection.on('error', console.error.bind(chalk.red('connection error: ')));

mongoose.connection.once('open', function() {
  return console.log(chalk.cyan("==> connected do sussurro database"));
});


/* Profile Model */

ProfileSchema = new mongoose.Schema({
  nome_completo: String,
  user: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User'
  }
});

ProfileSchema.plugin(timestamps);

ProfileSchema.plugin(permission, {
  roles: ['manage articles', 'manage user'],
  accessLevels: {
    'manage articles': ['publish', 'write']
  }
});

ProfileSchema.methods.createOne = function(nome, email, roles) {
  return Profile.findOne({
    nome_completo: nome
  }, function(err, profile) {
    var user;
    if (err) {
      profile = Profile({
        nome_completo: nome
      });
      user = new User();
      user.asProfile(p, email, roles);
      return user.save(function(e, u) {
        profile.user = u._id;
        return profile.save();
      });
    } else {
      return console.log("profile " + profile.id + " already in use");
    }
  });
};

mongoose.model('Profile', ProfileSchema);

Profile = mongoose.model('Profile');

console.log(chalk.yellow("==> " + Profile.modelName + " schema loaded"));


/* User Model */

UserSchema = new mongoose.Schema({
  user: String,
  pwd: String,
  customData: {
    profile: String,
    admin: String,
    email: String,
    isActive: Boolean,
    isVerified: Boolean,
    token: String,
    mailSent: Boolean
  }
});

UserSchema.plugin(timestamps);

UserSchema.methods.asAdmin = function(roles) {
  this.customData.admin = Admin.createOne({
    user: this.id
  });
  this.user = admin.id;
  this.pwd = generatePassword(12, null);
  return this.customData = {
    isAdmin: true,
    email: false,
    token: uuid.v4(),
    isActive: false,
    mailSent: false
  };
};

UserSchema.methods.asProfile = function(profile, email, roles) {
  this.user = profile.id;
  this.pwd = generatePassword(12, null);
  this.customData = {
    email: email,
    token: uuid.v4(),
    isActive: false,
    mailSent: false
  };
  return this.roles = roles;
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

WikiSchema.methods.createPost = function() {
  var p, profiles, text, title;
  title = arguments[0], text = arguments[1], profiles = 3 <= arguments.length ? slice.call(arguments, 2) : [];
  p = new Post({
    title: title,
    text: text,
    authors: profiles
  });
  p.save();
  this.posts.push(p);
  return this.save();
};

mongoose.model('Wiki', WikiSchema);

Wiki = mongoose.model('Wiki');

console.log(chalk.yellow("==> " + Wiki.modelName + " schema loaded"));


/* Post model */

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

Post = mongoose.model('Post');

console.log(chalk.yellow("==> " + Post.modelName + " schema loaded"));


/* migration class */

Migrate = (function() {
  function Migrate(src) {

    /* Load the data */
    var __path;
    __path = require('../package.json')['html_db'];
    this.data = fs.readFileSync(path.join(__dirname, '..', __path), 'utf8');
    this.$ = cheerio.load(this.data, {
      normalizeWhitespace: true
    });
  }

  Migrate.prototype.__remove__ = function(c, query) {
    c.remove(query);
    return console.log(chalk.cyan("" + c.modelName) + " " + chalk.green("collection cleaned"));
  };


  /* Get the first line, or the keys. They are properties and subproperties */

  Migrate.prototype.clean = function() {
    var c, callback, collections, i, j, len, results;
    collections = 2 <= arguments.length ? slice.call(arguments, 0, i = arguments.length - 1) : (i = 0, []), callback = arguments[i++];
    results = [];
    for (j = 0, len = collections.length; j < len; j++) {
      c = collections[j];
      results.push(this.__remove__(c, {}));
    }
    return results;
  };

  Migrate.prototype.makeAdmins = function() {
    var __admins, admin, i, len, results;
    console.log("===> Creating root user");
    __admins = require('../mailer/allowed.json')['admins'];
    results = [];
    for (i = 0, len = __admins.length; i < len; i++) {
      admin = __admins[i];
      results.push(Profile.createOne(uuid.v4(), admin, 'read'));
    }
    return results;
  };

  return Migrate;

})();

module.exports.populate = populate = function() {
  var collections, m;
  collections = 1 <= arguments.length ? slice.call(arguments, 0) : [];
  m = new Migrate('db/sussurro.html');
  m.clean(collections);
  return m.makeRoot();
};
