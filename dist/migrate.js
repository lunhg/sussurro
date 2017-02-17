var $, _error, _handler, _keys, _now, _values, chalk, cheerio, data, each, fs, handler, keys, path, select;

select = require('cheerio-select');

cheerio = require('cheerio');

fs = require('fs');

path = require('path');

each = require('each');

chalk = require('chalk');


/* Load the data */

data = fs.readFileSync(path.join(__dirname, '..', require('../package.json')['html_db']), 'utf8');

$ = cheerio.load(data, {
  normalizeWhitespace: true
});


/* mock database */

keys = [];


/* A general then error */

_error = function(_err) {
  if (_err) {
    return console.log(_err.stack);
  }
};


/* Get the first line, or the keys. They are properties and subproperties */

_now = $('tbody').find('tr').first();

_keys = $(_now).find('td').filter(function(i, e) {
  return $(this).attr('dir') === "ltr";
});

_handler = function(e, i, next) {
  return keys.push($(e).text());
};

each(_keys).call(_handler).then(_error);


/* Get all values */

_values = _now.nextAll().filter(function(i, e) {
  return $(this).css('height') === '20px';
});


/* populate keys in json */

handler = function(e, i, next) {
  var json;
  json = {};
  console.log(e);
  return console.log(json);
};

each(keys).call(handler).then(function(err) {
  if (!err) {
    return console.log(chalk.cyan("Migration done"));
  } else {
    return console.log(chalk.red(err));
  }
});
