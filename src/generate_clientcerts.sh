#! /bin/bash

SRC_DIR=$(dirname $0)

CONFIG=$SRC_DIR/config.bash

# import config properties
. ${CONFIG}
	
# import functions 
. $SRC_DIR/functions.bash
	
function usage() {
cat << EOF

Usage: $(basename $0) [-f <input_file> | -i <id='name:email'>]

OPTIONS:
-h	show this message
-f	file name that contains the identities to use when creating certificates.
	The file needs to build an associative array of identities to their name
	and email values (EOF is marked by a blank line):
		ident1=ident 1:ident.1@comdev.ca
		ident2=ident 2:ident.2@comdev.ca
		...
	
-i	identity tuple of the form 'id="First Last:email"'
-o	output directory (defaults to $SRC_DIR/out) 

Default behaviour is to read in the contents of a file named identities in the 
same directory as this script ($SRC_DIR).

EOF
}

declare -A idents

while getopts ":f:i:o:h" OPTION; do
	case $OPTION in
		f)
		parse_identities_file $OPTARG
			[ "$?" -ne 0 ] && echo "Invalid identities file format."
		;;
		h)
			usage
			exit 0
		;;
		i)
			IFS=""
			parse_identity $OPTARG
		;;
		o)
			OUTPUT_DIR=$OPTARG
		;;
		*)
			usage
			RETVAL=1
		;;
	esac
done

[ ${#idents[@]} -eq 0 ] && usage && RETVAL=1 

if [[ "$RETVAL" -ne 1 ]]; then
	create_csr
	generate_certs
	generate_p12
	
	RETVAL=0
fi

IFS=" "

exit $RETVAL
