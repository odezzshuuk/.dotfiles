#!/usr/bin/env bash

get_last_workspace_index_for_output() {
	local output_name="$1"

	niri msg workspaces | awk -v output_name="$output_name" '
		$0 ~ /^Output "/ {
			in_output = ($0 == "Output \"" output_name "\":")
			next
		}

		in_output && match($0, /[0-9]+/) {
			last_index = substr($0, RSTART, RLENGTH)
		}

		END {
			if (last_index != "") {
				print last_index
				exit 0
			}

			exit 1
		}
	'
}

CURRENT_OUTPUT=$(niri msg focused-output | head -n 1 | sed -n 's/.*(\(.*\))$/\1/p')
LAST_WORKSPACE_INDEX=$(get_last_workspace_index_for_output "$CURRENT_OUTPUT")

echo "Creating new workspace on output $CURRENT_OUTPUT"
echo "Last workspace index on $CURRENT_OUTPUT: $LAST_WORKSPACE_INDEX"

