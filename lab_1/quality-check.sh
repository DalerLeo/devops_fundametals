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

#npm run lint && npm run test && npm audit
npm run test 2> /dev/null
