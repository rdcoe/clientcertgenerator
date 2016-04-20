#! /bin/bash

local_setUp() {
	OUTPUT_DIR=/tmp/certgenerator
	mkdir -p $OUTPUT_DIR
	touch "$OUTPUT_DIR/ident1_buildsrv.csr"
	touch "$OUTPUT_DIR/ident1_buildsrv.key"
	touch "$OUTPUT_DIR/ident2_buildsrv.csr"
	touch "$OUTPUT_DIR/ident2_buildsrv.key"
	touch "$OUTPUT_DIR/ident3_buildsrv.csr"
	touch "$OUTPUT_DIR/ident3_buildsrv.key"
	touch "$OUTPUT_DIR/ident4_buildsrv.csr"
	touch "$OUTPUT_DIR/ident4_buildsrv.key"
}

local_tearDown() {
	rm -rf $OUTPUT_DIR
}

test_create_certificates_using_default_duration() {
	generate_certs

	for ext in csr crt; do
		let ${ext}_count=$(ls -B ${OUTPUT_DIR} | egrep --regexp=".${ext}" | wc -l)
	done
	
	assertEquals "csr count wrong" "4" "$csr_count"
	assertEquals "failed to create the correct number of certs" "$csr_count" "$crt_count"
}

. $(dirname $0)/scaffolding.bash