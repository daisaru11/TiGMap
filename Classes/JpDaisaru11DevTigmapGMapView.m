//
//  JpDaisaru11DevGMapView.m
//  tigmap
//
//  Created by 酒井 大地 on 2013/02/23.
//
//

#import "JpDaisaru11DevTigmapGMapView.h"
#import "JpDaisaru11DevTigmapGMapAnnotationProxy.h"

@implementation JpDaisaru11DevTigmapGMapView

#pragma mark Internal

-(id)init
{
    if (self = [super init]) {
		_location = CLLocationCoordinate2DMake(0,0);
		_zoom = 0;
		_rendered = NO;
		_animate = YES;
		_locChanged = NO;
		_zoomChanged = NO;
		_bearingChanged = NO;
		_angleChanged = NO;
		_annotationsAdded = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
	if (_map!=nil)
	{
		_map.delegate = nil;
		RELEASE_TO_NIL(_map);
	}

	RELEASE_TO_NIL(_annotationsAdded);

	[super dealloc];
}

- (GMSMapView *) map
{
	if (_map==nil)
	{
		_map = [[GMSMapView alloc] initWithFrame:self.bounds];
		//GMSCameraPosition* camera = [GMSCameraPosition cameraWithLatitude:1.285 longitude:103.848 zoom:12];
		//_map = [GMSMapView mapWithFrame:self.bounds camera:camera];
		_map.myLocationEnabled = YES;
        _map.delegate = self;

		[self addSubview:_map];
	}

	return _map;
}

-(void)render
{
	if (_map==nil) // before mapview initialized
	{
		return;
	}

	if (![NSThread isMainThread]) {
		TiThreadPerformOnMainThread(^{[self render];}, NO);
		return;
	}

	if (!_rendered || !_animate) {
		CLLocationCoordinate2D target = _map.camera.target;
		if (_locChanged) {
			target = _location;
		}
		CGFloat zoom = _map.camera.zoom;
		if (_zoomChanged) {
			zoom = _zoom;
		}
		CLLocationDirection bearing = _map.camera.bearing;
		if (_bearingChanged) {
			bearing = _bearing;
		}
		double angle = _map.camera.viewingAngle;
		if (_angleChanged) {
			angle = _angle;
		}

		GMSCameraPosition *camera = [GMSCameraPosition cameraWithTarget:target
			zoom:zoom
			bearing:bearing
			viewingAngle:angle ];

		[_map setCamera: camera];
	}
	else {
		if (_locChanged) {
			[_map animateToLocation:_location];
		}
		if (_zoomChanged) {
			[_map animateToZoom: _zoom];
		}
		if (_bearingChanged) {
			[_map animateToBearing: _bearing];
		}
		if (_angleChanged) {
			[_map animateToViewingAngle: _angle];
		}
	}
	_locChanged = NO;
	_zoomChanged = NO;
	_bearingChanged = NO;
	_angleChanged = NO;
}

- (void)frameSizeChanged:(CGRect)frame bounds:(CGRect)bounds
{
	[TiUtils setView:[self map] positionRect:bounds];
	[super frameSizeChanged:frame bounds:bounds];
	[self render];
	_rendered = YES;
}

-(UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView* result = [super hitTest:point withEvent:event];
	if(result==self){
		return nil;
	}
	return result;
}

-(JpDaisaru11DevTigmapGMapAnnotationProxy*) proxyForMarker:(id<GMSMarker>)marker
{
	for (id annProxy in _annotationsAdded)
	{
		if ([annProxy isKindOfClass:[JpDaisaru11DevTigmapGMapAnnotationProxy class]])
		{
			id<GMSMarker> m = [(JpDaisaru11DevTigmapGMapAnnotationProxy*)annProxy markerObj];
			if ( m!=nil && m==marker )
			{
				return annProxy;
			}
		}
	}
	return nil;
}

#pragma mark Public APIs

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

	_locChanged = YES;
	[self render];
}

-(void)setZoom_:(id)zoom
{
	ENSURE_SINGLE_ARG(zoom,NSObject);
	ENSURE_UI_THREAD(setZoom_,zoom);

	_zoom = [TiUtils floatValue:zoom];

	_zoomChanged = YES;
	[self render];
}

-(void)setBearing_:(id)bearing
{
	ENSURE_SINGLE_ARG(bearing,NSObject);
	ENSURE_UI_THREAD(setBearing_,bearing);

	_bearing = [TiUtils doubleValue:bearing];

	_bearingChanged = YES;
	[self render];
}

-(void)setViewingAngle_:(id)angle
{
	ENSURE_SINGLE_ARG(angle,NSObject);
	ENSURE_UI_THREAD(setViewingAngle_,angle);

	_angle = [TiUtils doubleValue:angle];

	_angleChanged = YES;
	[self render];
}

-(void)setAnimate_:(id)animate
{
	ENSURE_SINGLE_ARG(animate,NSObject);
	_animate = [TiUtils boolValue:animate];
}

-(void)setMapType_:(id)value
{
	[[self map] setMapType:[TiUtils intValue:value]];
}

-(void)addAnnotation:(id)arg
{
	ENSURE_SINGLE_ARG(arg,NSObject);
	ENSURE_UI_THREAD(addAnnotation,arg);

	JpDaisaru11DevTigmapGMapAnnotationProxy* annProxy = arg;

	if (annProxy!=nil && ![_annotationsAdded containsObject:annProxy]) {
		[_annotationsAdded addObject:annProxy];
		[annProxy addToMap:[self map]];
	}
}

-(void)removeAnnotation:(id)arg
{
	ENSURE_SINGLE_ARG(arg,NSObject);
	ENSURE_UI_THREAD(removeAnnotation,arg);

	JpDaisaru11DevTigmapGMapAnnotationProxy *annProxy = arg;

	if (annProxy!=nil && [_annotationsAdded containsObject:annProxy]) {
		[_annotationsAdded removeObject:annProxy];
		[annProxy removeFromMap:[self map]];
	}
}

#pragma mark Delegates

- (void)mapView:(GMSMapView *)mapView
    didChangeCameraPosition:(GMSCameraPosition *)position
{
	if ([self.proxy _hasListeners:@"changeCameraPosition"]) // listener name is too long?
	{
		NSDictionary *target = [NSDictionary dictionaryWithObjectsAndKeys:
			[NSNumber numberWithDouble:position.target.latitude],@"latitude",
			[NSNumber numberWithDouble:position.target.longitude],@"longitude",
			nil];
		NSDictionary *props = [NSDictionary dictionaryWithObjectsAndKeys:
			@"changeCameraPosition",@"type",
			target,@"target",
			[NSNumber numberWithDouble:position.zoom],@"zoom",
			[NSNumber numberWithDouble:position.bearing],@"bearing",
			[NSNumber numberWithDouble:position.viewingAngle],@"bearing",
			nil];
		[self.proxy fireEvent:@"changeCameraPosition" withObject:props];
	}
}

- (void)mapView:(GMSMapView *)mapView
    didTapAtCoordinate:(CLLocationCoordinate2D)coordinate
{
	if ([self.proxy _hasListeners:@"click"])
	{
		NSDictionary * props = [NSDictionary dictionaryWithObjectsAndKeys:
			@"click",@"type",
			[NSNumber numberWithDouble:coordinate.latitude],@"latitude",
			[NSNumber numberWithDouble:coordinate.longitude],@"longitude",
			nil];
		[self.proxy fireEvent:@"click" withObject:props];
	}
}

- (void)mapView:(GMSMapView *)mapView
    didLongPressAtCoordinate:(CLLocationCoordinate2D)coordinate
{
	if ([self.proxy _hasListeners:@"longpress"])
	{
		NSDictionary * props = [NSDictionary dictionaryWithObjectsAndKeys:
			@"longpress",@"type",
			[NSNumber numberWithDouble:coordinate.latitude],@"latitude",
			[NSNumber numberWithDouble:coordinate.longitude],@"longitude",
			nil];
		[self.proxy fireEvent:@"longpress" withObject:props];
	}
}
-(void)recognizedLongPress:(UILongPressGestureRecognizer*)recognizer
{
	// ignore the event by recognized in TiUIView
}

- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(id<GMSMarker>)marker
{
	JpDaisaru11DevTigmapGMapAnnotationProxy *annProxy = [self proxyForMarker:marker];
	if ([annProxy _hasListeners:@"click"])
	{
		NSDictionary * props = [NSDictionary dictionaryWithObjectsAndKeys:
			@"click",@"type",
			nil];
		[annProxy fireEvent:@"click" withObject:props];
	}
	//return YES;
}

- (void)mapView:(GMSMapView *)mapView
    didTapInfoWindowOfMarker:(id<GMSMarker>)marker
{
	JpDaisaru11DevTigmapGMapAnnotationProxy *annProxy = [self proxyForMarker:marker];
	if ([annProxy _hasListeners:@"infoWindowClick"])
	{
		NSDictionary * props = [NSDictionary dictionaryWithObjectsAndKeys:
			@"infoWindowClick",@"type",
			nil];
		[annProxy fireEvent:@"infoWindowClick" withObject:props];
	}
}


//- (UIView *)mapView:(GMSMapView *)mapView
//    markerInfoWindow:(id<GMSMarker>)marker
//{
//}





@end
