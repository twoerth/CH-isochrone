#!/bin/bash

awk 'BEGIN {
	FS=",";
	print "Source\tTarget\tWeight\tType"
}
NR == 2 {
    row=0
	rows=0;
    col=0;
    last_lng = 0;
	for (i = 2; i < NF; i++) {
		row++;
		split($i, bb, " ");
		cells[i, 1] = bb[1];
		cells[i, 2] = bb[2];
		cells[i, 3] = bb[3];
		cells[i, 4] = bb[4];
		if (bb[2] != last_lng && last_lng != 0) {
			rows = row;
        	row = 0;9917
            col++;
		}
		last_lng = bb[2];
    }
}
NR > 2 {
    split($1, cr, " ");
    # print cr[2], cr[1], rows
    cell = cr[2] + rows * cr[1] + 2;
    
    south = cell - 2;
    east = cell + (2 * rows);
    
    eastv  = length($east)  > 0 ? $east  : 120;
    southv = length($south) > 0 ? $south : 120;
    
    # print cells[cell, 1] "," cells[cell, 2] "," eastv "," southv;
    printf("%f\t%f\t%f\t%f\t\"%d\"\t\"%d\"\t%d\tUndirected\n", cells[cell, 1], cells[cell, 2], cells[east, 1], cells[east, 2], cell, east,  eastv);
    printf("%f\t%f\t%f\t%f\t\"%d\"\t\"%d\"\t%d\tUndirected\n", cells[cell, 1], cells[cell, 2], cells[south, 1], cells[south, 2], cell, south, southv);
}'

