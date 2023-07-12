#!/bin/bash

red=$'\e[1;31m'
blu=$'\e[1;34m'
mag=$'\e[1;35m'
cyn=$'\e[1;36m'
white=$'\e[0m'

echo ${cyn}"Packaging opendo-anim.aab"${white}

if /Library/AIR50.2.2.2/bin/adt \
-package \
-target \
aab \
-storetype \
pkcs12 \
-keystore \
../cert/Opendo_AndroidAutoSigning__exp_2291.p12 \
-storepass \
opend0 \
bin/opendo-anim.aab \
app-android.xml \
-platformsdk \
/Library/Android/sdk/ \
-extdir \
lib \
-C \
bin \
opendo-anim.swf \
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
bin/icons/Android/Android-36.png \
icons/Android/Android-36.png \
-e \
bin/icons/Android/Android-48.png \
icons/Android/Android-48.png \
-e \
bin/icons/Android/Android-72.png \
icons/Android/Android-72.png \
-e \
bin/icons/Android/Android-96.png \
icons/Android/Android-96.png \
-e \
bin/icons/Android/Android-144.png \
icons/Android/Android-144.png \
-e \
bin/icons/Android/Android-192.png \
icons/Android/Android-192.png \

then
echo ${mag}"Packaging opendo-anim.aab : Done !"${white}
echo ""
else
echo ${red}"Packaging opendo-anim.aab : Failed :/"${white}
echo ""
fi
