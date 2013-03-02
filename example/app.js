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
	zoom: 6,
	mapType: tigmap.HYBRID_TYPE
	//"width":200,
	//"height":200
});
win.add(mapView);

win.open();

setTimeout(function() {
	var ann = tigmap.createGMapAnnotation({
		latitude: 34.693738,
		longitude: 135.502165,
		title: 'hoge',
		snippet: 'hogehoge, hogehoge'
	});
	mapView.addAnnotation(ann);
	mapView.setLocation({
		latitude: 34.693738,
		longitude: 135.502165
	});
	ann.addEventListener('click', function(e) {
		Ti.API.info('marker click - ok');
	});
}, 3000);

mapView.addEventListener('click', function(e) {
	Ti.API.info('map clicked - latitude:'+e.latitude+', longitude:'+e.longitude);
});
mapView.addEventListener('longpress', function(e) {
	Ti.API.info('map long pressed - latitude:'+e.latitude+', longitude:'+e.longitude);
});
mapView.addEventListener('cameraPositionChanged', function(e) {
	Ti.API.info('camera position changed - latitude:'+e.target.latitude+', longitude:'+e.target.longitude);
});
