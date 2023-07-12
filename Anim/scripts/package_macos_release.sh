#!/bin/bash

red=$'\e[1;31m'
blu=$'\e[1;34m'
mag=$'\e[1;35m'
cyn=$'\e[1;36m'
white=$'\e[0m'

echo ${mag}"Package macOS release + Sign operations"${white}

if
# Tools : Delete .DS_Store files
echo "Tools : Delete .DS_Store files"
find . -name '.DS_Store' -type f -delete

# Build opendo-anim.swf
bash scripts/build-swf.sh

# Tools : Copy opendo-anim.swf into build directory
echo "Tools : Copy opendo-anim.swf into build directory"
cp bin/opendo-anim.swf bin/build/opendo-anim.swf

# Build opendo-anim-auto-update.swf
bash scripts/build-swf-auto.sh

# Package macOS release
bash scripts/app-mac-auto.sh

# Tools : Clean all unecessary files
echo "Tools : Clean all unecessary files"
rm -rf 'bin/opendo-anim-descriptor.xml'
rm -rf 'bin/opendo-anim.swf'
rm -rf 'bin/opendo-anim-auto-update.swf'
rm -rf 'bin/Opendo Anim.app.dSYM'

# Tools : Clean macOS App Store folder
echo "Tools : Clean macOS App Store folder"
rm -rf 'bin/macOS App Store/Opendo Anim.app'
rm -rf 'bin/macOS App Store/Opendo Anim.pkg'
rm -rf 'bin/macOS App Store/Opendo Anim.app.zip'

# Tools : Sign Store for Opendo Anim.app
echo "Tools : Sign Store for Opendo Anim.app"
cd ../macOS_sign_store/
bash Opendo_anim_sign_store.sh
cd ../Anim

# Tools : Move signed Opendo Anim.app & Opendo Anim.pkg to macOS App Store folder
echo "Tools : Move signed Opendo Anim.app & Opendo Anim.pkg to macOS App Store folder"
mv -f '../macOS_sign_store/Opendo Anim.app' 'bin/macOS App Store/Opendo Anim.app'
mv -f '../macOS_sign_store/Opendo Anim.pkg' 'bin/macOS App Store/Opendo Anim.pkg'

# Tools : Zip signed Opendo Anim.app in macOS App Store folder
echo "Tools : Zip signed Opendo Anim.app in macOS App Store folder"
cd 'bin/macOS App Store/'
zip -yrqdgds 1m 'Opendo Anim.app.zip' 'Opendo Anim.app'
rm -rf 'Opendo Anim.app'

then
echo ${mag}"Package macOS release + Sign operations : Done :)"
echo ${cyn}""
echo ${cyn}"          ***************                                                                                                       **,                   "
echo ${cyn}"      *,, ******************                                                                                                    **,                   "
echo ${cyn}"    ***  *********************,                                                                                                 **,                   "
echo ${cyn}"  ***********.       ***********              .*******      ************          .*******          .*******          .*******  **,     .*******      "
echo ${cyn}" *********.             *********           ***       ***   ***         ***     ***       ***     ***       ***     ***       ****,   ***       ***   "
echo ${cyn}" ********                *********        ,**           **  **.           **  ***           **  ,**           **  ,**           **, ,**           **  "
echo ${cyn}" ********                .********        **.           **, **.           **, ***************** **.           **, **.           **, **.           *** "
echo ${cyn}" ********                ********,        ,**           **  ***           **  .**               **.           **, ,**           **, .**           **  "
echo ${cyn}" ,********,             *********           ***      ****   *****      ****     ***.     **     **.           **,   ***         **,   ***      ****   "
echo ${cyn}"  ,**********,       ***********               ******,      ***  ******,           ******,      **            **.      ***********.      ******,      "
echo ${cyn}"    **************************                              **.                                                                                       "
echo ${cyn}"      **********************                                **.                                                                                       "
echo ${cyn}"          **************                                    **.                                                                                       "
echo ${white}""
else
echo ${red}"Package macOS release + Sign operations : Failed :/"${white}
echo ""
fi
