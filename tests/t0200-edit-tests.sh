#!/bin/sh

test_description='Test edit'
. ./setup.sh

export TEST_CRED="test_cred"

test_expect_success 'Test "edit" command' '
	pass_init &&
	create_cred "$TEST_CRED" &&
	export EDITOR=$FAKE_EDITOR_PASSWORD_CHANGE &&
	${PASS} edit "$TEST_CRED" &&
	verify_password "$TEST_CRED" "$FAKE_EDITOR_PASSWORD" 
'

test_done
