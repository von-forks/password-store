# This file should be sourced by all test-scripts
#
# This scripts sets the following:
#   ${GNUPGHOME} Full path to test GPG directory
#   ${PASS}      Full path to password-store script to test.
#   ${PASSWORD_STORE_KEY}  GPG key id of testing key

readonly PASS=$( cd ../ ; echo $(pwd)/pass ; )

if test -e ${PASS} ; then
	echo "pass is ${PASS}"
else
	echo "Could not find 'pass' script. Did you run make?"
	exit 1
fi

#
# GNNUPG configuration

# Where the test keyring and test key id
# Note: the assumption is the test key is unencrypted.
export GNUPGHOME=$(pwd)"/gnupg/"
chmod 700 "$GNUPGHOME"
export PASSWORD_STORE_KEY=3DEEA12D  # "Password-store Test Key"

# pass_init()
#
# Initialize a password store, setting PASSWORD_STORE_DIR
#
# Arguments: None
# Returns: Nothing, sets PASSWORD_STORE_DIR
pass_init() {
	export PASSWORD_STORE_DIR=${SHARNESS_TRASH_DIRECTORY}/test-store/
	echo "Initializing test password store (${PASSWORD_STORE_DIR}) with key ${PASSWORD_STORE_KEY}"

	[[ -d "${PASSWORD_STORE_DIR}" ]] || rm -rf "${PASSWORD_STORE_DIR}"

	# This curently returns non-zero for unknown reasons.
	# Only happens with stdin set to /dev/null.
	# I suspect the agent check.
	# TODO:  Once fixed, catch non-zero here and fail.
	${PASS} init ${PASSWORD_STORE_KEY} || true

	echo "Initilization of ${PASSWORD_STORE_DIR} complete."
}

# check_cred()
#
# Check to make sure the given credential looks valid.
# Meaning it exists and has at least one line.
#
# Arguments: <credential name>
# Returns: 0 if valid looking, 1 otherwise
check_cred() {
	[[ "$#" -eq 1 ]] || { echo "$0: Bad arguments" ; return 1 ; }
	local cred="$1" ; shift ;
	echo Checking credential ${cred}
	${PASS} show "$cred" || { echo "Credential ${cred} does not exist" ; return 1 ; }
	line_count=$(${PASS} show "$cred" | wc -l)
	[[ "$line_count" -gt 0 ]] || { echo "Credential ${cred} empty" ; return 1 ; }
}
	
# check_no_cred()
#
# Check to make sure the given credential does not exist.
# Use to validate removal, moving, etc.
#
# Arguments: <credential name>
# Returns: 0 if credential does not exist, 1 otherwise
check_no_cred() {
	[[ "$#" -eq 1 ]] || { echo "$0: Bad arguments" ; return 1 ; }
	local cred="$1" ; shift ;
	echo Checking for lack of credential ${cred}
	${PASS} show "$cred" || return 0 
	echo "Credential ${cred} exists."
	return 1
}

# create_cred()
#
# Create a credential with the given name.
#
# Arguments: <credential name>
# Returns: 0 on success, 1 otherwise.
create_cred() {
	[[ "$#" -eq 1 ]] || { echo "$0: Bad arguments" ; return 1 ; }
	local cred="$1" ; shift ;
	${PASS} generate "${cred}" 24 > /dev/null || { echo "Failed to create credential ${cred}" ; return 1 ; }
	return 0
}
	

# Initialize the test harness
. ./sharness.sh
