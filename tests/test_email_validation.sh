#! /bin/bash

test_validate_mail() {
	mail="invalid.mail"
	validate_mail $mail
	assertFalse "expected $mail to be invalid" "$?"
	
	mail="v.mail@nowhere.com"
	validate_mail $mail
	assertTrue "expected $mail to be valid" "$?"
	
	mail="valid.mail@nowhere.com"
	validate_mail $mail
	assertTrue "expected $mail to be valid" "$?"
}

. $(dirname $0)/scaffolding.bash