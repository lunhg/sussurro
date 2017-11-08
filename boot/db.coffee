#############
# Load models
#############
Admin = mongoose.model 'Admin'
User = mongoose.model 'User'
Wiki = mongoose.model 'Wiki'
Post = mongoose.model 'Post'
Composition = mongoose.model 'Composition'
        

console.log chalk.yellow("==> MongoDB once open loaded")
