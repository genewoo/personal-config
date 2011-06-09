#!/bin/bash

#########################################################################
# jcmd is an entry of jian's cli script
# jcmd will list entire script avaiable in $MY_SHELL
#########################################################################

if [ -z "$1" ]
then
  cd $MY_SHELL
  chmod +x *
  cd -
  ls $MY_SHELL | less
else
  cmd=""
  for param in $*;
  do
    cmd="$cmd $param"
  done
  cmd=`echo $cmd | sed 's# #-#g'`
  $MY_SHELL/$cmd
fi

