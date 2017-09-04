//
//  MapPolylineDesigner.m
//  SampleMapViewManager
//
//  Created by Nadeeshan Jayawardana on 9/4/17.
//  Copyright © 2017 Nadeeshan Jayawardana (NEngineering). All rights reserved.
//

#import "MapPolylineDesigner.h"

@implementation MapPolylineDesigner {
    MKMapView *polylineMapView;
    NSUInteger polylineMapViewType;
    UIViewController *childViewController;
    CLLocationManager *locationManager;
    
    MKPointAnnotation *pickupAnnotation;
    float pickupLocationLatitude;
    float pickupLocationLongitude;
    
    MKPointAnnotation *dropoffAnnotation;
    float dropoffLocationLatitude;
    float dropoffLocationLongitude;
}

// Initiate class with a Mapview
- (id)initWithMapView:(MKMapView *)mapView Type:(NSUInteger)mapViewType andViewController:(UIViewController *)viewController {
    self = [super init];
    if (self) {
        if (mapView != nil) {
            polylineMapView = mapView;
            polylineMapViewType = mapViewType;
            childViewController = viewController;
            [self initMapView];
        } else {
            NSLog(@"Error: Map View or Map View Type cannot be empty");
        }
    }
    return self;
}

// Initiate Mapview with current location
- (void)initMapView {
    polylineMapView.showsUserLocation = true;
    polylineMapView.mapType = polylineMapViewType;
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLLocationAccuracyKilometer;
    locationManager.pausesLocationUpdatesAutomatically = NO;
    [locationManager requestAlwaysAuthorization];
    CLLocation *location = [locationManager location];
    CLLocationCoordinate2D  coordinate = [location coordinate];
    polylineMapView.region = MKCoordinateRegionMakeWithDistance(coordinate, 380.0f, 380.0f);
    [locationManager startUpdatingLocation];
}

// Set annotation for Pick up location using coordinates
- (Boolean)setPickupLocationWithCoordinateOfLongitude:(float)longitude andLatitude:(float)latitude {
    if ([self setPickupAnnotationWithCoordinateOfLongitude:longitude andLatitude:latitude]) {
        pickupLocationLongitude = longitude;
        pickupLocationLatitude = latitude;
        if (dropoffAnnotation) {
            [self setPolylineOnMapViewWithPickupLongitude:pickupLocationLongitude PickupLatitude:pickupLocationLatitude DropoffLongitude:dropoffLocationLongitude DropoffLatitude:dropoffLocationLatitude];
        }
        return true;
    }
    return false;
}

- (NSDictionary *)getPickupLocation {
    return @{@"Longitude" : [NSString stringWithFormat:@"%f",pickupLocationLongitude] , @"Latitude" : [NSString stringWithFormat:@"%f",pickupLocationLatitude]};
}

- (Boolean)setPickupAnnotationWithCoordinateOfLongitude:(float)longitude andLatitude:(float)latitude {
    if (pickupAnnotation) {
        [polylineMapView removeAnnotation:pickupAnnotation];
    }
    pickupAnnotation = [[MKPointAnnotation alloc] init];
    [pickupAnnotation setCoordinate:CLLocationCoordinate2DMake(latitude, longitude)];
    [pickupAnnotation setTitle:@"Pick Up Location"];
    [polylineMapView addAnnotation:pickupAnnotation];
    return pickupAnnotation ? true : false;
}

// Set annotation for Drop off location using coordinates
- (Boolean)setDropoffLocationWithCoordinateOfLongitude:(float)longitude andLatitude:(float)latitude {
    if ([self setDropoffAnnotationWithCoordinateOfLongitude:longitude andLatitude:latitude]) {
        dropoffLocationLongitude = longitude;
        dropoffLocationLatitude = latitude;
        [self setPolylineOnMapViewWithPickupLongitude:pickupLocationLongitude PickupLatitude:pickupLocationLatitude DropoffLongitude:dropoffLocationLongitude DropoffLatitude:dropoffLocationLatitude];
        return true;
    }
    return false;
}

- (NSDictionary *)getDropoffLocation {
    return @{@"Longitude" : [NSString stringWithFormat:@"%f",dropoffLocationLongitude] , @"Latitude" : [NSString stringWithFormat:@"%f",dropoffLocationLatitude]};
    return nil;
}

- (Boolean)setDropoffAnnotationWithCoordinateOfLongitude:(float)longitude andLatitude:(float)latitude {
    if (pickupAnnotation) {
        [polylineMapView removeAnnotation:pickupAnnotation];
        if (dropoffAnnotation) {
            [polylineMapView removeAnnotation:dropoffAnnotation];
        }
        dropoffAnnotation = [[MKPointAnnotation alloc] init];
        [dropoffAnnotation setCoordinate:CLLocationCoordinate2DMake(latitude, longitude)];
        [dropoffAnnotation setTitle:@"Drop off Location"];
        [polylineMapView addAnnotation:dropoffAnnotation];
        [polylineMapView addAnnotation:pickupAnnotation];
        return pickupAnnotation && dropoffAnnotation ? true : false;
    } else {
        NSLog(@"Error: Set the Pick up location first");
    }
    return false;
}

- (MKPolyline *)polylineWithEncodedString:(NSString *)encodedString {
    const char *bytes = [encodedString UTF8String];
    NSUInteger length = [encodedString lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    NSUInteger idx = 0;
    
    NSUInteger count = length / 4;
    CLLocationCoordinate2D *coords = calloc(count, sizeof(CLLocationCoordinate2D));
    NSUInteger coordIdx = 0;
    
    float latitude = 0;
    float longitude = 0;
    while (idx < length) {
        char byte = 0;
        int res = 0;
        char shift = 0;
        
        do {
            byte = bytes[idx++] - 63;
            res |= (byte & 0x1F) << shift;
            shift += 5;
        } while (byte >= 0x20);
        
        float deltaLat = ((res & 1) ? ~(res >> 1) : (res >> 1));
        latitude += deltaLat;
        
        shift = 0;
        res = 0;
        
        do {
            byte = bytes[idx++] - 0x3F;
            res |= (byte & 0x1F) << shift;
            shift += 5;
        } while (byte >= 0x20);
        
        float deltaLon = ((res & 1) ? ~(res >> 1) : (res >> 1));
        longitude += deltaLon;
        
        float finalLat = latitude * 1E-5;
        float finalLon = longitude * 1E-5;
        
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(finalLat, finalLon);
        coords[coordIdx++] = coord;
        
        if (coordIdx == count) {
            NSUInteger newCount = count + 10;
            coords = realloc(coords, newCount * sizeof(CLLocationCoordinate2D));
            count = newCount;
        }
    }
    
    MKPolyline *polyline = [MKPolyline polylineWithCoordinates:coords count:coordIdx];
    free(coords);
    
    return polyline;
}

// Initiate Polyline On Mapview
- (void)setPolylineOnMapViewWithPickupLongitude:(float)pickupLongitude PickupLatitude:(float)pickupLatitude DropoffLongitude:(float)dropoffLongitude DropoffLatitude:(float)dropoffLatitude {
    @try {
        NSURLSession *session = [NSURLSession sharedSession];
        [[session dataTaskWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/directions/json?origin=%f,%f&destination=%f,%f&sensor=false",pickupLatitude,pickupLongitude,dropoffLatitude,dropoffLongitude]]
                completionHandler:^(NSData *data,
                                    NSURLResponse *response,
                                    NSError *error) {
                    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (![json valueForKey:@"error_message"]) {
                            NSArray *pointsArray = [polylineMapView overlays];
                            [polylineMapView removeOverlays:pointsArray];
                            [polylineMapView addOverlay:[self polylineWithEncodedString:[[[[json valueForKey:@"routes"] valueForKey:@"overview_polyline"] objectAtIndex:0] valueForKey:@"points"]]];
                            NSDictionary *source = @{@"source":[json valueForKey:@"routes"]};
                            [childViewController performSelector:@selector(getPolylineDataOfMapView:) withObject:source];
                        } else {
                            NSLog(@"Error: %@",[json valueForKey:@"error_message"]);
                        }
                    });
                }] resume];
    } @catch (NSException *exception) {
        NSLog(@"Error: Requested timed out, Try again.");
    }
}

@end
