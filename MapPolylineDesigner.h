//
//  MapPolylineDesigner.h
//  SampleMapViewManager
//
//  Created by Nadeeshan Jayawardana on 9/4/17.
//  Copyright © 2017 Nadeeshan Jayawardana (NEngineering). All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MapPolylineDesigner : NSObject <CLLocationManagerDelegate, MKMapViewDelegate>

// Initiate class with a Mapview
- (id)initWithMapView:(MKMapView *)mapView Type:(NSUInteger)mapViewType andViewController:(UIViewController *)viewController;

// Initiate Mapview with current location
- (void)initMapView;

// Set annotation for Pick up location using coordinates
- (Boolean)setPickupLocationWithCoordinateOfLongitude:(float)longitude andLatitude:(float)latitude;
- (NSDictionary *)getPickupLocation;
- (Boolean)setPickupAnnotationWithCoordinateOfLongitude:(float)longitude andLatitude:(float)latitude;

// Set annotation for Drop off location using coordinates
- (Boolean)setDropoffLocationWithCoordinateOfLongitude:(float)longitude andLatitude:(float)latitude;
- (NSDictionary *)getDropoffLocation;
- (Boolean)setDropoffAnnotationWithCoordinateOfLongitude:(float)longitude andLatitude:(float)latitude;

@end
