#! /bin/bash

local_setUp() {
	OUTPUT_DIR=/tmp/certgenerator
	mkdir -p $OUTPUT_DIR
}

local_tearDown() {
	rm -rf $OUTPUT_DIR
}

_assert_identites() {
	assertEquals "incorrect number of identities" "$1" "${#idents[@]}"
}

test_parse_identity_argument() {
	unset idents
	declare -g -A idents
	parse_identity 'testid=Test User:testuser@nowhere.com'
	_assert_identites 1
}

test_parse_identity_file() {
	unset idents
	declare -g -A idents
	parse_identities_file $(dirname $0)/identities
	_assert_identites 5
}

test_create_keyfiles() {
	_assert_identites 4
	
	let i=0
	for ident in idents; do
		keyfile=$OUTPUT_DIR/${!ident[$i]}_${SERVER_ID}.key
		[ -f "$keyfile" ] && assertTrue "$keyfile was not created" "$?"
		(( i++ ))
	done
}

. $(dirname $0)/scaffolding.bash
