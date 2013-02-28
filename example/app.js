// This is a test harness for your module
// You should do something interesting in this harness 
// to test out the module and to provide instructions 
// to users on how to use it by example.


// open a single window
var win = Ti.UI.createWindow({
	backgroundColor:'white'
});

// TODO: write your module tests here
var tigmap = require('jp.daisaru11.dev.tigmap');
tigmap.setAPIKey(require('/apikey'));

Ti.API.info("module is => " + tigmap);

var mapView = tigmap.createGMapView({
	location: {
		latitude: 35.681382,
		longitude: 139.766084
	},
	zoom: 6
	//"width":200,
	//"height":200
});
var ann = tigmap.createGMapAnnotation({
	latitude: 34.693738,
	longitude: 135.502165,
	title: 'hoge'
});
mapView.addAnnotation(ann);
win.add(mapView);

win.open();

setTimeout(function() {
	mapView.setLocation({
		latitude: 34.693738,
		longitude: 135.502165
	});
	setTimeout(function() {
		mapView.removeAnnotation(ann);
	}, 3000);
}, 3000);

