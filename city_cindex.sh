#!/bin/bash

awk 'BEGIN {
	FS=",";
}

function floor(x) {
	y = int(x)
	return y > x ? y - 1 : y
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
    
    for (i = 1; i <=6; i++) {
        t[i] = 0;
    }
    for (i = 2; i < NF; i++) {
        if (length($i) > 0) {
            min = floor($i / 10);
            for (x = 1; x <= min; x++) {
                t[x]++;
            }
        }
    }
    
    printf("%f %f %f %f %d\n", cells[cell, 1], cells[cell, 2], cells[cell - 1 + rows, 1], cells[cell - 1 + rows, 2], t[1]);
}
END {
}' $1 | awk '
BEGIN {
    FS=" "
    while (getline < "cities.csv" > 0) {
        print cities_lat[$4] = $1  + 0.0;
        print cities_lon[$4] = $2 + 0.0;
        print cities_val[$4] = $3 + 0.0;
    }
}
{
    #print $0
    ul_lat=$1 + 0.0;
    ul_lon=$2 + 0.0;
    lr_lat=$3 + 0.0;
    lr_lon=$4 + 0.0;
    
    for (city in cities_val) {
        lat = cities_lat[city];
        lon = cities_lon[city];
        #print city, ul_lat, cities_lat[city], lr_lat, " | ", ul_lon, lon, lr_lon, (ul_lat >= lat && lr_lat <= lat && ul_lon <= lon), (lr_lon >= lon);
        if (ul_lat >= lat && lr_lat <= lat && ul_lon <= lon && lr_lon >= lon) {
            print "Found ", lat, lon, "[", ul_lat, ul_lon, "]", $5, cities_val[city], city; 
        }
    }
}'

