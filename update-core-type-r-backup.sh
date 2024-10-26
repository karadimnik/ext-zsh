#!/bin/bash

DIRECTORY=$(dirname $0)
. "$DIRECTORY"/log.sh
. "$DIRECTORY"/lib.sh


BACKUP_FILE="/mnt/f/_backup.log"
ISDEBUG=false

#############################
# db = delete backup first  #
# dl = delete log           #
#############################

if [ "$#" == 1 ]; then
	if [[ "${1}" == "db" ]]; then
		rm -rf backup/*
	fi

	if [[ "${1}" == "dl" ]]; then
		echo "" > backup/_backup.log
		echo "" > "$BACKUP_FILE"
	fi
fi

if [ "$#" == 2 ]; then
	if [[ "${1}" == "db" ]] || [[ "${2}" == "db" ]]; then
		rm -rf backup/*
	fi

	if [[ "${1}" == "dl" ]] || [[ "${2}" == "dl" ]]; then
		echo "" > backup/_backup.log
	fi
fi

# crontab -e
# 0 0 * * * /path/to/backup.sh
SOURCE_DIRS=(
	"/mnt/d/CORE - TYPE R/"
)
if [[ "${ISDEBUG}" == "true" ]]; then
	SOURCE_DIRS=(
		"test/"
	)
fi

# Folders or files to exclude from the backup
EXCLUDE_DIRS=(
	"collections/"
	# "emulators/rpcs3/"
	# "emulators/Supermodel/"
	# "emulators/TeknoParrot/"
	# "emulators/VITA3K/"
	# "emulators/xemu/"
	# "emulators/xenia/"
	# "emulators/3dSen/"
	# "emulators/Arcade 64/"
	# "emulators/Cemu/"
	# "emulators/Dolphin/"
	# "emulators/Dolphin Triforce/"
	# "emulators/m2emulator/"
	# "emulators/mame/"
	# "emulators/PCSX2/"
	# "emulators/PPSSPP/"
)

# Backup destination directory
DESTINATION="/mnt/f/CORE - TYPE R/"

if [[ "${ISDEBUG}" == "true" ]]; then
	DESTINATION=(
		"backup/"
	)
fi

# Log file for the backup process
LOG_FILE="/mnt/f/_backup.log"

if [[ "${ISDEBUG}" == "true" ]]; then
	LOG_FILE=(
		"backup/_backup.log"
	)
fi

# Function to perform the backup
backup() {
	local source=$1
	local exclude_opts=()

	# Prepare the exclude options for rsync
	for exclude in "${EXCLUDE_DIRS[@]}"; do
		exclude_opts+=("--exclude=$exclude")
	done 

	# dryrun=$(rsync -avh --dry-run --stats --ignore-existing "$source" "$DESTINATION")
	# filesToBeCopied=$(echo "$dryrun" | grep 'Number of files:' | sed 's/Number of files: //g' | sed 's/ speedup .*//g' )
	# bytesToBeCopied=$(echo "$dryrun" | grep 'Total transferred file size' | sed 's/Total transferred file size: //g' | sed 's/ speedup .*//g' )
	# pr_info "Total Files: [ $(echo "$filesToBeCopied" | xargs ) ]" 
	# pr_info "Total Size: [ $(echo "$bytesToBeCopied" | xargs ) ]" 
	# echo "	Total Files: [ $filesToBeCopied ]" >> "$LOG_FILE"
	# echo "	Total Size: [ $bytesToBeCopied ]" >> "$LOG_FILE"
	# rsync -avh --stats --progress --human-readable --ignore-existing "$source" "$DESTINATION"  | paste /dev/null - >> "$LOG_FILE" 2>&1
	rsync -ruavh --stats --progress --human-readable "$source" "$DESTINATION"  | paste /dev/null - >> "$LOG_FILE" 2>&1
	# rsync  -avh  --info=progress2 --progress --human-readable --ignore-existing "$source" "$DESTINATION" >>"$LOG_FILE" 2>&1
	# rsync -rav --progress --ignore-existing "${exclude_opts[@]}" "$source" "$DESTINATION" >>"$LOG_FILE" 2>&1
}

# Start the backup process
startTime=$(date)
echo ">>>>>> BACKUP PROCESS <<<<<<" >>"$LOG_FILE"
echo "	Started at [ $startTime ]" >>"$LOG_FILE"
for dir in "${SOURCE_DIRS[@]}"; do
	echo "	Backing up $dir to $DESTINATION" >>"$LOG_FILE"
	backup "$dir"
done
endTime=$(date)
echo "	Completed at [ $endTime ]" >>"$LOG_FILE"

START_EPOCH=$(date -d "${startTime}" +%s)
END_EPOCH=$(date -d "${endTime}" +%s)
# Calculate the duration in seconds
DURATION=$((END_EPOCH - START_EPOCH))
if (( "$DURATION" > 60 )); then
	echo "	Duration [ $((${DURATION}/60))m ] " >>"$LOG_FILE"
else
	echo "	Duration [ ${DURATION}s ] " >>"$LOG_FILE"
fi


# echo "	AVG Tran [ ${bytesToBeCopied}/${DURATION}MB/s] "
echo -e "*********************************************************" >> "$LOG_FILE"
echo -e "" >>"$LOG_FILE"
