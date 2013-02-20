#!/bin/bash
for count in 1 2 3 4 5 6 7
do
  java -cp saxon9he.jar net.sf.saxon.Query Problem$count.xq > a$count.xq
  xmllint --format a$count.xq > format-a$count.xq 
done
