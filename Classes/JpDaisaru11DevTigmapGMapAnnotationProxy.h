//
//  JpDaisaru11DevTigmapGMapAnnotation.h
//  tigmap
//
//  Created by 酒井 大地 on 2013/02/28.
//
//

#import "TiProxy.h"
#import <GoogleMaps/GoogleMaps.h>

@interface JpDaisaru11DevTigmapGMapAnnotationProxy : TiProxy
{
	id<GMSMarker> _markerObj;
}

@property (nonatomic, readwrite, retain) id<GMSMarker> markerObj;

-(void)addToMap:(GMSMapView *)mapView;
-(void)removeFromMap:(GMSMapView *)mapView;

@end
