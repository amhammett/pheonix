pheonix
=======

rising from the ashes

## configure-apache.yml
The usual tasks that are required to create apache instances. 

Run with 
```bash
    ./go-configure-apache.sh <HOST> <USER> <KEY>
```

Optionally, override web_user and/or web_group
```bash
    ./go-configure-apache.sh <HOST> <USER> <KEY> "web_user=other-user web_group=other-group"
```

### install-apache-packages
Install apache and related packages.

Below is the equivalent manual process of installing packages but this functionality is provided using the Ansible yum module.

```bash
    yum install httpd php
```

#### modify-apache-configuration
Make any required changes to apache.

By default, apache has this configuration disabled. enabled to allow site-specific site.conf files

> /etc/httpd/conf/httpd.conf
> enable, remove '#'
> NameVirtualHost *:80

### create-web-users
Create the generic user and group to maintain sites.

Below is the equivalent manual process of creating users/groups but this functionality is provided using the Ansible user and group module. 

```bash
    sudo groupadd web
    sudo useradd -G web -m <user>
    # set password - don't need this 
    passwd <user>
```

## create-apache-instance.yml 
Create an apache instance for a site or site environment.

Run with 
```bash
    ./go-configure-apache.sh <HOST> <USER> <KEY>
```

Optionally, override web_user and/or web_group
```bash
    ./go-configure-apache.sh <HOST> <USER> <KEY> "web_user=other-user web_group=other-group"
```

#### create web directories
Create the structure for a site or environment. 

**todo: based under /var/www but basedir could be configured anywhere.*

```
   /var/www/\_site\_
      /htdocs
      /logs
```
\_site\_ to be replaced by sitename provided

#### set correct permissions
When the above directories are created they are built with web user and web group ownership.

Manually, this process would be completed by

```bash
    chown -R webuser
    chgrp -R webgroup
    chmod -R 775 /var/www
```

#### site.conf
Apache instance configuration defined in site.conf. All site.conf files follow the same format.

```xml
    <VirtualHost *:80>
        DocumentRoot /var/www/\_site\_ /htdocs
        ServerName \_site\_ 
        ServerAlias \_site\_ 

        ## logs
        ErrorLog /var/www/\_site\_ /logs/error.log
        CustomLog /var/www/\_site\_ /logs/access.log common
        php_value error_log /var/www/\_site\_ /logs/php_error.log
    </VirtualHost>
```

\_site\_  to be replaced by sitename provided

### re/start apache
If new config files have been added then apache reload/restart is required

**todo: is this possible without apache downtime?**

```bash
    service httpd start
```

### other

    # create or use local ssh key
    # send to ec2 and add to known hosts
    # confirm permissions