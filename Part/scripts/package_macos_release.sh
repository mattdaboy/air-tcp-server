#!/bin/bash

red=$'\e[1;31m'
grn=$'\e[1;32m'
blu=$'\e[1;34m'
mag=$'\e[1;35m'
cyn=$'\e[1;36m'
white=$'\e[0m'

echo ${mag}"Package macOS release + Sign operations"${white}

if
# Tools : Delete .DS_Store files
echo "Tools : Delete .DS_Store files"
find . -name '.DS_Store' -type f -delete

# Build opendo-part.swf
bash scripts/build-swf.sh

# Package macOS release
bash scripts/app-mac.sh

# Tools : Clean all unecessary files
echo "Tools : Clean all unecessary files"
rm -rf 'bin/opendo-part-descriptor.xml'
rm -rf 'bin/opendo-part.swf'
rm -rf 'bin/part.app.dSYM'

# Tools : Clean macOS App Store folder
echo "Tools : Clean macOS App Store folder"
rm -rf 'bin/macOS App Store/Opendo Part.app'
rm -rf 'bin/macOS App Store/Opendo Part.pkg'
rm -rf 'bin/macOS App Store/Opendo Part.app.zip'

# Tools : Sign Store for Opendo Part.app
echo "Tools : Sign Store for Opendo Part.app"
cd ../macOS_sign_store/
bash Opendo_part_sign_store.sh
cd ../Part

# Tools : Move signed Opendo Part.app & Opendo Part.pkg to macOS App Store folder
echo "Tools : Move signed Opendo Part.app & Opendo Part.pkg to macOS App Store folder"
mv -f '../macOS_sign_store/Opendo Part.app' 'bin/macOS App Store/Opendo Part.app'
mv -f '../macOS_sign_store/Opendo Part.pkg' 'bin/macOS App Store/Opendo Part.pkg'

# Tools : Zip signed Opendo Part.app in macOS App Store folder
echo "Tools : Zip signed Opendo Part.app in macOS App Store folder"
cd 'bin/macOS App Store/'
zip -yrqdgds 1m 'Opendo Part.app.zip' 'Opendo Part.app'
rm -rf 'Opendo Part.app'

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
