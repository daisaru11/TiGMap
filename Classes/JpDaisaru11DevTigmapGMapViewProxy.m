//
//  JpDaisaru11DevGMapViewProxy.m
//  tigmap
//
//  Created by 酒井 大地 on 2013/02/23.
//
//

#import "JpDaisaru11DevTigmapGMapViewProxy.h"
#import "JpDaisaru11DevTigmapGMapView.h"
#import "JpDaisaru11DevTigmapGMapAnnotationProxy.h"

@implementation JpDaisaru11DevTigmapGMapViewProxy

-(void)addAnnotation:(id)arg
{
	ENSURE_SINGLE_ARG(arg,NSObject)
	JpDaisaru11DevTigmapGMapAnnotationProxy* annProxy = arg;
    [self rememberProxy:annProxy];
    
	//if ([self viewAttached]) 
	{
		TiThreadPerformOnMainThread(^{[(JpDaisaru11DevTigmapGMapView*)[self view] addAnnotation:arg];}, NO);
	}
//	else 
//	{
//		if (annotationsToAdd==nil)
//		{
//			annotationsToAdd = [[NSMutableArray alloc] init];
//		}
//		if (annotationsToRemove!=nil && [annotationsToRemove containsObject:arg]) 
//		{
//			[annotationsToRemove removeObject:arg];
//		}
//		else 
//		{
//			[annotationsToAdd addObject:arg];
//		}
//	}
}

-(void)removeAnnotation:(id)arg
{
	ENSURE_SINGLE_ARG(arg,NSObject)
	if ([arg isKindOfClass:[JpDaisaru11DevTigmapGMapAnnotationProxy class]]) {
		[self forgetProxy:arg];
	}

	//if ([self viewAttached]) 
	{
		TiThreadPerformOnMainThread(^{
				[(JpDaisaru11DevTigmapGMapView*)[self view] removeAnnotation:arg];
		}, NO);
	}
//	else 
//	{
//		if (annotationsToRemove==nil)
//		{
//			annotationsToRemove = [[NSMutableArray alloc] init];
//		}
//		if (annotationsToAdd!=nil && [annotationsToAdd containsObject:arg]) 
//		{
//			[annotationsToAdd removeObject:arg];
//		}
//		else 
//		{
//			[annotationsToRemove addObject:arg];
//		}
//	}
}


@end
