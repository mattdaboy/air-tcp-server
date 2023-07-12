#!/bin/bash

red=$'\e[1;31m'
grn=$'\e[1;32m'
blu=$'\e[1;34m'
mag=$'\e[1;35m'
cyn=$'\e[1;36m'
white=$'\e[0m'

echo ${cyn}"Packaging opendo-part.ipa"${white}

if /Library/AIR50.2.2.2/bin/adt \
-package \
-target \
ipa-app-store \
-storetype \
pkcs12 \
-keystore \
../cert/Opendo_ios_distribution__exp_2024_04_05.p12 \
-storepass \
opend0 \
-provisioning-profile \
../cert/Opendo_App_Store_distribution__exp_2024_04_05.mobileprovision \
bin/opendo-part.ipa \
app-ios.xml \
-extdir \
lib \
-C \
bin \
opendo-part.swf \
-e \
bin/Assets.car \
Assets.car \
-e \
bin/splashscreens/Default-568h@2x~iphone.png \
Default-568h@2x~iphone.png \
-e \
bin/splashscreens/Default-Landscape-1194h@2x~ipad.png \
Default-Landscape-1194h@2x~ipad.png \
-e \
bin/splashscreens/Default-Landscape-1336h@2x~ipad.png \
Default-Landscape-1336h@2x~ipad.png \
-e \
bin/splashscreens/Default-Landscape-568h@2x~iphone.png \
Default-Landscape-568h@2x~iphone.png \
-e \
bin/splashscreens/Default-Landscape-568h~iphone.png \
Default-Landscape-568h~iphone.png \
-e \
bin/splashscreens/Default-Landscape-667h@2x~iphone.png \
Default-Landscape-667h@2x~iphone.png \
-e \
bin/splashscreens/Default-Landscape-736h@3x~iphone.png \
Default-Landscape-736h@3x~iphone.png \
-e \
bin/splashscreens/Default-Landscape-812h@3x~iphone.png \
Default-Landscape-812h@3x~iphone.png \
-e \
bin/splashscreens/Default-Landscape-896h@3x~iphone.png \
Default-Landscape-896h@3x~iphone.png \
-e \
bin/splashscreens/Default-Landscape-960h@2x~iphone.png \
Default-Landscape-960h@2x~iphone.png \
-e \
bin/splashscreens/Default-Landscape@2x~ipad.png \
Default-Landscape@2x~ipad.png \
-e \
bin/splashscreens/Default-Landscape~ipad.png \
Default-Landscape~ipad.png \
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
bin/icons/iOS/AppIcon76x76@1x~ipad.png \
icons/iOS/AppIcon76x76@1x~ipad.png \
-e \
bin/icons/iOS/AppIcon76x76@2x~ipad.png \
icons/iOS/AppIcon76x76@2x~ipad.png \
-e \
bin/icons/iOS/AppIcon83.5x83.5@2x~ipad.png \
icons/iOS/AppIcon83.5x83.5@2x~ipad.png \
-e \
bin/icons/iOS/AppIcon20x20@3x~iphone.png \
icons/iOS/AppIcon20x20@3x~iphone.png \
-e \
bin/icons/iOS/AppIcon60x60@2x~iphone.png \
icons/iOS/AppIcon60x60@2x~iphone.png \
-e \
bin/icons/iOS/AppIcon60x60@3x~iphone.png \
icons/iOS/AppIcon60x60@3x~iphone.png \
-e \
bin/icons/iOS/AppIcon29x29@1x~ipad.png \
icons/iOS/AppIcon29x29@1x~ipad.png \
-e \
bin/icons/iOS/AppIcon29x29@2x~iphone.png \
icons/iOS/AppIcon29x29@2x~iphone.png \
-e \
bin/icons/iOS/AppIcon29x29@3x~iphone.png \
icons/iOS/AppIcon29x29@3x~iphone.png \
-e \
bin/icons/iOS/AppIcon40x40@1x~ipad.png \
icons/iOS/AppIcon40x40@1x~ipad.png \
-e \
bin/icons/iOS/AppIcon40x40@2x~iphone.png \
icons/iOS/AppIcon40x40@2x~iphone.png \
-e \
bin/icons/iOS/AppIcon1024x1024@1x~ios-marketing.png \
icons/iOS/AppIcon1024x1024@1x~ios-marketing.png \

then
echo ${mag}"Packaging opendo-part.ipa : Done !"${white}
echo ""
else
echo ${red}"Packaging opendo-part.ipa : Failed :/"${white}
echo ""
fi
