#! /bin/bash

local_setUp() {
	OUTPUT_DIR=/tmp/certgenerator
	mkdir -p $OUTPUT_DIR
	touch "$OUTPUT_DIR/ident1_buildsrv.csr"
	touch "$OUTPUT_DIR/ident1_buildsrv.crt"
	touch "$OUTPUT_DIR/ident1_buildsrv.key"
	touch "$OUTPUT_DIR/ident2_buildsrv.csr"
	touch "$OUTPUT_DIR/ident2_buildsrv.crt"
	touch "$OUTPUT_DIR/ident2_buildsrv.key"
	touch "$OUTPUT_DIR/ident3_buildsrv.csr"
	touch "$OUTPUT_DIR/ident3_buildsrv.crt"
	touch "$OUTPUT_DIR/ident3_buildsrv.key"
	touch "$OUTPUT_DIR/ident4_buildsrv.csr"
	touch "$OUTPUT_DIR/ident4_buildsrv.crt"
	touch "$OUTPUT_DIR/ident4_buildsrv.key"
}

local_tearDown() {
	rm -rf $OUTPUT_DIR
}

test_generate_p12_given_valid_certs_and_keys() {
	generate_p12

	for ext in p12; do
		let ${ext}_count=$(ls -B ${OUTPUT_DIR} | egrep --regexp=".${ext}" | wc -l)
	done
	
	assertEquals "pem count wrong" "4" "$p12_count"
}

. $(dirname $0)/scaffolding.bash