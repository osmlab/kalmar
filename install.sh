set -e -u

sudo apt-get update
sudo apt-get install -y git ruby-full rubygems imagemagick 
sudo apt-get install -y postgresql-9.3 postgresql-9.3-postgis-2.1 postgresql-contrib-9.3 postgresql-client-9.3 postgresql-common postgresql-client-common postgresql-plpython-9.3
sudo apt-get install -y zlib1g-dev libxml2-dev libpq-dev postgresql-server-dev-9.3
sudo git clone --depth=1 https://github.com/openstreetmap/openstreetmap-website.git

gem install bundle
cd openstreetmap-website
sudo bundle install

sudo cp config/example.application.yml config/application.yml
sudo cp config/example.database.yml config/databse.yml

sudo -u postgres -i
createuser -s admin
bundle exec rake db:create
psql -d openstreetmap -c "CREATE EXTENSION btree_gist"
psql -d osm_test -c "CREATE EXTENSION btree_gist;"
exit

cd db/functions
sudo make libpgosm.so
cd ../..

# I know
sudo chmod 777 /home/ubuntu

sudo su postgres
bundle exec rake db:migrate
# open post 3000 on your instance
bundle exec rails server
# BAM: localhost:3000/
# might need to hit it a few times initially for things to cache
