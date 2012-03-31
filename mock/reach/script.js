var map;

function initialize() {
  var myOptions = {
    zoom: 8,
    center: new google.maps.LatLng( 46.813202, 8.22395),
    mapTypeId: google.maps.MapTypeId.TERRAIN
  };
  map = new google.maps.Map(document.getElementById('map_canvas'),
      myOptions);
}

function opacity( value, max ) {
	return value / max;
}

function indexes( edge, index ) {
	return edge.weights[ index ];
}

$( function() {
	initialize();
	
	time_index = 0;
	
	$.get('data.json', function( data ) {
		
		var max = _.max(
		       	data.data,
		       	function( edge ) {
			       	return indexes( edge, time_index )
		       	} ).weights[ time_index ];

		console.info( max );
		
		$.each( data.data, function( index, edge ) {
			path = [
				new google.maps.LatLng( edge.ul_lat,  edge.ul_lon ),
				new google.maps.LatLng( edge.ul_lat,  edge.lr_lon ),
				new google.maps.LatLng( edge.lr_lat,  edge.lr_lon ),
				new google.maps.LatLng( edge.lr_lat,  edge.ul_lon ),
			]

			tile = new google.maps.Polygon({
				path: path,
				fillColor: "#FF0000",
				fillOpacity: opacity( indexes( edge, time_index ), max ),
				strokeWeight: 0
			});
			
			tile.setMap(map);
		})
	})
})
