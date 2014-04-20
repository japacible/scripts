#!/bin/sh

while read line
do
  printf "alias %s='apacible@%s.cs.washington.edu'\n" "$line" "$line"
done < "$1"
