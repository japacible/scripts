#!/bin/sh

while read line
do
  printf "alias %s='ssh apacible@%s.cs.washington.edu'\n" "$line" "$line"
done < "$1"
