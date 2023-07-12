#!/bin/bash

red=$'\e[1;31m'
blu=$'\e[1;34m'
mag=$'\e[1;35m'
cyn=$'\e[1;36m'
white=$'\e[0m'

echo ${mag}"Package iOS Ad Hoc release"${white}

if
# Tools : Delete .DS_Store files
echo "Tools : Delete .DS_Store files"
find . -name '.DS_Store' -type f -delete

# Build opendo-anim.swf
bash scripts/build-swf.sh

# Package iOS release Ad Hoc
bash scripts/app-ios-adhoc.sh

# Tools : Clean all unecessary files
echo "Tools : Clean all unecessary files"
rm -rf 'bin/opendo-anim-descriptor.xml'
rm -rf 'bin/opendo-anim.swf'
rm -rf 'bin/opendo-anim-auto-update.swf'
rm -rf 'bin/Opendo Anim.app.dSYM'

then
echo ${mag}"Package iOS Ad Hoc release : Done :)"
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
echo ${red}"Package iOS Ad Hoc release : Failed :/"${white}
echo ""
fi
