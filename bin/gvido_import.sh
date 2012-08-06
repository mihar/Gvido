#!/bin/bash

# UTF HAX
# $ cat gvido2.sql | sed s/'Ä'/'č'/g | sed s/'Å¾'/'ž'/g | sed s/'Å¡'/'š'/g | sed s/'Å½'/'Ž'/g | sed s/'Å¼'/'Ž'/g | sed s/'ÄŒ'/'Č'/g | sed s/'Å '/'Š'/g > gvido.sql

if [ ! -f "gvido.sql" ]; then
  echo "FILERR: Missing gvido.sql data file."
  exit 1
fi

if [ -z $1 ]; then
  echo "ARGERR: Missing environment."
  echo
  echo "Usage: $0 <environment> <database>"
  exit 1
else
  railsenv=$1
fi

if [ -z $2 ]; then
  echo "ARGERR: Missing database."
  echo
  echo "Usage: $0 $railsenv <database>"
  exit 1
else
  dbn=$2
fi

echo -n "Starting Gvido DB import for '$railsenv' environment and '$dbn' database... continue [yes\no]: "
read answer
if [ $answer == "yes" ]
then
  echo -n "WARNING!!! THIS WILL DESTROY YOUR CURRENT DATABASE. ARE YOU SURE? [yes\no]: "
  read answer
  if [ $answer == "yes" ]
  then
    echo -n "Enter your MySQL username: "
    read dbu
    echo -n "Enter your MySQL password: "
    read -s dbp
    echo
    
    if [ -z $dbp ]; then
      dbcmd="mysql -u$dbu"
    else
      dbcmd="mysql -u$dbu -p$dbp"
    fi

    dbcmdb="$dbcmd --database $dbn"
    
    echo "*** Deleting and recreating $railsenv databases."
    echo "DROP DATABASE $dbn" | $dbcmd
    echo "CREATE DATABASE $dbn" | $dbcmd

    echo "*** Importing datafile."
    $dbcmdb < gvido.sql
    
    echo "*** Now we'll fix the migrations."
    echo "TRUNCATE schema_migrations;" | $dbcmdb
    echo "INSERT INTO schema_migrations VALUES ('20110217120349'), ('20110217120510'), ('20110217120636'), ('20110217143703'), ('20110218013020'), ('20110218060622'), ('20110218063315'), ('20110218065651'), ('20110218071514'), ('20110218080711'), ('20110218081707'), ('20110218082615'), ('20110218093755'), ('20110218094344'), ('20110218094531'), ('20110218100117'), ('20110218102334'), ('20110218102355'), ('20110218102846'), ('20110218103217'), ('20110218103507'), ('20110218105623'), ('20110218110025'), ('20110218110604'), ('20110221114809')" | $dbcmdb
    
    echo "*** And migrate up to the new version from here..."
    rake db:migrate RAILS_ENV=$railsenv
    
    echo "*** Seed $railsenv up."
    rake db:seed RAILS_ENV=$railsenv
    
    echo
    echo "And we're done! Happy Gvido to you too!"
    echo
  fi
else
  echo "Aborting makes Gvido sad."
fi