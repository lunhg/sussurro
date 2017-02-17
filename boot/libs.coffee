### MAIN LIBRARIES ###
fs = require 'fs'
connectAssets = require("connect-assets")
compression = require("compression")
chalk  = require 'chalk'
crypto = require 'crypto'
each = require 'foreach'
express = require 'express'
session = require 'express-session'
mongoose = require('mongoose').set('debug', false)
MongoStore = require('connect-mongo')(session)
timestamps = require('mongoose-timestamp');
passport = require 'passport'
path = require 'path'
favicon = require 'serve-favicon'
logger = require 'morgan'
cookieParser = require 'cookie-parser'
bodyParser = require 'body-parser'
SoundCloudStrategy = require('passport-soundcloud').Strategy
GithubCloudStrategy = require('passport-github').Strategy
LocalStrategy = require('passport-local').Strategy
marked = require 'jstransformer-marked'
nodemailer = require 'nodemailer'
uuid = require 'node-uuid'
generatePassword = require "password-generator"
mailgun_transport = require 'nodemailer-mailgun-transport'
roles = require 'mongoose-role'
keychain = require 'xkeychain'

console.log chalk.yellow("==> Sussurro libraries loaded")
