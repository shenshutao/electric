# README

## Pre-request

On ubuntu16.04:

```sh
sudo apt-get install ruby
sudo apt-get install ruby-dev
sudo apt-get install sqlite3
sudo apt-get install make
sudo apt-get install zlibc zlib1g zlib1g-dev
sudo apt-get install gcc
gem install rails
sudo apt-get install libsqlite3-dev
bundle install
sudo apt-get install nodejs
```

Run server:

```sh
bin/rails server
```

if 'tzinfo-data' error occur when running `bin/rails server`
```sh
 # delete the 'platform' form the line of tzinfo-data in the Gemfile.
bundle update
```

if encountered 'ActionView::Template::Error (Permission denied @ utime_internal - /home/electric_/tmp/cache/assets/sprockets/v3.0/2G/2GGE8OU4vj4G_YeQOBJ0pPIMNYg5qUoesFFs0rZogVw.cache):' problem:

```sh
rm -rf tmp/cache
```

To start fetch current cost data:
```sh
cd script
nohup python -u fetchFromPachube.py > log-fetchfrompachube.txt &
```
