# create deploy user
sudo adduser deploy
sudo adduser deploy sudo
sudo su - deploy

# update and upgrade repositories
sudo apt-get update
sudo apt-get upgrade -y

# install nodejs and yarn
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee
sudo apt-get update
sudo apt-get install -y git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev software-properties-common libffi-dev dirmngr gnupg apt-transport-https ca-certificates redis-server redis-tools nodejs yarn

# install rbenv
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc
git clone https://github.com/rbenv/rbenv-vars.git ~/.rbenv/plugins/rbenv-vars
exec $SHELL
rbenv install 2.7.0
rbenv global 2.7.0

# install bundler
gem install bundler

# install nginx and passenger
sudo apt-get install -y nginx
sudo apt-get install -y dirmngr gnupg
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7
sudo apt-get install -y apt-transport-https ca-certificates
sudo sh -c 'echo deb https://oss-binaries.phusionpassenger.com/apt/passenger buster main > /etc/apt/sources.list.d/passenger.list'
sudo apt-get update
sudo apt-get install -y libnginx-mod-http-passenger
if [ ! -f /etc/nginx/modules-enabled/50-mod-http-passenger.conf ]; then sudo ln -s /usr/share/nginx/modules-available/mod-http-passenger.load /etc/nginx/modules-enabled/50-mod-http-passenger.conf ; fi
sudo ls /etc/nginx/conf.d/mod-http-passenger.conf

# configure nginx
# edit the following file with
sudo nano /etc/nginx/conf.d/mod-http-passenger.conf 
# change second line to 
# start
passenger_ruby /home/deploy/.rbenv/shims/ruby;
# end
sudo service nginx start
sudo rm /etc/nginx/sites-enabled/default
# edit the following file with
sudo nano /etc/nginx/sites-enabled/myapp
# start file
server {
  listen 80;
  listen [::]:80;

  server_name _;
  root /home/deploy/myapp/current/public;

  passenger_enabled on;
  passenger_app_env production;

  location /cable {
    passenger_app_group_name myapp_websocket;
    passenger_force_max_concurrent_requests_per_process 0;
  }

  # Allow uploads up to 100MB in size
  client_max_body_size 100m;

  location ~ ^/(assets|packs) {
    expires max;
    gzip_static on;
  }
}
# end file

sudo service nginx reload

# install postgresql
sudo apt-get install -y postgresql postgresql-contrib libpq-dev
sudo su - postgres
createuser --pwprompt deploy
createdb -O deploy myapp
exit


DEVISE_SECRET_KEY='fake'
AWS_KEY='morefake'
AWS_SECRET_KEY='pretend'
AWS_BUCKET='yourawsbucketname'
STRIPE_SECRET_KEY="madeup"
STRIPE_PUBLIC_KEY="allfake"
GMAIL_PWD="bgmmeg65wtzgf9"
Stripe.api_key=STRIPE_SECRET_KEY
STRIPE_CONNECT_CLIENT_ID="superfake"
FACEBOOK_APP_ID="228315535169936"
FACEBOOK_APP_SECRET="9f4def20fc09ce5c5ebcc74cafc4a6fd"
SECRET_KEY_BASE="fa54c112293bc1811ecb54da71fa2d0c9fd346575f9fc1b495defaee88b99d0ea78bc9c61597711fe57989996d7c8f2343449431901648171b2918ee16e9f642"

./certbot-auto certonly --manual --preferred-challenges dns -d 'boilingreef.com' -d 'www.boilingreef.com'