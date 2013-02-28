//
//  JpDaisaru11DevTigmapGMapAnnotation.m
//  tigmap
//
//  Created by 酒井 大地 on 2013/02/28.
//
//

#import "JpDaisaru11DevTigmapGMapAnnotationProxy.h"
#import "TiUtils.h"

@implementation JpDaisaru11DevTigmapGMapAnnotationProxy


-(void)dealloc
{
    if (_markerObj!=nil)
    {
		RELEASE_TO_NIL(_markerObj);
	}
	[super dealloc];
}

-(void)addToMap:(GMSMapView *)mapView
{
	GMSMarkerOptions *options = [[GMSMarkerOptions alloc] init];
	options.position = CLLocationCoordinate2DMake(
		[TiUtils doubleValue:[self valueForUndefinedKey:@"latitude"]],
		[TiUtils doubleValue:[self valueForUndefinedKey:@"longitude"]] );
	options.title = [self valueForUndefinedKey:@"title"];

	self.markerObj = [mapView addMarkerWithOptions:options];

	[options release];
}
-(void)removeFromMap:(GMSMapView *)mapView
{
	if (_markerObj!=nil)
	{
		[_markerObj remove];
		RELEASE_TO_NIL(_markerObj);
	}
}

-(void)setLatitude:(id)latitude
{
	double curValue = [TiUtils doubleValue:[self valueForUndefinedKey:@"latitude"]];
	double newValue = [TiUtils doubleValue:latitude];
	[self replaceValue:latitude forKey:@"latitude" notification:NO];
}

-(void)setLongitude:(id)longitude
{
	double curValue = [TiUtils doubleValue:[self valueForUndefinedKey:@"longitude"]];
	double newValue = [TiUtils doubleValue:longitude];
	[self replaceValue:longitude forKey:@"longitude" notification:NO];
}

- (NSString *)title
{
	return [self valueForUndefinedKey:@"title"];
}

-(void)setTitle:(id)title
{
	title = [TiUtils replaceString:[TiUtils stringValue:title]
			characters:[NSCharacterSet newlineCharacterSet] withString:@" "];
	//The label will strip out these newlines anyways (Technically, replace them with spaces)
	id current = [self valueForUndefinedKey:@"title"];
	[self replaceValue:title forKey:@"title" notification:NO];
}
@end
