#!/bin/bash
DIRECTORY=$(dirname $0)
. "$DIRECTORY"/log.sh
. "$DIRECTORY"/lib.sh

function files.cp() {

	HELP="files.cp [source-path] [destination-path] -- Copy files using rsync and status bar

where:
    source-path  the path folder containing file(s) to copy from | path to a single file
    destination-path  the path to place the files"

	if [[ "$OSTYPE" == "darwin"* ]]; then
		FCNT=$(rsync -r --dry-run --stats --human-readable "$1" "$2" | grep -E 'Number of regular files transferred: ([0-9]+)' | grep -o -E '[0-9]+')
		((FCNT += 5))
		rsync -rav --ignore-existing "$1" "$2" | pv -pteabl -s "$FCNT" >/dev/null
	else
		show_help "$#" 2 "$HELP"
		dryrun=$(rsync -avh --dry-run --info=progress2 "$1" "$2")
		filesToBeCopied=$(echo "$dryrun" | grep -m 1 'to-chk')
		filesToBeCopied=$(echo "$filesToBeCopied" | sed 's/.*to-chk=[[:digit:]]\+\/\([[:digit:]]\+\))/\1/g')
		bytesToBeCopied=$(echo "$dryrun" | grep 'total size' | sed 's/total size is //g' | sed 's/ speedup .*//g' )
		pr_info "Total Files: [ $(echo "$filesToBeCopied" | xargs ) ]"
		pr_info "Total Size: [ $(echo "$bytesToBeCopied" | xargs ) ]"
		rsync -rav --stats --human-readable "$1" "$2" | pv -pteabl -s $(((filesToBeCopied += 18))) >/dev/null
	fi
}

function files.countFiles() {
	HELP="files.countFiles [ path ] -- Count files in directory 

where:
    path  the path to count files from"

	show_help "$#" 1 "$HELP"
	CMD="find $1 -maxdepth 1 -type f 2>/dev/null | wc -l;"
	RES=$(eval "$CMD")
	check_command_result "$?" "$CMD" "Files: [ $RES ]"
}

function files.countFilesRecursively() {
	HELP="files.countFilesRecursively [ path ] -- Count files in directory recursively

where:
    path  the path to start counting files from"
	show_help "$#" 1 "$HELP"
	CMD="find $1 -type f 2>/dev/null | wc -l;"
	RES=$(eval "$CMD")
	check_command_result "$?" "$CMD" "Files: [ $RES ]"

}

function files.findFiles() {
	HELP="files.findFiles [ path ] [ filename ]-- Find files in directory 

where:
    path  the path to start counting files
    filename  the filename to search(wildcards supported)"

	show_help "$#" 2 "$HELP"
	CMD="find $1 -type f -iname 's*'"
	RES=$(eval "$CMD")
	FILE_COUNT=$(echo "$RES" | wc -l)
	check_command_result "$?" "$CMD" "Files Found: [ $FILE_COUNT ]\n$RES"

}

function files.directorySizeHuman() {
	# show_help "$#" 2 "$FILES_DIRECTORYSIZEHUMAN_HELP"
	# du -h --max-depth="$1" "$2" 2>/dev/null;s
	HELP="files.directorySizeHuman [ path ] -- Calculated directory size

where:
    path  the path to calculate the size for"

	show_help "$#" 1 "$HELP"
	CMD="rsync -avzh -n --stats $1 . | grep 'total size is ' | sed -E 's/(total size is )([[:digit:]]+\.?[[:digit:]]+[KMGT]?)(.*)/\2/g'"
	RES=$(eval "$CMD")
	check_command_result "$?" "$CMD" "Size: [ $RES ]"
}
function http.downloadFilesRecursively() {
	HELP="http.downloadFilesRecursively [ site ] -- Download files from site

where:
    site  the site(path) to start downloading"

	show_help "$#" 1 "$HELP"

	CMD="wget -r -np -R index.html* $1;"
	FILES=$(eval "$CMD")
	check_command_result "$?" "$CMD" "Download Status [ √ ]"
}

function http.directorySize() {
	HELP="http.directorySize [ site ] -- Show remote directory size

where:
    site  the site(path) to calculate its size"

	show_help "$#" 1 "$HELP"
	CMD="rclone size --http-url $1 :http:;"
	FILES=$(eval "$CMD")
	check_command_result "$?" "$CMD" "Files: [ $FILES ]"
}
# function http.directorySize() { rclone size --http-url "$1" :http: -v --tpslimit 5 --bwlimit 500K --checkers 100 --fast-list; }

"$@"
