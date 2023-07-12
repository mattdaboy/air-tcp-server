#!/bin/bash

red=$'\e[1;31m'
grn=$'\e[1;32m'
blu=$'\e[1;34m'
mag=$'\e[1;35m'
cyn=$'\e[1;36m'
white=$'\e[0m'

echo ${cyn}"Packaging Opendo Part.app"${white}

if /Library/AIR50.2.2.2/bin/adt \
-package \
-storetype \
pkcs12 \
-keystore \
../cert/Opendo_Self-signed_CodeSigning__exp_2024_07_11.p12 \
-storepass \
opend0 \
-tsa \
http://timestamp.digicert.com \
-target \
bundle \
"bin/Opendo Part.app" \
app-mac.xml \
-extdir \
lib \
-C \
bin \
opendo-part.swf \
-C \
bin \
assets \
-C \
bin \
database \
-C \
bin \
htdocs \
-e \
bin/icons/Desktop/Desktop-16.png \
icons/Desktop/Desktop-16.png \
-e \
bin/icons/Desktop/Desktop-32.png \
icons/Desktop/Desktop-32.png \
-e \
bin/icons/Desktop/Desktop-36.png \
icons/Desktop/Desktop-36.png \
-e \
bin/icons/Desktop/Desktop-48.png \
icons/Desktop/Desktop-48.png \
-e \
bin/icons/Desktop/Desktop-72.png \
icons/Desktop/Desktop-72.png \
-e \
bin/icons/Desktop/Desktop-114.png \
icons/Desktop/Desktop-114.png \
-e \
bin/icons/Desktop/Desktop-128.png \
icons/Desktop/Desktop-128.png \

then
echo ${mag}"Packaging Opendo Part.app : Done !"${white}
echo ""
else
echo ${red}"Packaging Opendo Part.app : Failed :/"${white}
echo ""
fi
