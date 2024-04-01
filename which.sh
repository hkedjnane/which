#!/usr/bin/env sh

lookonce=true

usage="usage: which [-a] name ..."

args=`getopt abo: $*`
set -- $args

while [[ "$1" != "--" ]]; do
  if [[ "$1" == '-a' ]]; then
    lookonce=false
  else
    echo "which: unknown option $1"
    echo "$usage"
    exit 1
  fi
  shift
done;
shift

if [[ $# -eq 0 ]]; then
  echo "$usage"
  exit 1
fi

looked=$#
found=0


while [[ $# -ne 0 ]]; do


  found_local=false
  oldifs=$IFS
  IFS=':'
  for p in $PATH; do
    prog="$p/$1"
    if [[ -x "$prog" ]]; then
      echo "$prog"
      found_local=true
      if [[ $lookonce = true ]]; then
        break
      fi
    fi
  done
  IFS=$oldifs

  if [[ $found_local = true ]]; then
    found=$((found+1))
  else
    echo "which: $1: Command not found."
  fi

  shift

done



if [[ $found -eq $looked ]]; then
  exit 0
elif [[ $found -eq 0 ]]; then
  exit 2
else exit 1
fi
