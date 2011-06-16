#!/bin/bash
#before install check DB setting in 
#	judge.conf 
#	hustoj-read-only/web/include/db_info.inc.php
#	and down here
#and run this with root

#CENTOS/REDHAT/FEDERA WEBBASE=/var/www/html APACHEUSER=apache 
WEBBASE=/var/www/
APACHEUSER=www-data
DBUSER=root
DBPASS=root

#try install tools
sudo apt-get install flex g++ libmysql++-dev php5 apache2 mysql-server php5-mysql subversion

sudo yum -y update
sudo yum -y install php httpd php-mysql mysql-server php-xml php-gd gcc-c++  mysql-devel 

sudo svn checkout http://hustoj.googlecode.com/svn/trunk/ hustoj-read-only

#create user and homedir
sudo useradd -m -u 1536 judge



#compile and install the core
cd hustoj-read-only/core/
sudo ./make.sh
cd ../..
#install web and db
sudo cp -R hustoj-read-only/web $WEBBASE/JudgeOnline
sudo chmod -R 771 $WEBBASE/JudgeOnline
sudo chown -R $APACHEUSER $WEBBASE/JudgeOnline
sudo mysql -h localhost -u$DBUSER -p$DBPASS < db.sql

#create work dir set default conf
sudo    mkdir /home/judge
sudo    mkdir /home/judge/etc
sudo    mkdir /home/judge/data
sudo    mkdir /home/judge/log
sudo    mkdir /home/judge/run0
sudo    mkdir /home/judge/run1
sudo    mkdir /home/judge/run2
sudo    mkdir /home/judge/run3
sudo cp java0.policy  judge.conf /home/judge/etc
sudo chown -R judge /home/judge
sudo chgrp -R $APACHEUSER /home/judge/data
sudo chgrp -R root /home/judge/etc /home/judge/run?
sudo chmod 771 /home/judge/data /home/judge/etc /home/judge/run?

#boot up judged
sudo cp judged /etc/init.d/judged
sudo chmod +x  /etc/init.d/judged
sudo ln -s /etc/init.d/judged /etc/rc3.d/S93judged
sudo ln -s /etc/init.d/judged /etc/rc2.d/S93judged
sudo /etc/init.d/judged start
