#!/bin/bash

red=$'\e[1;31m'
blu=$'\e[1;34m'
mag=$'\e[1;35m'
cyn=$'\e[1;36m'
white=$'\e[0m'

echo ${cyn}"Building opendo-anim.swf"${white}

if
/Library/AIR50.2.2.2/bin/mxmlc \
src/Main.as \
-debug=false \
-target-player=50.0 \
-output=bin/opendo-anim.swf \
+flexlib=/Library/AIR50.2.2.2/frameworks \
+configname=air \
-source-path+=src \
-library-path+=lib/anim.swc \
-library-path+=lib/as3corelib.swc \
-library-path+=lib/blooddy_crypto.swc \
-library-path+=lib/com.distriqt.Core.ane \
-library-path+=lib/com.distriqt.Image.ane \
-library-path+=lib/com.distriqt.NetworkInfo.ane \
-library-path+=lib/com.distriqt.Scanner.ane \
-library-path+=lib/com.distriqt.Share.ane \
-library-path+=lib/greensock.swc \
-library-path+=/Library/AIR50.2.2.2/frameworks/libs/air/airglobal.swc \
-library-path+=/Library/AIR50.2.2.2/frameworks/libs/core.swc \
-library-path+=/Library/AIR50.2.2.2/frameworks/libs/air/aircore.swc \
-library-path+=/Library/AIR50.2.2.2/frameworks/libs/air/applicationupdater.swc \
-library-path+=/Library/AIR50.2.2.2/frameworks/libs/air/applicationupdater_ui.swc \
-library-path+=/Library/AIR50.2.2.2/frameworks/libs/air/servicemonitor.swc \
-external-library-path+=lib/com.distriqt.Core.ane \
-external-library-path+=lib/com.distriqt.Image.ane \
-external-library-path+=lib/com.distriqt.NetworkInfo.ane \
-external-library-path+=lib/com.distriqt.Scanner.ane \
-external-library-path+=lib/com.distriqt.Share.ane \
-static-link-runtime-shared-libraries=true \
-library-path+=/Library/AIR50.2.2.2/frameworks/locale/en_US \
-default-size=1920,1200 \
-creator=Matt \

then
echo ${mag}"Building opendo-anim.swf : Done !"${white}
echo ""
else
echo ${red}"Building opendo-anim.swf : Failed :/"${white}
echo ""
fi
