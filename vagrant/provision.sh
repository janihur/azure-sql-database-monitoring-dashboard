# grub packages on-hold
sudo apt-mark -q hold grub-common grub-pc grub-pc-bin grub2-common

# update basic packages (except those on hold)
sudo apt-get update
sudo apt-get -y upgrade

# dashing http://dashing.io/
sudo apt-get -y install ruby-dev
sudo apt-get -y install nodejs-legacy
sudo gem install bundler
sudo gem install dashing

# sql server connectivity
sudo apt-get -y install freetds-dev freetds-bin
sudo gem install tiny_tds
