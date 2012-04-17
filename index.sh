#!/bin/bash

awk 'BEGIN {
	FS=",";
	#print "Source\tTarget\tWeight\tType"
	print "{\"data\":["
}

function ceil(x) {
	return (x == int(x)) ? x : int(x)+1
}

NR == 2 {
    row=0
	rows=0;
    col=0;
    last_lng = 0;
	for (i = 2; i < NF; i++) {
		split($i, bb, " ");
		cells[i, 1] = bb[1];
		cells[i, 2] = bb[2];
		cells[i, 3] = bb[3];
		cells[i, 4] = bb[4];
		if (bb[2] != last_lng && last_lng != 0) {
			rows = row;
        	row = 0;
            col++;
		}
		row++;
		last_lng = bb[2];
    }
}
NR > 2 {
    if (NR > 3) {
        printf(",\n");
    }
    split($1, cr, " ");
    # print cr[2], cr[1], rows
    cell = cr[2] + rows * cr[1] + 2;
    
    south = cell - 2;
    east = cell + (2 * rows);
    
    eastv  = length($east)  > 0 ? $east  : 120;
    southv = length($south) > 0 ? $south : 120;
    
    #printf("%f\t%f\t%f\t%f\t\"%d\"\t\"%d\"\t%d\tUndirected\n", cells[cell, 1], cells[cell, 2], cells[east, 1], cells[east, 2], cell, east,  eastv);
    #printf("%f\t%f\t%f\t%f\t\"%d\"\t\"%d\"\t%d\tUndirected\n", cells[cell, 1], cells[cell, 2], cells[south, 1], cells[south, 2], cell, south, southv);
    
    #printf("{\"slat\": %f, \"slon\": %f, \"tlat\": %f, \"tlon\": %f, \"weight\": %d},\n", cells[cell, 1], cells[cell, 2], cells[east, 1], cells[east, 2],   eastv);
    #printf("{\"slat\": %f, \"slon\": %f, \"tlat\": %f, \"tlon\": %f, \"weight\": %d}", cells[cell, 1], cells[cell, 2], cells[south, 1], cells[south, 2], southv);

    for (i = 1; i <=6; i++) {
        t[i] = 0;
    }
	for (i = 2; i < NF; i++) {
		if (length($i) > 0) {
			min = ($i == 0) ? 1 : ceil($i / 10);
			for (x = 1; x <= min; x++) {
			    t[x]++;
			}
		}
	}
    printf("{\"ul_lat\": %f, \"ul_lon\": %f, \"lr_lat\": %f, \"lr_lon\": %f, \"weights\": [", cells[cell, 1], cells[cell, 2], cells[cell, 3], cells[cell, 4]);
    for (i = 1; i <=6; i++) {
        printf("%d", t[i]);
        if (i < 6) {
            printf(",");
        }
    }
    printf("]}");
}
END {
    print "]}"
}' $1

