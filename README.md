pheonix
=======

rising from the ashes

### configure-apache.yml

run with 
./go-configure-apache.sh <HOST> <USER> <KEY>

optionally, override web_user and/or web_group
./go-configure-apache.sh <HOST> <USER> <KEY> "web_user=other-user web_group=other-group"

#### install apache
```bash
    yum install httpd php
````

#### create user and groups access
```bash
    sudo groupadd web
    sudo useradd -G web -m <user>
    # set password - don't need this 
    passwd <user>
    # create or use local ssh key
    # send to ec2 and add to known hosts
    # confirm permissions
```

#### create apache instance
##### create web directories
.../var/www/<site>
....../htdocs
....../logs

##### set correct permissions
```bash
    chown -R ..
    chgrp -R ..
    chmod -R 775 /var/www
```

##### enable virtualhost *:80
> NameVirtualHost *:80 in httpd.conf

##### site.conf
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

#### re/start apache
```bash
    service httpd start
```
