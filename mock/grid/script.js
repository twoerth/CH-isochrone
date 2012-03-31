var map;

function initialize() {
  var myOptions = {
    zoom: 8,
    center: new google.maps.LatLng( 46.813202, 8.22395),
    mapTypeId: google.maps.MapTypeId.ROADMAP
  };
  map = new google.maps.Map(document.getElementById('map_canvas'),
      myOptions);
}

var max = 30;

function width( w ) {
	if( w > 60 ) {
		return 1;
	}
	return ( 60 - w ) / 10;
}

function color( w ) {
	if( w > max ) { 
		return "#FFFF00";
	} else {
		return "#0000FF";		
	}
}

$( function() {
	initialize();
	$.get('data.json', function( data ) {
		$.each( data.data, function( index, edge ) {
			
			source = new google.maps.LatLng( edge.slat,  edge.slon ),
			target = new google.maps.LatLng( edge.tlat,  edge.tlon )

			
			path = [ source, target ];
			
			var flightPath = new google.maps.Polyline({
		      path: path,
		      strokeColor: color( edge.weight ),
		      strokeOpacity: 0.8,
		      strokeWeight: width( edge.weight )
		    });

		   flightPath.setMap(map);
		})
	})
})