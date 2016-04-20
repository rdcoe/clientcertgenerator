parse_identities_file() {
	while read line; do
		parse_identity "$line"
	done < $1
}

parse_identity() {
set -x
	IFS=":"
	id=$(echo "$1" | cut -d '=' -f 1)
	tuple=$(echo "$1" | cut -d '=' -f 2)
	idents+=( ["$id"]="$tuple" )
	IFS=" "
set +x
}

create_csr() {
	mkdir -p $OUTPUT_DIR
	IFS=":"
	for id in ${!idents[@]}; do
		read name email <<< "${idents[$id]}"
		keyfile=$OUTPUT_DIR/${id}_${SERVER_ID}.key
		csrfile=$OUTPUT_DIR/${id}_${SERVER_ID}.csr
		openssl req -new -out $csrfile -keyout $keyfile -nodes -newkey rsa:2048 -subj /CN="$name"/emailAddress=$email
		[ "$?" -ne 0 ] && echo "failed create csr for $id"
	done
	IFS=" "
}

validate_mail() {
	[[ "$1" =~ .*@.* ]]
	return $?
}

generate_certs() {
	if [ "$#" -eq 1 ]; then
		duration=$1
	else
		duration=$CERT_VALID_FOR
	fi
	
	for id in ${!idents[@]}; do
		csr=$OUTPUT_DIR/${id}_${SERVER_ID}.csr
		crt=$OUTPUT_DIR/${id}_${SERVER_ID}.crt
		[ ! -f "$csr" ] && echo "missing csr file \""$csr"\".  Skipping..." && continue 
		openssl x509 -req -in $csr -CAkey ${SERVER_KEY} -CA ${SERVER_CERT} -days $duration \
-set_serial $RANDOM -sha512 -out "$crt"
		[ "$?" -ne 0 ] && echo "failed to generate a certificate for $id"
	done
}

generate_p12() {
	for id in ${!idents[@]}; do
		crt=$OUTPUT_DIR/${id}_${SERVER_ID}.crt
		[ ! -f "$crt" ] && echo "missing crt file \""$crt"\".  Skipping..." && continue
		keyfile=$OUTPUT_DIR/${id}_${SERVER_ID}.key
		openssl pkcs12 -export -out $OUTPUT_DIR/${id}_${SERVER_ID}.p12 -inkey ${keyfile} \
-in $crt -certfile ${SERVER_CERT} -passout "pass:"
		[ "$?" -ne 0 ] && echo "failed to generate a pcks12 archive for $id"
	done
}
