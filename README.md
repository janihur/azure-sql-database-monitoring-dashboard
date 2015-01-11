# Azure SQL Database Monitoring Dashboard

Build on top of [Dashing](http://dashing.io/).

## Development Environment

Uses [Vagrant](https://www.vagrantup.com/) - `Vagrantfile` included:

```
#!bash
# first time provision only
$ vagrant up
$ vagrant halt
# normal startup
$ vagrant up
$ vagrant ssh
vagrant@azure-sql-dashboard:~$ cd /vagrant/src
# create dbconfig.yml
vagrant@azure-sql-dashboard:/vagrant/src$ vi dbconfig.yml
vagrant@azure-sql-dashboard:/vagrant/src$ bundle && dashing start
```

## License

[The MIT License](http://en.wikipedia.org/wiki/MIT_License). See LICENSE.
