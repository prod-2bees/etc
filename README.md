# config files for an smtp server from http://ubuntuwiki.net/index.php/Postfix,_Virtual_Domain_Setup

* user accounts
   make sure that the postfix user uid=1024, gid=1024 before installing postfix
```
   ( groupadd -g 1024 postfix; groupadd -g 1025 postdrop; groupadd -g 1026 postprox; useradd -u 1024 -g 1024 -d /dev/null -s /bin/false postfix;useradd -u 1025 -g 1025 -s /bin/false postdrop;useradd -u 1026 -g 1026 -s /bin/false postprox )
   ( cd /home;mkdir vmail;chown postfix:postfix vmail;chmod 770 vmail )
```

* install lamp-server^
```
apt-get -y install lamp-server^
```
* link apache configs
```
ln -s /home/etc/apache2/sites-enabled/* /etc/apache2/sites-enabled/
ln -s /home/etc/apache2/ports.conf /etc/apache2/ports.conf
```

* install postfixadmin
```
( cd /home/etc/src;dpkg -i postfixadmin_2.3.6-1_all.deb;apt-get install -y -f )
```
* link require files apache2, postfixadmin
```
( cd /etc/apache2/site-enabled;ln -s /home/etc/apache2/site-enabled/* . )
( cd /etc;mv postfixadmin postfixadmin-ORIG;ln -s /home/etc/postfixadmin . )
```
* make postfix mysql database
```
cat /home/etc/bin/reate-postfix-mysql.sh | mysql -u root -p
```

* install postfix support files for mysql, sasl
```
apt-get -y install postfix-mysql libsasl2-modules-sql libsasl2-modules
```

* link postfix
```
( cd /etc;mv postfix postfix-ORIG;ln -s /home/etc/postfix .)
newaliases
```

* install postfix support files for imap/pop
```
apt-get -y install dovecot-common dovecot-imapd dovecot-mysql dovecot-pop3d
```

* install spamass, etc
```
apt-get -y install clamav clamav-daemon spamassassin spamc
```

* turn spamass on
```
cp /home/etc/default/spamassassin /etc/default/spamassassin
```

* to restart all mail services
```
/home/etc/bin/restart-mail
```

# Updated - migrated to nginx
