# Azure SQL Database Monitoring Dashboard

Build on top of [Dashing](http://dashing.io/).

## Configuration

TODO: set up database user for monitoring.

Database connection is configured in file `src/dbconfig.yml`:

FreeTDS may have issues with passwords longer than 30 characters!

```yaml
---
host: '<SERVERNAME>.database.windows.net'
username: '<USERNAME>@<SERVERNAME>'
password: '<PASSWORD>'
database: '<DATABASENAME>'
```

## Development Environment

Uses [Vagrant](https://www.vagrantup.com/) - `Vagrantfile` included:

```bash
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

## Further Reading

* Database Journal: [Monitoring Azure SQL Database](http://www.databasejournal.com/features/mssql/monitoring-azure-sql-database.html) by Marcin Policht (6th Nov 2014)
* MSDN: Azure SQL Database [sys.resource_stats](http://msdn.microsoft.com/en-us/library/dn269979.aspx)

## License

[The MIT License](http://en.wikipedia.org/wiki/MIT_License). See LICENSE.
