pheonix
=======

rising from the ashes

## configure-apache.yml

run with 
```bash
    ./go-configure-apache.sh <HOST> <USER> <KEY>
```

optionally, override web_user and/or web_group
```bash
    ./go-configure-apache.sh <HOST> <USER> <KEY> "web_user=other-user web_group=other-group"
```

### install-apache-packages
below is the equivalent manual process of installing packages but this functionality is provided using the ansible yum module.
```bash
    yum install httpd php
```

### create-web-users
below is the equivalent manual process of creating users/groups but this functionality is provided using the ansible user and group module. 
```bash
    sudo groupadd web
    sudo useradd -G web -m <user>
    # set password - don't need this 
    passwd <user>
    # create or use local ssh key
    # send to ec2 and add to known hosts
    # confirm permissions
```

## create-apache-instance.yml 

run with 
```bash
    ./go-configure-apache.sh <HOST> <USER> <KEY>
```

optionally, override web_user and/or web_group
```bash
    ./go-configure-apache.sh <HOST> <USER> <KEY> "web_user=other-user web_group=other-group"
```

#### create web directories
structure is based under /var/www but basedir could be configured anywhere.
todo: set basedir as var
.../var/www/_site_
....../htdocs
....../logs
_site_ to be replaced by sitename provided

#### set correct permissions
simple permission structure. web user and web group ownership. 
```bash
    chown -R webuser
    chgrp -R webgroup
    chmod -R 775 /var/www
```

#### enable virtualhost *:80
by default, apache has this configuration disabled. enabled to allow site-specific site.conf files
> /etc/httpd/conf/httpd.conf
> enable, remove '#'
> NameVirtualHost *:80

#### site.conf
all site.conf files follow the same format. _site_ to be replaced by sitename provided
```xml
    <VirtualHost *:80>
        DocumentRoot /var/www/_site_/htdocs
        ServerName _site_
        ServerAlias _site_

        ## logs
        ErrorLog /var/www/_site_/logs/error.log
        CustomLog /var/www/_site_/logs/access.log common
        php_value error_log /var/www/_site_/logs/php_error.log
    </VirtualHost>
```

### re/start apache
if new config files have been added then apache reload/restart is required
todo: is this possible without apache downtime?
```bash
    service httpd start
```
