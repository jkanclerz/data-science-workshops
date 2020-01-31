#!/usr/bin/env sh

#DNS
echo "nameserver 8.8.8.8" > /etc/resolv.conf
echo "nameserver 8.8.4.4" >> /etc/resolv.conf
echo "options ndots:5" >> /etc/resolv.conf

#CRONTAB 
echo '*       *       *       *       *       echo -e "nameserver 8.8.8.8 \nnameserver 8.8.4.4\noptions ndots:5\n" > /etc/resolv.conf' > /etc/crontabs/root

rc-service crond restart

#REPOS
echo "http://ftp.icm.edu.pl/pub/Linux/distributions/alpine/v3.10/main" > /etc/apk/repositories
echo "http://ftp.icm.edu.pl/pub/Linux/distributions/alpine/v3.10/community" >> /etc/apk/repositories
echo "#http://ftp.icm.edu.pl/pub/Linux/distributions/alpine/edge/main" >> /etc/apk/repositories
echo "#http://ftp.icm.edu.pl/pub/Linux/distributions/alpine/edge/community" >> /etc/apk/repositories
echo "#http://ftp.icm.edu.pl/pub/Linux/distributions/alpine/edge/testing" >> /etc/apk/repositories

#development
apk --update add gcc g++ linux-headers libffi-dev openssl-dev

#tools
apk add git curl unzip
#python
apk --update add python3 python3-dev cython

##
apk add postgresql
rc-update add postgresql
rc-service postgresql start
##psql
psql -U postgres -c "CREATE ROLE datascience LOGIN PASSWORD 'datascience';";
psql -U postgres -c "CREATE DATABASE datascience WITH OWNER = datascience;";
psql -U datascience -c "select 1;";

##docker
apk add docker
rc-update add docker
rc-service docker start

#compose
pip3 install docker-compose

#mongo

result=$( docker container ps -a | grep mongodb )

if [[ -n "$result" ]]; then
  echo "Container exists"
  #uncomment if recreate
  #docker rm -f mongodb; docker run -dit -p 27017:27017 --restart unless-stopped --name mongodb mongo:3-xenia
else
  docker run -dit -p 27017:27017 --restart unless-stopped --name mongodb mongo:3-xenial
fi


clear;
python3 -c "import this";

read -n 1 -s -r -p "Press any key to continue"
echo ""
echo "Your ip address:"
ip -4 addr show | grep inet | tr -s " " | cut -d" "  -f3
echo ""
echo "psql is available via: localhost:5432 user: datascience pw: datascience"
echo "example: psql -U datascience datascience 5432"
echo 'exmaple: psql -U datascience -h 127.0.0.1 -p 5432 -c "select now;"'

echo ""

echo "mongodb is available via: localhost:27017"
echo ""
