#!/bin/bash
. ./factorio_updater.conf
echo $FACTORIO_ROOT

FACTORIO_UPDATER_FILENAME_CURL=$(curl -sIL  https://www.factorio.com/get-download/latest/headless/linux64 | grep -o -E 'filename=.*$' | sed -e 's/filename=//')
FACTORIO_UPDATER_FILENAME="$(sed -e 's/[[:space:]]*$//' <<<${FACTORIO_UPDATER_FILENAME_CURL})"
FACTORIO_UPDATER_FOLDER=$(basename $FACTORIO_UPDATER_FILENAME .tar.xz)

pushd $FACTORIO_ROOT > /dev/null

if [ -z $FACTORIO_UPDATER_FILENAME ] ; then
	echo "Error while getting version information."
	exit -1
fi

if [ -e ./factorio ]; then
	echo "Ambiguous folder 'factorio' exists..."
	exit -4
fi

FACTORIO_CURRENT_VERSION=$(echo $FACTORIO_UPDATER_FILENAME | sed -e 's/factorio_headless_x64_//' | sed -e 's/.tar.xz//')

if [ ! -e $FACTORIO_UPDATER_FILENAME ]; then
	echo Downloading new version $FACTORIO_CURRENT_VERSION.
	curl -sJLO https://www.factorio.com/get-download/latest/headless/linux64 || exit -2
	echo Extracting...
	tar xJf $FACTORIO_UPDATER_FILENAME || exit -3
	if [ -e ./$FACTORIO_UPDATER_FOLDER ]; then
		echo "Folder '$FACTORIO_UPDATER_FOLDER' exists... Deleting."
		rm -r $FACTORIO_UPDATER_FOLDER
	fi
	mv factorio $FACTORIO_UPDATER_FOLDER
	echo Done.
else
	echo Newest version $FACTORIO_CURRENT_VERSION already downloaded.
fi

popd > /dev/null
