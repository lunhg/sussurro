fs = require 'fs'
path = require 'path'
http = require 'http'
body_parser = require 'body-parser'
compression = require 'compression'
connect_assets = require 'connect-assets'
cookie_parser = require 'cookie-parser'
chalk = require 'chalk'
debug = require 'debug'
dotenv = require 'dotenv'
express = require 'express'
express_mailer = require 'express-mailer'
express_session = require 'express-session'
favicon = require 'favicon'
foreach = require 'foreach'
jstransformer_marked = require 'jstransformer-marked'
nodemailer = require 'nodemailer'
nodemailer_mailgun_transport = require 'nodemailer-mailgun-transport'
pug = require 'pug'
serve_favicon = require 'serve-favicon'