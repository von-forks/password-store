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

#
# GNNUPG configuration

# Where the test keyring and test key id
# Note: the assumption is the test key is unencrypted.
export GNUPGHOME=$(pwd)"/gnupg/"
export PASSWORD_STORE_KEY=3DEEA12D  # "Password-store Test Key"

# Initialize a password store, setting PASSWORD_STORE_DIR
pass_init() {
	export PASSWORD_STORE_DIR=${SHARNESS_TRASH_DIRECTORY}/test-store/
	echo "Initializing test password store (${PASSWORD_STORE_DIR}) with key ${PASSWORD_STORE_KEY}"

	# This curently returns non-zero for unknown reasons.
	# Only happens with stdin set to /dev/null.
	# I suspect the agent check.
	# TODO:  Once fixed, catch non-zero here and fail.
	${PASS} init ${PASSWORD_STORE_KEY} || true

	echo "Initilization of ${PASSWORD_STORE_DIR} complete."
}


# Initialize the test harness
. ./sharness.sh
