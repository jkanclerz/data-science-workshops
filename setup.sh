#!/usr/bin/env sh

#DNS
echo "nameserver 8.8.8.8" > /etc/resolv.conf
echo "nameserver 8.8.4.4" >> /etc/resolv.conf

#development
apk --update add gcc g++ linux-headers

#tools
apk add git curl unzip
#python
apk --update add python3 python3-dev

clear
python3 -c "import this"

read -n 1 -s -r -p "Press any key to continue"
echo ""
echo "Your ip address:"
ip -4 addr show | grep inet | tr -s " " | cut -d" "  -f3



##
apk add postgresql
rc-service postgresql start

psql -U postgres -c "CREATE ROLE datascience LOGIN PASSWORD 'datascience';";
psql -U postgres -c "CREATE DATABASE datascience WITH OWNER = datascience;";
psql -U datascience -c "select 1;";
