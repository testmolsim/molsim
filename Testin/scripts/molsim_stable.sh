#!/usr/bin/env bash

stable="stable.md5sum"
current=".current.md5sum"
in=$1
dir=$(dirname $in)
file=$(basename $in)
pro=${file%.*}
error=${2:-0}

molsim="../../Bin/molsim_ser.exe"
if [ "$dir" == "out_stable" ]; then
   if [ -f $dir/$pro.version ]; then
      if `cmp --silent $stable $dir/$pro.version`; then
         echo "This file was created with the currently stable version. Not running molsim again."
         touch $dir/$pro.*
         exit 0
      fi
   fi
   if ! `cmp --silent $stable $current`; then
      echo "ERROR: $in must generated with a stable version."
      echo "ERROR: $in must generated with a stable version." > $in
      exit 0
   fi
fi
cd $dir && pwd && $molsim $pro; e=$? && cd -
if [ "$dir" == "out_stable" ]; then
   cat $current > $dir/$pro.version
fi
if [ "$error" != "$e" ]; then
   echo "ERROR: MOLSIM ended with error code $e, was expecting $error"
   exit 1
fi
