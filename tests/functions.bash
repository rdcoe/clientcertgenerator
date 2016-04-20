#! /bin/bash

unset idents
declare -g -A idents
idents=( [ident1]="ident 1:ident.1@comdev.ca" )
idents+=( [ident2]="ident 2:ident.2@comdev.ca" )
idents+=( [ident3]="ident 3:ident.3@comdev.ca" )
idents+=( [ident4]="ident 4:ident.4@comdev.ca" )

function openssl() {
	while (( "$#" )); do
		arg="$1"
		if [[ "$arg" == "-out" || "$arg" == "-keyout" ]]; then
			shift
			touch "$1"
		fi
		shift
	done
}
	