#!/bin/bash

set -ue
SRC_PATH=$(readlink -e $(dirname $0))

THEME=${1:-}
test -z "${THEME}" &&
  echo "usage: $0 PRESET_NAME [OUTPUT_THEME_NAME]" &&
  exit 1

PATHLIST=(
	'./openbox-3/'
	'./gtk-2.0/'
	'./gtk-3.0/'
	'./gtk-3.20/'
	'./xfwm4/'
	'./metacity-1/'
	'./unity/'
	'Makefile'
)

if [[ ${THEME} == /* ]] ; then
	source $THEME
	THEME=$(basename ${THEME})
else
	source $SRC_PATH/colors/$THEME
fi
source $SRC_PATH/current_colors.txt

OUTPUT_THEME_NAME=${2-oomox-$THEME}
DEST_PATH=~/.themes/${OUTPUT_THEME_NAME/\//-}

test "$SRC_PATH" = "$DEST_PATH" && echo "can't do that" && exit 1

rm -r $DEST_PATH || true
mkdir -p $DEST_PATH
cp -r $SRC_PATH/index.theme $DEST_PATH
for FILEPATH in "${PATHLIST[@]}"; do
	cp -r $SRC_PATH/$FILEPATH $DEST_PATH
done


cd $DEST_PATH
for FILEPATH in "${PATHLIST[@]}"; do
	find $FILEPATH -type f -exec sed -i \
		-e 's/'"$OLD_BG"'/'"$BG"'/g' \
		-e 's/'"$OLD_FG"'/'"$FG"'/g' \
		-e 's/'"$OLD_SEL_BG"'/'"$SEL_BG"'/g' \
		-e 's/'"$OLD_SEL_FG"'/'"$SEL_FG"'/g' \
		-e 's/'"$OLD_TXT_BG"'/'"$TXT_BG"'/g' \
		-e 's/'"$OLD_TXT_FG"'/'"$TXT_FG"'/g' \
		-e 's/'"$OLD_MENU_BG"'/'"$MENU_BG"'/g' \
		-e 's/'"$OLD_MENU_FG"'/'"$MENU_FG"'/g' \
		-e 's/'"$OLD_BTN_BG"'/'"$BTN_BG"'/g' \
		-e 's/'"$OLD_BTN_FG"'/'"$BTN_FG"'/g' \
		{} \; ;
done

make

exit 0
