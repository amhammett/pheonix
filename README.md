pheonix
=======

rising from the ashes

configure-apache.yml
--------------------
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

create-apache-instance.yml 
--------------------------
Create an apache instance for a site or site environment.

Run with 
```bash
    ./go-create-apache-instance.sh <HOST> <USER> <KEY>
```

Optionally, override web_user and/or web_group
```bash
    ./go-create-apache-instance.sh <HOST> <USER> <KEY> "web_user=other-user web_group=other-group"
```

#### create web directories
Create the structure for a site or environment. 

**todo: based under /var/www but basedir could be configured anywhere.*

```
   /var/www/_site_
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
        DocumentRoot /var/www/_site_/htdocs
        ServerName _site_
        ServerAlias _site_ 

        ## logs
        ErrorLog /var/www/_site_/logs/error.log
        CustomLog /var/www/_site_/logs/access.log common
        php_value error_log /var/www/_site_/logs/php_error.log
    </VirtualHost>
```

\_site\_  to be replaced by sitename provided

### reload apache
If new config files have been added then apache reload is required

**todo: is this possible without apache downtime?**

```bash
    service httpd start
```

destroy-apache-instance.yml 
----------------------------
Remove an apache instance for a site or site environment.

Run with 
```bash
    ./go-destroy-apache-instance.sh <HOST> <USER> <KEY>
```

### remove-apache-instance-conf
Delete site.conf in /etc/httpd/conf.d

### remove-apache-instance-directories
Delete /var/www/_site_ and all sub files/directories

### reload-apache
Reload apache to finish off the removal of the instance

deploy-site.yml
----------------
Deploy code/content to a site environment

### requirements
git repositories need to be structured

```files
    site.git
        \htdocs - html content
        \test   - test cases
```

Run with 
```bash
    ./go-deploy-site.sh <HOST> <USER> <KEY> <SITE>
```

Optionally, override web_user and/or web_group
```bash
    ./go-deploy-site.sh <HOST> <USER> <KEY> <SITE> "code-repo=foo.git site-repo=bar.git"
```

### prepare-launch-site
Prepare working area for site before cloning, integrating and deploying to hosting.

Create /tmp/deploy/<site> if it doesn't exist. Clear contents.

### clone-repository
clone the supplied repository to local in preparation for launching on target

```bash
    git clone code.git
    git clone data.git
```

### deploy-code
```ansible
    file: src=code/ dest=/var/www/<site>/htdocs/
    file: src=data/ dest=/var/www/<site>/htdocs/data/
```

### reload-apache
```ansible
    service: name=httpd state=reloaded
```

### verify-site
Both code and data have test 

```bash
    curl -s http://<site> | grep "health-check-string"
```

other
-----
    # create or use local ssh key
    # send to ec2 and add to known hosts
    # confirm permissions