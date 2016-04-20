function setUp() {
	SRC_DIR=$(dirname $0)/../src
	
	CONFIG=${SRC_DIR}/config.bash
	# import config properties
	. ${CONFIG}
	
    # import functions 
	. ${FUNCTIONS}
    
    # override with test config
	if [ -f $(dirname $0)/config.bash ]; then
    	. $(dirname $0)/config.bash
    fi
        
    # override with mocked functions
	if [ -f $(dirname $0)/functions.bash ]; then
    	. $(dirname $0)/functions.bash
    fi
    
	#override env for test output
	LOG=/$TEMP_DIR/testrunner.log
		
    [[ "$DEBUG" == true || "$DEBUG" -eq 1 ]] && set -x
    [ "x$(type -t local_setUp)" != "x" ] && local_setUp 
}

function tearDown() {
    [[ "$DEBUG" == true || "$DEBUG" -eq 1 ]] && set +x
    [ "x$(type -t local_tearDown)" != "x" ] && local_tearDown
}

function suite() {
	for testcase in ${TEST_CASES} ; do
	   	[[ ! $testcase =~ test_ ]] && testcase="test_$testcase"
	   	echo "adding test to suite: $testcase"
	    suite_addTest $testcase
	done
}

. /usr/share/shunit2/shunit2