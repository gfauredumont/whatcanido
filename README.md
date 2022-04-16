# Description

Basic config to create a Rails DEV env

## Usage

**NOTE** Change Ruby version AT THE VERY BEGGINING if you want/need something specific !

In following file:
- `Dockerfile` (from image: line 3)
- `.ruby-version`
- `Gemfile`


```sh
$ touch .env.perso
$ docker-compose build
$ docker-compose run web bash
# inside container:
$ gem install rails
# Create your Rails app with prefered options (see below for suggested config)
$ rails new . # ....
$ exit
```

Uncomment in `Dockerfile` lines containing:
```Dockerfile
COPY Gemfile /webapp/Gemfile
COPY Gemfile.lock /webapp/Gemfile.lock
RUN bundle install

# If you installed JS bundling in your app, also uncomment:
COPY package.json /webapp/package.json
COPY yarn.lock /webapp/yarn.lock
RUN yarn install
```

You might need to get back ownership of your files (Ref needed)
```sh
find . -user root | xargs sudo chown your_host_user_name:your_host_user_name
```

Then rebuild your image:
```sh
$ docker-compose build
```

You can now use your app:
```sh
# Start App
$ docker-compose up
# run shell into app
$ docker-compose run web bash
```

Have fun ;)


### Suggested rails Install config :

```sh
rails new --database=postgresql --skip-git --skip-action-cable --skip-test --skip-system-test --javascript=esbuild --css=tailwind --skip-hotwire .
```
