#!/bin/bash
# onlyshk

echo "Input dir in which remove all temp files: " 
read DIR;
find "$DIR" -name "*~" -exec rm -f {} \;
echo "All temp files are removed"
