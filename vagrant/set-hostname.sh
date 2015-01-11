sudo chmod o+w /etc/hostname
sudo echo "$1" > /etc/hostname
sudo chmod o-w /etc/hostname
sudo perl -pi.bak -e "s/ubuntu-1404-server/$1/g" /etc/hosts
