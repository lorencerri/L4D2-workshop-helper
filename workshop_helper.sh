if [ -z "$1" ]; then
	echo "Usage: sh ./workshop_helper.sh"
	echo "	install <steam_username> <workshop_id>"
	echo "	list"
	echo ""
	echo "Note: Commands require 'pip install vpk' to be installed."
fi

TMP_FOLDER="$PWD/workshop_tmp"
ADDONS_FOLDER="$PWD/serverfiles/left4dead2/addons/"

if [ "$1" = "install" ]; then
	if [ -z "$2" ] || [ -z "$3" ]; then
		echo "+ Usage: sh ./workshop_helper.sh install <steam_username> <workshop_id>"
	else
		echo "+ Installing '$3' from the workshop into $TMP_FOLDER"
		steamcmd +force_install_dir $TMP_FOLDER +login $2 +workshop_download_item 550 $3 +quit
		echo "\n\n+ Downloaded the following *.bin files from workshop item $3:"
		for file in $(find "$TMP_FOLDER" -name '*.bin')
		do
			echo "  - $file"
			mv -- "$file" "${file%.bin}.vpk"
		done
		echo "    + Changed all of the file extensions from .bin to .vpk!"
		echo "    + Installed Maps:"
		for file in $(find "$TMP_FOLDER" -name '*.vpk')
		do
			vpk -l "$file" | grep "^maps/.*bsp" | while read line; do echo "      - $line"; done
			mv -- "$file" "$ADDONS_FOLDER"
		done
		echo "    ? You can use 'changelevel [mapname]' to switch to the map."
		echo "  + Moved all *.vpk files to $ADDONS_FOLDER"
		echo "+ Cleaning up files...\n"
		rm -rf "$TMP_FOLDER"
		echo "Done!"
	fi
elif [ "$1" = "list" ]; then
	echo "Listing all .vpk files in $ADDONS_FOLDER:\n"
	for file in $(find "$ADDONS_FOLDER" -name '*.vpk')
	do
		echo "+ $file:"
		echo "  + Maps:"
		vpk -l "$file" | grep "^maps/.*bsp" | while read line; do echo "    - $line"; done
		echo "  ? You can use 'changelevel [mapname]' to switch to the map.\n"
	done
	echo "Done!"
fi
