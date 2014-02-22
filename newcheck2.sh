#!/bin/bash

DIR="Output" # No trailing slash
rm -f $DIR/* # Clean out the old files

while :
do
  let COUNT+=1
  let COUNT2=$COUNT-1
  netstat -lptu > $DIR/$COUNT.txt
  if [ `ls $DIR | wc -l` -ge 2 ]; then
     let COUNT3=$COUNT-2
     rm -f $DIR/$COUNT3.txt
     PID=`diff $DIR/$COUNT.txt $DIR/$COUNT2.txt | cut -c 88-105 | sed 's/[^0-9]//g'`
     kill $PID
  fi
  sleep 6
done