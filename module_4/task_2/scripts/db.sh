#!/bin/bash - 
#===============================================================================
#
#          FILE: db.sh
# 
#         USAGE: ./db.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Daler Abdullaev (admin), daler_abdullaev@epam.com
#  ORGANIZATION: 
#       CREATED: 03/12/2023 08:49:31 PM
#      REVISION:  ---
#===============================================================================

USERS="../data/users.db"

checkInput ()
{
	rx='[a-zA-Z]'
	if [[ ! "$1" =~ $rx ]]; then
    echo "Input must be latin letters!"
    exit 0
  fi
}	# ----------  end of function checkInput  ----------
add ()
{	
	
  read -p "Username: " username
	checkInput $username
	read -p "role: " role
	checkInput $role
  
  echo "$username, $role"
	echo "$username, $role" >> "$USERS"

}	# ----------  end of function add  ----------


backup ()
{
	d=`date +%d-%m-%Y`
	cp ../data/users.db ../data/"$d.users.db.backup"
	echo "Backup completed"
}	# ----------  end of function backup  ----------


restore ()
{
	last_backup=../data/`ls -AU ../data/ | tail -1`

	cp ../data/"$last_backup" "$USERS"
	echo "Restored"
}	# ----------  end of function restore  ----------



findEntity ()
{
	read -p "Enter username: " username

	isMatch=`cat "$USERS" | grep "$username"`
	if [[ -z "$isMatch" ]]; then
		echo "User Not Found"
		while read -r line; do
			echo "$line" | grep "$username"
		done < "$USERS"
	else
		while read -r line; do
			echo "$line" | grep "$username"
		done < "$USERS"
		
	fi
	
}	# ----------  end of function findEntity  ----------


listEntities ()
{
	if [[ "$1" = '--inverse' ]]; then
		nl "$USERS" | sort -nr
	else
		nl "$USERS"
	fi
}	# ----------  end of function listEntities  ----------


help ()
{
	echo "db.sh <argument>"
	echo "Arguments" 
	echo "add - prompts user to input username and role and append entity to database"
	echo "backup - creates backup of database"
	echo "restore - restores database with lastest backup available"
	echo "find - finds entity, by user entered username"
	echo "list - shows all entities in database. include --inverse to list entities in reverse order"
}	# ----------  end of function help  ----------


if [[ "$1" = 'add' ]] ; then
	add
elif [[ "$1" = 'backup' ]] ; then
	backup
	echo "Creates a new file, named %date%-users.db.backup which is a copy of current users.db"
elif [[ "$1" = 'restore' ]] ; then
	restore
elif [[ "$1" = 'find' ]] ; then
	findEntity
elif [[ "$1" = 'list' ]] ; then
	listEntities "$2"
elif [[ -z "$1" || "$1" == 'help' ]] ; then
	help
fi
