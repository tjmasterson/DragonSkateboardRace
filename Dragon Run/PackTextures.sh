#!/bin/sh

TP="/usr/local/bin/TexturePacker"

#rm streetFighter/resources/chars/a_arnold_special_a.pvr.ccz
#rm streetFighter/resources/chars/a_arnold_special_a.plist

# ....
# add all files to be removed in clean phase
# ....
#create bg atlas
${TP} --smart-update \
--format cocos2d \
--padding 2 \
--data Game/Resources/atlas/atlas_common.plist \
--sheet Game/Resources/atlas/atlas_common.pvr \
Art/320/atlas_common/*.png

${TP} --smart-update \
--format cocos2d \
--padding 2 \
--data Game/Resources/atlas/atlas_gamepack.plist \
--sheet Game/Resources/atlas/atlas_gamepack.pvr \
Art/320/atlas_gamepack/*.png

${TP} --smart-update \
--format cocos2d \
--padding 2 \
--data Game/Resources/atlas/atlas_dragon.plist \
--sheet Game/Resources/atlas/atlas_dragon.pvr \
Art/320/atlas_dragon/*.png

${TP} --smart-update \
--format cocos2d \
--padding 2 \
--data Game/Resources/atlas/atlas_store.plist \
--sheet Game/Resources/atlas/atlas_store.pvr \
Art/320/atlas_store/*.png

${TP} --smart-update \
--format cocos2d \
--padding 2 \
--data Game/Resources/atlas-hd/atlas_common-hd.plist \
--sheet Game/Resources/atlas-hd/atlas_common-hd.pvr \
Art/640/atlas_common/*.png

${TP} --smart-update \
--format cocos2d \
--padding 0 \
--data Game/Resources/atlas-hd/atlas_gamepack-hd.plist \
--sheet Game/Resources/atlas-hd/atlas_gamepack-hd.pvr \
Art/640/atlas_gamepack/*.png

${TP} --smart-update \
--format cocos2d \
--padding 2 \
--data Game/Resources/atlas-hd/atlas_dragon-hd.plist \
--sheet Game/Resources/atlas-hd/atlas_dragon-hd.pvr \
Art/640/atlas_dragon/*.png

${TP} --smart-update \
--format cocos2d \
--padding 2 \
--data Game/Resources/atlas-hd/atlas_store-hd.plist \
--sheet Game/Resources/atlas-hd/atlas_store-hd.pvr \
Art/640/atlas_store/*.png

# ....
# add other sheets to create here
# ....
exit 0