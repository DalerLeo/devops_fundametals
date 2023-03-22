#!/bin/bash - 
#===============================================================================
#
#          FILE: quality-check.sh
# 
#         USAGE: ./quality-check.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Daler Abdullaev (admin), daler_abdullaev@epam.com
#  ORGANIZATION: 
#       CREATED: 03/14/2023 10:01:07 PM
#      REVISION:  ---
#===============================================================================

checkStatus() {
	exit_status=$?
	if [ "$exit_status" -eq 1 ]; then
		echo "$1 has errors, please check "$1" process"
		exit 1
	fi
}

npm run lint >/dev/null 2>&1
checkStatus "Linting"

npm run build >/dev/null 2>&1
checkStatus "Build"

npm audit >/dev/null 2>&1
checkStatus "Auditing"

