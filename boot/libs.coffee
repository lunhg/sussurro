connectAssets = require("connect-assets")
compression = require("compression")
chalk  = require 'chalk'
each = require 'foreach'
express = require 'express'
session = require 'express-session'
mongoose = require 'mongoose'
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


