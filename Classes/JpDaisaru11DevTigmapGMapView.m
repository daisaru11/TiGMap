//
//  JpDaisaru11DevGMapView.m
//  tigmap
//
//  Created by 酒井 大地 on 2013/02/23.
//
//

#import "JpDaisaru11DevTigmapGMapView.h"

@implementation JpDaisaru11DevTigmapGMapView

-(id)init
{
    if (self = [super init]) {
		_location = CLLocationCoordinate2DMake(0,0);
		_zoom = 0;
		_rendered = NO;
		_animate = YES;
    }
    return self;
}


- (void)dealloc
{
    if (_map!=nil)
    {
		RELEASE_TO_NIL(_map);
	}
	[super dealloc];
}


- (GMSMapView *) map
{
	if (_map==nil)
	{
		NSLog(@"initialize map");

		_map = [[GMSMapView alloc] initWithFrame:self.bounds];
		_map.myLocationEnabled = YES;

		[self addSubview:_map];
	}

	return _map;
}

-(void)render
{
	if (![NSThread isMainThread]) {
		TiThreadPerformOnMainThread(^{[self render];}, NO);
		return;
	}

	if (!_rendered || !_animate) {
		GMSCameraPosition *camera = [GMSCameraPosition cameraWithTarget:_location zoom:16];
		[_map setCamera: camera];
		_rendered = YES;
	} else {
		[_map animateToLocation:_location];
		[_map animateToZoom: _zoom];
	}
	// no animation
	//GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.8683
	//longitude:151.2086
	//zoom:6];
}

- (void)frameSizeChanged:(CGRect)frame bounds:(CGRect)bounds
{
	[TiUtils setView:[self map] positionRect:bounds];
	[super frameSizeChanged:frame bounds:bounds];
	//NSLog(@"framesizechanged latitude: %f, longitude: %f", _location.latitude, _location.longitude);
	[self render];
}

-(void)setLocation_:(id)location
{
	ENSURE_SINGLE_ARG(location,NSDictionary);
    ENSURE_UI_THREAD(setLocation_,location)
	id lat = [location objectForKey:@"latitude"];
	id lon = [location objectForKey:@"longitude"];
	if (lat)
	{
		_location.latitude = [lat doubleValue];
	}
	if (lon)
	{
		_location.longitude = [lon doubleValue];
	}
	//id an = [location objectForKey:@"animate"];
	//if (an)
	//{
	//	animate = [an boolValue];
	//}
	NSLog(@"latitude: %f, longitude: %f", _location.latitude, _location.longitude);
	[self render];
}

-(void)setZoom_:(id)zoom
{
	ENSURE_SINGLE_ARG(zoom,NSObject);
	ENSURE_UI_THREAD(setZoom_,zoom);

	_zoom = [TiUtils floatValue:zoom];

	NSLog(@"zoom: %f", _zoom);
	[self render];
}

-(void)setAnimate_:(id)animate
{
	ENSURE_SINGLE_ARG(animate,NSObject);
	_animate = [TiUtils boolValue];
}

@end
