#!/bin/sh

test_description='Sanity checks'
. ./setup.sh

test_expect_success 'Make sure we can run pass' '
	${PASS} --help | grep "pass: the standard unix password manager"
'
test_done
