#!/bin/bash

awk 'BEGIN {
	FS=",";
    printf("Name,Lat,Lon,CI60,CI50,CI40,CI30,CI20,CI10,Rank,Canton,Name,House2009, House1985, App2009, App1985, Tax2010\n");

    while (getline < "coordinates.csv" > 0) {
        cities_name[$1] = $1;
        cities_lat[$1] = $2 + 0.0;
        cities_lon[$1] = $3 + 0.0;
    }
    
    while (getline < "rating.csv") {
        ratings[$3] = $0;
    }
}

function ceil(x) {
	return (x == int(x)) ? x : int(x)+1
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
	for (i = 2; i <= NF; i++) {
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
		for (city in cities_name) {
		    lat = cities_lat[city];
		    lng = cities_lon[city];
#print city " " lat " " lng;
		    if ((lat <= bb[1]) && (lat >= bb[3]) && (lng >= bb[2]) && (lng <= bb[4])) {
				cities_line[city] = col " " row;
				#print city "=" col " " row;
		    }
		}


		row++;
		last_lng = bb[2];
    }
	#rows++;
}
NR > 2 {
	for (city in cities_name) {
		#print "Searching " city " " cities_line[city];
		if (cities_line[city] == $1) {
			# create index
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
		
			printf("\"%s\",%f,%f,%d,%d,%d,%d,%d,%d,%s\n", city, cities_lat[city], cities_lon[city], t[1], t[2], t[3], t[4], t[5], t[6], ratings[city]);
		}
	}
}
END {
}' $1 #| awk '
exit
BEGIN {
    FS=","
}
{
    ul_lat=$2 + 0.0;
    ul_lon=$3 + 0.0;
    lr_lat=$4 + 0.0;
    lr_lon=$5 + 0.0;
    
    found = 0;
    for (city in cities_name) {
        lat = cities_lat[city];
        lon = cities_lon[city];
        # print city, ul_lat, cities_lat[city], lr_lat, " | ", ul_lon, lon, lr_lon, (ul_lat >= lat && lr_lat <= lat && ul_lon <= lon), (lr_lon >= lon);
        if (ul_lat >= lat && lr_lat <= lat && ul_lon <= lon && lr_lon >= lon) {
		    printf("\"%s\",%f,%f,%d,%d,%d,%d,%d,%d,%s\n", city, cities_lat[city], cities_lon[city], $6, $7, $8, $9, $10, $11, ratings[city]);
                    found = 1;
        }
    }
}'

