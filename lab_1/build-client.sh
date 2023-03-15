#!/bin/bash - 
#===============================================================================
#
#          FILE: build-client.sh
# 
#         USAGE: ./build-client.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Daler Abdullaev (admin), daler_abdullaev@epam.com
#  ORGANIZATION: 
#       CREATED: 03/14/2023 09:32:19 PM
#      REVISION:  ---
#===============================================================================

# ENV_CONFIGURATION="development"

echo "running npm install..."
npm install
echo "Packages installed"
echo "running build command..."
npm run build --configuration=$ENV_CONFIGURATION
echo "build finished"

# check if file exists, if so remove it and proceed to build
zip -r client-app.zip dist/
