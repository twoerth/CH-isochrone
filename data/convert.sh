#!/bin/bash

cat $1 | grep -ve "^$" | sed s/,/./g | sed s/’//g | awk '
BEGIN{
 c = 1;
}
NR > 26 {
	printf("%s,", $0);
	if (c == 8) {
		print "";
		c = 0;
        }
	c++;
}'
