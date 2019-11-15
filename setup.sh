#!/usr/bin/env sh

#development
apk --update add gcc g++ linux-headers

#tools
apk add git
#python
apk --update add python3 python3-dev

clear
python -c "import this"

