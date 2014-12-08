sudo apt-get update
sudo apt-get install -y git make ruby-full ruby imagemagick nodejs
sudo apt-get install -y postgresql-9.3 postgresql-9.3-postgis-2.1 postgresql-contrib-9.3 postgresql-client-9.3 postgresql-common postgresql-client-common postgresql-plpython-9.3
sudo apt-get install -y zlib1g-dev libxml2-dev libpq-dev postgresql-server-dev-9.3
sudo git clone --depth=1 https://github.com/openstreetmap/openstreetmap-website.git

sudo gem install bundle
cd /home/ubuntu/openstreetmap-website
sudo bundle install

sudo cp config/example.application.yml config/application.yml
sudo cp config/example.database.yml config/database.yml

cd db/functions
sudo make libpgosm.so
cd ../..

# I know
sudo chmod 777 --recursive /home/ubuntu/openstreetmap-website

sudo -u postgres createuser -s admin
sudo -u postgres bundle exec rake db:create
sudo -u postgres psql -U postgres -d openstreetmap -c "CREATE EXTENSION btree_gist"
sudo -u postgres psql -U postgres -d osm_test -c "CREATE EXTENSION btree_gist;"
sudo -u postgres bundle exec rake db:migrate

# I know
sudo chmod 777 --recursive /home/ubuntu/openstreetmap-website

# expose port 3000 on your instance
# to start the server: sudo -u postgres bundle exec rails server
# ready to go at localhost:3000/
