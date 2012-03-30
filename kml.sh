#!/bin/bash

# Zurich, Birmensdorfer Str. 150
export lat=47.370223
export lng=8.51947

	# Obersiggenthal
# export lat=47.500035
# export lng=8.291903

awk -v lat=$lat -v lng=$lng '
BEGIN {
	FS=",";
	
	print "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>"
	print "<kml xmlns=\"http://www.opengis.net/kml/2.2\" xmlns:atom=\"http://www.w3.org/2005/Atom\" xmlns:gx=\"http://www.google.com/kml/ext/2.2\" xmlns:xal=\"urn:oasis:names:tc:ciq:xsdschema:xAL:2.0\">"
	print "<Document>"

    print "<Style id=\"pushpin\">"
    print " <IconStyle id=\"mystyle\">"
    print "  <Icon>"
    print "    <href>http://maps.google.com/mapfiles/kml/pushpin/ylw-pushpin.png</href>"
    print "    <scale>1.0</scale>"
    print "  </Icon>"
    print "</IconStyle>"
    print "</Style>"

    print "<Style id=\"zero\">"
    print " <PolyStyle>"
    print "  <color>aa0000cc</color>"
    # print "  <colorMode>random</colorMode>"
    print " </PolyStyle>"
    print "</Style>"

    print "<Style id=\"default\">"
    print " <PolyStyle>"
    print "  <color>aaaaaaaa</color>"
    print " </PolyStyle>"
    print "</Style>"

    print "<Placemark id=\"start\">"
    print " <name>START</name>"
    print " <styleUrl>#pushpin</styleUrl>"
    print " <Point>"
    print "  <coordinates>" lng "," lat "</coordinates>"
    print " </Point>"
    print "</Placemark>"
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
        if ((lat >= bb[1]) && (lat <= bb[3]) && (lng >= bb[2]) && (lng <= bb[4])) {
			/* found col + row */
			fcol = col;
			frow = row;
        }
		if (bb[2] != last_lng && last_lng != 0) {
			rows = row;
        	row = 0;
            col++;
		}
		last_lng = bb[2];
    }
}
NR > 2 {
	if ($1 == (fcol " " frow)) {
		for (i = 2; i < NF; i++) {
			if ($i != "") {
				print "<Placemark>"
				print "<name>" i " (" fcol "x" frow ")</name>"
				print "<description>" $i "min</description>"
				if ($i == 0) {
					print "<styleUrl>#zero</styleUrl>"
                } else {
					print "<styleUrl>#default</styleUrl>"
				}
				print "<Polygon>"
				print "<extrude>1</extrude>"
				print "<altitudeMode>clampToGround</altitudeMode>"
				print "<outerBoundaryIs>"
				print "<LinearRing><coordinates>"
				print cells[i, 2] "," cells[i, 1] " " cells[i, 4] ","  cells[i, 1] " " cells[i, 4] "," cells[i, 3] " " cells[i, 2] "," cells[i, 3] " " cells[i, 2] "," cells[i, 1]
				print "</coordinates></LinearRing>"
				print "</outerBoundaryIs>"
				print "</Polygon>"
				print "</Placemark>"
			}
        }
		exit;
	}
}
END {
	print "</Document>"
	print "</kml>"
}
' ../test_main.csv
