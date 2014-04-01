#!/bin/ksh 
#(needs ksh, not sh, for arithmetic)
#
# clnduplines - clean duplicate lines in a file
#		original file is saved in file.was
#		(same as cntduplines but file replaced by cleaned file)
#
if [ -z "$1" ]; then
 echo
 echo "syntax: clnduplines [filename]"
 echo
 exit
fi

file=$1

echo " --- clnduplines: Searching for duplicate lines in $file ---"
count=0
cat /dev/null > $file.clean
while read line
do
  found=`grep "$line" $file.clean`
  if [ -n "$found" ]; then
    echo  ". \c"
    (( count = count + 1 ))		## ksh arithmetic
  else
    echo "$line" >> $file.clean
  fi 
done < $file

echo ""
echo " 		$count dup lines found"

#---------- sh version, too slow --------
#echo " ... counting lines ..."
## old=`wc -l $file | awk '{ print $1 }'`
#  old=`cat $file | wc -l`
## new=`wc -l $file.clean | awk '{ print $1 }'`
#  new=`cat $file.clean | wc -l`
## VERY slow: echo " ---> `expr $old - $new` dups found"
## that's why used ksh's arithmetic: ((  ))

echo ""

/bin/mv $file  $file.was
/bin/mv $file.clean $file

echo " --- $file is now clean, original in $file.was --- delete it ?"
/bin/rm -i $file.was

### based on:
# Unix Tip #487- May  2, 1998 http://www.ugu.com/sui/ugu/show?tip.today
### see also: uniq file : eliminate adjacent lines which are identical
