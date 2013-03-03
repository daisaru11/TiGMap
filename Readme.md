# TiGMap #

A Titanium module wraps GoogleMaps SDK for iOS.



## Using in your projects ##


1. Getting an API key for GoogleMaps SDK
	
	[Google APIs Console](https://code.google.com/apis/console/)からAPI keyを取得して、プロジェクトで利用しているAppID(bundle identifier)を登録します。  
	Get API key from [Google APIs Console](https://code.google.com/apis/console/), and register the AppID(bundle identifier) using in your project.


2. Download the GoogleMaps SDK

	[SDK](https://developers.google.com/maps/documentation/ios/start?hl=ja)をダウンロードして、好きな場所におきます。中には、`GoogleMaps.framework`が含まれており、これがビルド時に必要です。  
	Download the [SDK](https://developers.google.com/maps/documentation/ios/start?hl=ja), and put it in an arbitrary directory. `GoogleMaps.framework`, which is included in the SDK files, is needed on building your project. 
	
	
3. Setup the module

	このモジュール`jp.daisaru11.dev.tigmap-iphone-0.1.zip`をプロジェクトのルートディレクトリに置きます。`tiapp.xml`にこのモジュールの設定を追記します。  
	Put `jp.daisaru11.dev.tigmap-iphone-0.1.zip` in the root directory of your project, and edit `tiapp.xml`:
	
			<modules>
				…
				<module platform="iphone" version="0.1">jp.daisaru11.dev.tigmap</module>
			</modules>


	`module.xcconfig`をコピーしてプロジェクトのルートディレクトリに置きます。`module.xcconfig`の中に書かれている`OTHER_LDFLAGS`を編集してframeworkの場所を指定します。たぶん、モジュールのビルド時のオプションを指定するファイルです。  
	Copy `module.xcconfig` to the root directory of your project. Edit `OTHER_LDFLAGS` option to specify the directory including the framework: 
	
		OTHER_LDFLAGS=$(inherited) -F"/Users/daichi/Frameworks/GoogleMaps-iOS-1.1.0" -framework GoogleMaps ...
	
	SDKに含まれている`GoogleMaps.bundle`をプロジェクト内の`Resources`ディレクトリの下にコピーします。  
	Copy `GoogleMaps.bundle` into `Resources` directory of your project. `GoogleMaps.bundle` is located in `GoogleMaps.framework/Resources/`.
	
	あとは通常通り、ビルドするだけです。ビルドに失敗する場合は`build/`以下を削除して再ビルドすると成功する場合もあります。  
	Build and run your project.
	
	
4. How to use

	モジュールを`require`でロードし、Mapを表示する前にAPIKeyをセットします。  
	Load the module by `require`, set your APIKey before displaying a map view:
	
		var tigmap = require('jp.daisaru11.dev.tigmap');
		tigmap.setAPIKey('YOUR APIKEY HERE');
		
	通常のViewのように他のViewやWindowにaddすることで表示します。  
	Add a map view to other views or windows to display it.
	
		var mapView = tigmap.createGMapView({
        	location: {
            	latitude: 35.681382,
               	longitude: 139.766084
        	},
        	zoom: 6
        });
        win.add(mapView);
        

## Available methods and events ##

* create and show a MapView
	
	MapViewを生成する際には`location`、`zoom`、`bearing`、`viewingAngle`といったプロパティを指定できます。詳しくはSDKのドキュメントをみてください。通常のビューのように`top`や`width`といったプロパティも設定できます。  
	MapView is created with the following properties: `location`, `zoom`, `bearing`, `viewingAngle`. See the SDK Documents for the detail.
	
		var mapView = tigmap.createGMapView({
       		location: {
        		latitude: 35.681382,
        		longitude: 139.766084
        	},
        	zoom: 6,
        	bearing: 90,
        	viewingAngle: 30,
        	width: 320,
        	height: 100
		});

		
* change camera position
		
		mapView.setLocation({
                latitude: 34.693738,
                longitude: 135.502165
        });
        mapView.setZoom(12);
        mapView.setBearing(180);
        mapView.setViewingAngle(45);

* change maptypes

		var mapView = tigmap.createGMapView({
       		location: {
        		latitude: 35.681382,
        		longitude: 139.766084
        	},
        	zoom: 6,
        	mapType: tigmap.NORMAL_TYPE
		});
		mapView.setMapType(tigmap.SATELLITE_TYPE);
		mapView.setMapType(tigmap.TERRAIN_TYPE);
		mapView.setMapType(tigmap.HYBRID_TYPE);
       
		
* add and remove annotations(markers)
		
		var ann = tigmap.createGMapAnnotation({
                latitude: 34.693738,
                longitude: 135.502165,
                title: 'hoge'
        });
        mapView.addAnnotation(ann);
        mapView.removeAnnotation(ann);
        

* listen events
	
		mapView.addEventListener('click', function(e) {
        	Ti.API.info('map clicked - latitude:'+e.latitude+', longitude:'+e.longitude);
		});
		mapView.addEventListener('longpress', function(e) {
        	Ti.API.info('map long pressed - latitude:'+e.latitude+', longitude:'+e.longitude);
		});
		mapView.addEventListener('changeCameraPosition', function(e) {
        	Ti.API.info('camera position changed - latitude:'+e.target.latitude+', longitude:'+e.target.longitude);
		});
		ann.addEventListener('click', function(e) {
            Ti.API.info('marker click - latitude:'+ann.latitude+', longitude:'+ann.longitude);
        });
        ann.addEventListener('infoWindowClick', function(e) {
        	Ti.API.info('infowindow click');	
        });




## About ##

author: Daichi Sakai   
license: MIT License
   
Sorry for my poor English.
