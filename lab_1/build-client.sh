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

# check if ENV_CONFIG set, otherwise set to development
if [[ -z $ENV_CONFIGURATION ]]; then
	ENV_CONFIGURATION="development"
else
	ENV_CONFIGURATION="production"
fi

# Build artifacts path
BUILD_ARTIFACTS='client-app.zip'

echo "running npm install..."
npm install
echo "Packages installed"

echo "--------running build command...--------"
npm run build --configuration $ENV_CONFIGURATION
echo "--------build finished--------"

# check if file exists, if so remove it and proceed to build

if [[ -f "$BUILD_ARTIFACTS" ]]; then
	echo "Found old $BUILD_ARTIFACTS"
	echo "Removing..."
	rm -rf "$BUILD_ARTIFACTS"
fi
echo "Compressing build artifacts:"
cd dist/ && zip -r "../$BUILD_ARTIFACTS" .
