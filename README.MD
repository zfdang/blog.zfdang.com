How to write new post

### install npm and hexo-cli if necessary

`$brew install npm`

`$npm install hexo-cli -g`


### install theme

BlueLake is used by this blog. We should install this themes manually.

https://github.com/zfdang/hexo-theme-BlueLake

`$ git clone https://github.com/zfdang/hexo-theme-BlueLake.git themes/BlueLake`
`$ npm install hexo-renderer-jade@0.3.0 --save`
`$ npm install hexo-renderer-stylus --save`

### create new post

`$ hexo new post "new post"`

edit the content of the post

Image can be put into "/docs/img" and reffered as "/img/xx.jpg"


### generate post

`$ hexo g`

"/docs" folder will be updated


### push to github repo

`$ git add .`

`$ git commit -a -m "new post"`

`$ git push`
