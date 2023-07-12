#!/bin/bash

red=$'\e[1;31m'
grn=$'\e[1;32m'
blu=$'\e[1;34m'
mag=$'\e[1;35m'
cyn=$'\e[1;36m'
white=$'\e[0m'

echo ${mag}"Package iOS Ad Hoc release"${white}

if
# Tools : Delete .DS_Store files
echo "Tools : Delete .DS_Store files"
find . -name '.DS_Store' -type f -delete

# Build opendo-part.swf
bash scripts/build-swf.sh

# Package iOS release Ad Hoc
bash scripts/app-ios-adhoc.sh

# Tools : Clean all unecessary files
echo "Tools : Clean all unecessary files"
rm -rf 'bin/opendo-part-descriptor.xml'
rm -rf 'bin/opendo-part.swf'
rm -rf 'bin/part.app.dSYM'

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
