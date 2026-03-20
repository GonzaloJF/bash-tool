#!/bin/bash
#exit function
function ctrl_c (){
	echo -e "\n\n [!] Saliendo... \n\n"
	exit 1
}

#invoque exit function
trap ctrl_c INT

DIRECTORY="$1"

if [ -z "$DIRECTORY" ]; then
	echo -e " You need to pass a directory like /home/<user>/Documents "

elif [ ! -d "$DIRECTORY" ]; then
	echo -e " Te parameter is not a directory"
else
	mkdir -p "$DIRECTORY/scripts"
	mkdir -p "$DIRECTORY/logs"
	mkdir -p "$DIRECTORY/docs"

	find "$DIRECTORY" -type f -name "*.sh" | while IFS= read -r archive; do
		echo -e " [+] Route archive: $archive"
		mv "$archive" "$DIRECTORY/scripts"
	done
	find "$DIRECTORY" -type f -name "*.log" | while IFS= read -r archive; do
		echo -e " [+] Route archive: $archive"
		mv "$archive" "$DIRECTORY/logs"
	done
	find "$DIRECTORY" -type f -name "*.txt" | while IFS= read -r archive; do
		echo -e " [+] Route archive: $archive"
		mv "$archive" "$DIRECTORY/docs"
	done
fi

