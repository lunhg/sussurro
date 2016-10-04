### SETUP NODE_ENV ###
process.env.NODE_ENV = process.env.NODE_ENV or 'development'

#### START DB ###
if process.env.NODE_ENV is 'development'
        mongoose.connect 'mongodb://localhost/sussurro'
if process.env.NODE_ENV is 'test'
        mongoose.connect 'mongodb://localhost/sussurro'
if process.env.NODE_ENV is 'production'
        mongoose.connect 'mongodb://localhost/sussurro'
if process.env.NODE_ENV is 'deploy'
        mongoose.connect 'mongodb://localhost/sussurro'
