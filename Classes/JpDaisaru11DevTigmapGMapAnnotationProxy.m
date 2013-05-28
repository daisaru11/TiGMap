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
		_markerObj.map = nil;
		RELEASE_TO_NIL(_markerObj);
	}
	[super dealloc];
}

-(void)addToMap:(GMSMapView *)mapView
{
	self.markerObj = [GMSMarker markerWithPosition:CLLocationCoordinate2DMake(
		[TiUtils doubleValue:[self valueForUndefinedKey:@"latitude"]],
		[TiUtils doubleValue:[self valueForUndefinedKey:@"longitude"]] ) ];
	self.markerObj.title = [TiUtils stringValue:[self valueForUndefinedKey:@"title"]];
	self.markerObj.snippet = [TiUtils stringValue:[self valueForUndefinedKey:@"snippet"]];
	self.markerObj.map = mapView;
}
-(void)removeFromMap:(GMSMapView *)mapView
{
	if (_markerObj!=nil)
	{
		_markerObj.map = nil;
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
	NSString *newValue = [TiUtils stringValue:[self valueForUndefinedKey:@"title"]];
	NSString *curValue = [TiUtils stringValue:title];
//	title = [TiUtils replaceString:[TiUtils stringValue:title]
//			characters:[NSCharacterSet newlineCharacterSet] withString:@" "];
//	//The label will strip out these newlines anyways (Technically, replace them with spaces)
//	id current = [self valueForUndefinedKey:@"title"];
	[self replaceValue:title forKey:@"title" notification:NO];
}

-(void)setSnippet:(id)snippet
{
	NSString *newValue = [TiUtils stringValue:[self valueForUndefinedKey:@"snippet"]];
	NSString *curValue = [TiUtils stringValue:snippet];
	[self replaceValue:snippet forKey:@"snippet" notification:NO];
}

@end
