#!/bin/sh

test_description='Test insert'
. ./setup.sh

export TEST_CRED="test_cred"
export TEST_PASSWORD="Hello world"

# This fails because 'pass insert' doesn't realize stdin is not
# interactive and requests the password twice to verify it.
test_expect_failure 'Test "insert" command' '
	pass_init &&
	echo "TEST_PASSWORD" | ${PASS} insert "$TEST_CRED" &&
	check_cred "$TEST_CRED" &&
	${PASS} show "$TEST_CRED" > from-insert &&
	echo "$TEST_PASSWORD" > expected &&
	test_cmp from-insert expected
'

test_done
