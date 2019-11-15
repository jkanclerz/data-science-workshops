#!/usr/bin/env sh

#development
apk --update add gcc g++ linux-headers

#tools
apk add git
#python
apk --update add python3 python3-dev

clear
python3 -c "import this"

read -n 1 -s -r -p "Press any key to continue"
echo ""
echo "Your ip address:"
ip -4 addr show | grep inet | tr -s " " | cut -d" "  -f3
