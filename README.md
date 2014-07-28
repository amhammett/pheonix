pheonix
=======

rising from the ashes

## configure-apache.yml

run with 
./go-configure-apache.sh <HOST> <USER> <KEY>

optionally, override web_user and/or web_group
./go-configure-apache.sh <HOST> <USER> <KEY> "web_user=other-user web_group=other-group"

### install-apache-packages
```bash
    yum install httpd php
````

### create-web-users
```bash
    sudo groupadd web
    sudo useradd -G web -m <user>
    # set password - don't need this 
    passwd <user>
    # create or use local ssh key
    # send to ec2 and add to known hosts
    # confirm permissions
```

### create apache instance

#### create web directories
structure is based under /var/www but could be configured anywhere.
todo: set basedir as var
.../var/www/<site>
....../htdocs
....../logs

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
all site.conf files follow the same format.
```xml
    <VirtualHost *:80>
        DocumentRoot /var/www/<site>/htdocs
        ServerName <site>
        ServerAlias <site>

        ## logs
        ErrorLog /var/www/<site>/logs/error.log
        CustomLog /var/www/<site>/logs/access.log common
        php_value error_log /var/www/<site>/logs/php_error.log
    </VirtualHost>
```

### re/start apache
if new config files have been added then apache reload/restart is required
todo: is this possible without apache downtime?
```bash
    service httpd start
```
