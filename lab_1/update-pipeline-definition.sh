#!/bin/bash - 
#===============================================================================
#
#          FILE: update-pipeline-definition.sh
# 
#         USAGE: ./update-pipeline-definition.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Daler Abdullaev (admin), daler_abdullaev@epam.com
#  ORGANIZATION: 
#       CREATED: 03/19/2023 09:34:57 AM
#      REVISION:  ---
#===============================================================================

DATA="$1"
DATE=`date +%d-%m-%Y`
NEW_DATA="pipeline-$DATE.json"
tmp="./tmp_var.json"
BRANCH="main"
OWNER=""
REPO=""
POLL_FOR_CHANGES=false
CONFIG=""

checkJQ() {

  which jq >/dev/null 2>&1
  exit_status=$?
  if [ "$exit_status" -eq 1 ]; then
    echo "jq not found"
    echo "installation guide"
    echo "MacOS: brew install jq"
    echo "Debian: sudo apt install jq -y"
    exit 1
  else
    echo "jq found"
  fi
}

checkPath(){
  if test -f "$DATA"; then
    echo "$DATA exists."
  else
    echo "File $DATA not found"
    exit 1
  fi
}

checkParams() {
if [ -z $CONFIG ] || [ -z $OWNER ]; then
  echo "Lack of additional params, exit..."
  exit 1
fi
}

checkJQ
checkPath


LONG=branch:,owner:,repo:,configuration:,poll-for-source-changes:,help

OPTS=$(getopt -a -n pipeline --longoptions $LONG -- "$@")

eval set -- "$OPTS"

# Read options
while true; do
 # echo "whiling $1"
	case "$1" in
		--branch)
      BRANCH="$2"
      shift 2;;
		--owner)
			OWNER="$2"
      shift 2;;
    --repo)
      REPO="$2"
      shift 2;;
    --poll-for-source-changes)
      POLL_FOR_CHANGES="$2"
      shift 2;;
    --configuration)
      CONFIG="$2"
      shift 2;;
    --)
      break;;
     *)
			 break;;
	 esac
 done

#Check if metadata prop exists
jq -e '.metadata' "$DATA" >/dev/null
if [ "$?" -eq 1 ] ; then
 echo "Metadata property does not exists"
 exit 1;
fi

# (i) The metadata property is removed.
jq 'del(.metadata)' $DATA > "$NEW_DATA"

#Check if version prop exists
jq -e '.pipeline.version' "$NEW_DATA" >/dev/null
if [ "$?" -eq 1 ] ; then
  echo "version key not found"
  exit 1
fi

# (ii) The value of the pipeline’s version property is incremented by 1.
VERSION=`jq '.pipeline.version' "$NEW_DATA"`

jq --arg version "$((VERSION+1))" '.pipeline.version = ($version)' "$NEW_DATA" > "$tmp" && mv "$tmp" "$NEW_DATA"
# Check if additional params (config, owner), otherwise do not continue rest of operations
checkParams

# WRITE TO NEW FILE
# UPDATE EnvironmentVariables
jq --arg config $CONFIG '.pipeline.stages[1] | .actions[0].configuration.EnvironmentVariables | fromjson | .[].value= ($config) | tojson' "$NEW_DATA" > tmp.env_config

ENV_VAR=`cat ./tmp.env_config`
rm ./tmp.env_config

jq --arg branch "$BRANCH" --arg owner "$OWNER" --arg poll "$POLL_FOR_CHANGES" '.pipeline.stages[0].actions[0].configuration.Branch = ($branch) | .pipeline.stages[0].actions[0].configuration.Owner = ($owner) | .pipeline.stages[0].actions[0].configuration.PollForSourceChanges = ($poll) ' "$NEW_DATA" > "$tmp" && mv "$tmp" "$NEW_DATA"

jq --arg env_var $ENV_VAR '( .pipeline.stages[] | .actions[] | select(.configuration.EnvironmentVariables != null)).configuration.EnvironmentVariables = ($env_var)' "$NEW_DATA" > "$tmp" && mv "$tmp" "$NEW_DATA"

