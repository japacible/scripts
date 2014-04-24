#!/bin/sh

while read line
do
  printf "%s@uw.edu\n" "$line"
done < "$1"
