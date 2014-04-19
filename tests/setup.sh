# This file should be sourced by all test-scripts
#
# This scripts sets the following:
#   ${PASS}      Full path to password-store script to test.

readonly PASS=$( cd ../src/ ; echo $(pwd)/password-store.sh ; )

if test -e ${PASS} ; then
	echo "pass is ${PASS}"
else
	echo "Could not find password-store.sh"
	exit 1
fi

. ./sharness.sh
