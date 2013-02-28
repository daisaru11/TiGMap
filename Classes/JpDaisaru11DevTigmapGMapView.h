//
//  JpDaisaru11DevGMapView.h
//  tigmap
//
//  Created by 酒井 大地 on 2013/02/23.
//
//

#import <UIKit/UIKit.h>
#import "TiUIView.h"
#import <GoogleMaps/GoogleMaps.h>


@interface JpDaisaru11DevTigmapGMapView : TiUIView<GMSMapViewDelegate>
{
	GMSMapView * _map;
	CLLocationCoordinate2D _location;
	CGFloat _zoom;
	BOOL _rendered;
	BOOL _animate;
}

-(void)addAnnotation:(id)args;
//-(void)addAnnotations:(id)args;
-(void)removeAnnotation:(id)args;
//-(void)removeAnnotations:(id)args;
//-(void)removeAllAnnotations:(id)args;

@end
