#!/bin/sh

test_description='Test insert'
. ./setup.sh

export TEST_CRED="test_cred"
export TEST_PASSWORD="Hello world"

# Exposes some bug with 'insert -e' returning non-zero despite working.
test_expect_failure 'Test "insert" command' '
	pass_init &&
	echo "$TEST_PASSWORD" | ${PASS} insert -e "$TEST_CRED" &&
	check_cred "$TEST_CRED" &&
	${PASS} show "$TEST_CRED" > from-insert &&
	echo "$TEST_PASSWORD" > expected &&
	test_cmp from-insert expected
'

test_done
