#!/bin/bash
DIRECTORY=$(dirname $0)
. "$DIRECTORY"/log.sh
. "$DIRECTORY"/lib.sh


function docker.attachBash() {
	
	HELP="$(basename "$0") [ path ] [ filename ]-- Find files in directory 

where:
    path  the path to start counting files
    filename  the filename to search(wildcards supported)"
		
	show_help "$#" 1 "$HELP"

	docker exec -it "$1" bash
}

function docker.attachSh() {
	docker exec -it "$1" sh
}

function docker.attach() {
	if (($# != 2)); then
		printf "[ ERROR ] Wrong Argument Length"
		printf "[ USAGE ] docker.attach {{container-id|name}} {{bash|sh}}"
	else

		docker exec -it "$1" "$2"
	fi

}


"$@"
