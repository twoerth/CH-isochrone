$( function() {
	var quantize;
	var time_index;
	
	$( "#slider" ).slider({
		value:0,
		min: 0,
		max: 5,
		step: 1,
		slide: function( event, ui ) {
			$( "#amount" ).val( 60 - 10 * ui.value );
			time_index = ui.value;
			redraw();
		}
	});
	time_index = 0;
	$( "#amount" ).val( 60 - 10 * $( "#slider" ).slider( "value" ) );

    var w = 750;
    var h = 400;

	bbox = [ [ 5.955870,45.818020] , [ 10.492030, 47.808380 ] ]

    var proj = fitProjection( 
        d3.geo.mercator(), 
			bbox,
        [[ 0,0 ],[ w,h ]],
		  true
    );
	
    var path = d3.geo.path().projection(proj);

    var t = proj.translate(); // the projection's default translation
   var s = proj.scale() // the projection's default scale
	
	highlightColor = d3.rgb('red').darker();
	normalColor = d3.rgb('blue').darker();

    var map = d3.select("#vis").append("svg:svg")
    	.attr("class", "Reds")
        .attr("width", w)
        .attr("height", h)

	paths = {};

	paths['connectivity'] = map.append("g").attr("id", "connectivity");
	paths['see'] = map.append("g").attr("id", "lakes");
	paths['kanton'] = map.append("g").attr("id", "cantons");
	paths['bezirk'] = map.append("g").attr("id", "bezirks");

	bbox_string = "" + bbox[0][0] + ',' + bbox[0][1] + ',' + bbox[1][0] + ',' + bbox[1][1];  

	var thejson;

	var keys = ['see', 'kanton', 'bezirk'];

	var data = {};

	d3.json( 'bounds.json', function( json ) {
		thejson = json
		
		keys.forEach( function( key ) {
			if( json[ key ] ) {
				if( ! data[ key ] ) { data[ key ] = [] }

				json[ key ].forEach( function( poly ) {
					data[ key ].push({
						"geometry" : poly.geometry,
						"properties" : poly.properties,
						"type" : 'Feature' 
					});
				})
				paths[ key ].selectAll("path")
					.data( data[ key ] )
					.enter().append("svg:path")
						.attr("d", path);
			};
		});
	});
	
	function indexes( edge, index ) {
		return edge.weights[ index ];
	}
	
	var scales = {};
	
	function getClass( d ) {
		return "q" + scales[time_index]( d['properties']['weights'][time_index] ) + "-9";
	}	
	
	d3.json( 'data2.json', function( json ) {
		
		edges = [];

		for( var i = 0; i < 6; i++ ) {
			max = _.max( json.data, function( edge ) { return indexes( edge, i ) } ).weights[ i ];
			scales[ i ] = d3.scale.quantile().domain([0, max]).range(d3.range(9));			
		}
				
		json['data'].forEach( function( edge ) {
			if( indexes( edge, 0 ) > 0 ) {
				edges.push({
					"type": "Feature",
					"properties": {
						'weights': edge['weights']
					},
					"geometry": {
						"type":"Polygon",
						"coordinates": [[
							[ edge['ul_lon'], edge['ul_lat'] ],
							[ edge['lr_lon'], edge['ul_lat'] ],
							[ edge['lr_lon'], edge['lr_lat'] ],
							[ edge['ul_lon'], edge['lr_lat'] ],
							[ edge['ul_lon'], edge['ul_lat'] ]
						]]
					}
				});
			}	
		});
		paths['connectivity'].selectAll('path')
			.data( edges )
			.enter().append('svg:path')
				.attr('d', path )
		redraw();
	});
	
	function redraw() {
		paths['connectivity'].selectAll('path')
		        .attr("class", getClass )
	}
})