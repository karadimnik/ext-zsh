#!/bin/bash
DIRECTORY=$(dirname $0)
. "$DIRECTORY"/log.sh
. "$DIRECTORY"/lib.sh


pr_info "
while IFS= read -r line; do
	'logic' "\$line"
done <<< "\$variable""
