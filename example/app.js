// This is a test harness for your module
// You should do something interesting in this harness 
// to test out the module and to provide instructions 
// to users on how to use it by example.

var tigmap = require('jp.daisaru11.dev.tigmap');
tigmap.setAPIKey(require('/apikey'));

Ti.API.info("module is => " + tigmap);

// create navigation
var root = Ti.UI.createWindow({
	backgroundColor:'white'
});
var win0 = Ti.UI.createWindow({
	backgroundColor:'white'
});

var nav = Titanium.UI.iPhone.createNavigationGroup({
	window: win0
});
root.add(nav);
root.open();

// create map examples
var examples = { // each functions return a window including examples.
	'Lab': exampleInLab,
	'Markers': exampleMarkers,
	'Events': exampleEvents,
	'MapTypes': exampleMapTypes,
	'Changing CameraPosition': exampleChangeCameraPosition
};


var rows = [];
Object.keys(examples).forEach(function(title) {
	rows.push({
		title: title,
		hasDetail: true,
		key: title
	});
});
var tableView = Titanium.UI.createTableView({
	data: rows
});
tableView.addEventListener('click', function(e) {
	if (e.rowData.key && examples[e.rowData.key]) {
		var exWin = examples[e.rowData.key]();
		nav.open(exWin,{animated:true});
	}
});

win0.add(tableView);



function exampleInLab() {
	var win = Ti.UI.createWindow({
		backgroundColor:'white'
	});
	var mapView = tigmap.createGMapView({
		location: {
			latitude: 35.681382,
			longitude: 139.766084
		},
		zoom: 12,
		mapType: tigmap.NORMAL_TYPE
	});
	win.add(mapView);

	setTimeout(function() {
		mapView.setZoom(8);
		//mapView.setBearing(90);
		//mapView.setViewingAngle(30);
		setTimeout(function() {
			mapView.setZoom(2);
		}, 3000);
	}, 4000);

	return win;
}

function exampleMarkers() {
	var win = Ti.UI.createWindow({
		backgroundColor:'white'
	});
	var mapView = tigmap.createGMapView({
		location: {
			latitude: 35.681382,
			longitude: 139.766084
		},
		zoom: 10,
		top: 25
	});
	win.add(mapView);

	var anns = [];
	anns.push(tigmap.createGMapAnnotation({
		latitude: 35.681382,
		longitude: 139.766084,
		title: 'Tokyo',
		snippet: 'hogehoge, hogehoge',
		isAdded: false
	}));
	anns.push(tigmap.createGMapAnnotation({
		latitude: 35.690921,
		longitude: 139.700258,
		title: 'Shinjuku',
		snippet: 'hogehoge, hogehoge',
		isAdded: false
	}));
	anns.push(tigmap.createGMapAnnotation({
		latitude: 35.658517,
		longitude: 139.701334,
		title: 'Shibuya',
		snippet: 'hogehoge, hogehoge',
		isAdded: false
	}));

	var buttonbar = Ti.UI.createButtonBar({
		labels:['Tokyo', 'Shinjuku', 'Shibuya'],
		backgroundColor:'#336699',
		style:Ti.UI.iPhone.SystemButtonStyle.BAR,
		top:0,
		height:25,
		width:200
	});

	win.add(buttonbar);
	buttonbar.addEventListener('click', function(e){
		var ann = anns[e.index];
		if (!ann.isAdded) {
			mapView.addAnnotation(ann);
		} else {
			mapView.removeAnnotation(ann);
		}
		ann.isAdded = !ann.isAdded;
	});

	return win;
}

function exampleEvents() {
	var win = Ti.UI.createWindow({
		backgroundColor:'white'
	});
	var mapView = tigmap.createGMapView({
		location: {
			latitude: 35.681382,
			longitude: 139.766084
		},
		zoom: 6,
		top: 25
	});
	var ann = tigmap.createGMapAnnotation({
		latitude: 35.681382,
		longitude: 139.766084,
		title: 'Tokyo',
		snippet: 'hogehoge, hogehoge',
		isAdded: false
	});
	mapView.addAnnotation(ann);

	win.add(mapView);

	var info = Titanium.UI.createLabel({
		text: '',
		height: 25,
		font: {fontSize:12},
		top: 0
	});
	win.add(info);

	mapView.addEventListener('click', function(e) {
		var msg = 'map clicked - latitude:'+e.latitude+', longitude:'+e.longitude;
		Ti.API.info(msg);
		info.text = msg;
	});
	mapView.addEventListener('longpress', function(e) {
		var msg = 'map long pressed - latitude:'+e.latitude+', longitude:'+e.longitude;
		Ti.API.info(msg);
		info.text = msg;
	});
	mapView.addEventListener('cameraPositionChanged', function(e) {
		var msg = 'camera position changed - latitude:'+e.target.latitude+', longitude:'+e.target.longitude;
		Ti.API.info(msg);
		info.text = msg;
	});
	ann.addEventListener('click', function(e) {
		var msg = 'marker clicked';
		Ti.API.info(msg);
		info.text = msg;
	});
	ann.addEventListener('infoWindowClick', function(e) {
		var msg = 'infoWindow clicked';
		Ti.API.info(msg);
		info.text = msg;
	});

	return win;
}

function exampleMapTypes() {
	var win = Ti.UI.createWindow({
		backgroundColor:'white'
	});
	var mapView = tigmap.createGMapView({
		location: {
			latitude: 35.681382,
			longitude: 139.766084
		},
		zoom: 6,
		mapType: tigmap.NORMAL_TYPE,
		top: 25
	});
	win.add(mapView);

	var buttonbar = Ti.UI.createButtonBar({
		labels:['NORMAL', 'SATELLITE', 'TERRAIN', 'HYBRID'],
		backgroundColor:'#336699',
		style:Ti.UI.iPhone.SystemButtonStyle.BAR,
		top:0,
		height:25,
		width:200
	});

	win.add(buttonbar);

	buttonbar.addEventListener('click', function(e){
		if (e.index === 0) {
			mapView.setMapType(tigmap.NORMAL_TYPE);
		}
		else if (e.index === 1) {
			mapView.setMapType(tigmap.SATELLITE_TYPE);
		}
		else if (e.index === 2) {
			mapView.setMapType(tigmap.TERRAIN_TYPE);
		}
		else if (e.index === 3) {
			mapView.setMapType(tigmap.HYBRID_TYPE);
		}
	});

	return win;
}

function exampleChangeCameraPosition() {
	var win = Ti.UI.createWindow({
		backgroundColor:'white'
	});
	var mapView = tigmap.createGMapView({
		location: {
			latitude: 35.681382,
			longitude: 139.766084
		},
		zoom: 6,
		mapType: tigmap.HYBRID_TYPE
	});
	win.add(mapView);

	mapView.addEventListener('click', function(e) {
		mapView.setLocation({
			latitude: e.latitude,
			longitude: e.longitude
		});
	});
	return win;
}
