# MKMapView-Polyline-Designer

MapPolylineDesigner is a custom class that designed to select two coordinates on MKMapView and draw / design a polyline in between coordinates based on maps.googleapis.com data. further more it capable of calculate shortest route in between coordinates, total distance, total duration and many more information. Class is based on Objective-C language and require MKMapView, MapKit and CoreLocation frameworks for function the functionalities.

To use MapPolylineDesigner in your project, please follow following steps

1. Linked both MapKit.framework and CoreLocation.framework to your project (General -> Linked Frameworks and Libraries)

2. Add (or Drag and drop to Your project in Xcode) both MapPolylineDesigner.h and MapPolylineDesigner.m files to your project 

3. Add following keys and values to your project info.plist file

	    <key>NSLocationAlwaysUsageDescription</key>
	    <string>This application requires location services to work</string>
	    <key>NSLocationWhenInUseUsageDescription</key>
	    <string>This application requires location services to work</string>
	    <key>NSAppTransportSecurity</key>
	    <dict>
		    <key>NSAllowsArbitraryLoads</key>
		    <true/>
		    <key>NSExceptionDomains</key>
		    <dict>
			    <key>http://maps.googleapis.com</key>
			    <dict>
				    <key>NSIncludesSubdomains</key>
				    <true/>
				    <key>NSThirdPartyExceptionRequiresForwardSecrecy</key>
				    <false/>
			    </dict>
		    </dict>
	    </dict>

4. Import both MapKit framework and MapPolylineDesigner.h to your ViewController.h

	Ex:
      
          #import <MapKit/MapKit.h>
      
	      #import "MapPolylineDesigner.h"
      
5. Declare and initiate an object of MapPolylineDesigner class using custom init method
	
	- (id)initWithMapView:(MKMapView *)mapView Type:(NSUInteger)mapViewType andViewController:(UIViewController *)viewController;
	
	Ex:
  
          MapPolylineDesigner *mapPolylineDesigner mapPolylineDesigner = [[MapPolylineDesigner alloc] initWithMapView:YOUR_MAP_VIEW Type:MKMapTypeStandard andViewController:self]; // Map View Types: MKMapTypeStandard | MKMapTypeSatellite | MKMapTypeHybrid

6. Add following methods to your ViewController.m file

          - (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay{
              if ([overlay isKindOfClass:[MKPolyline class]]) {
                  MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
                  [renderer setStrokeColor:[UIColor blueColor]];
                  [renderer setLineWidth:8.0];
                  return renderer;
              }
              return nil;
          }

          - (void)getPolylineDataOfMapView:(NSDictionary *)polylineDataSource {
              NSLog(@"More info: %@",polylineDataSource);
          } 


Use following methods to set and get pick up location

    // Set pick up location
    // - (Boolean)setPickupLocationWithCoordinateOfLongitude:(float)longitude andLatitude:(float)latitude;
	    Ex:
		    Bool value = [mapPolylineDesigner setPickupLocationWithCoordinateOfLongitude:YOUR_MAP_VIEW.centerCoordinate.longitude andLatitude:YOUR_MAP_VIEW.centerCoordinate.latitude];

    // Get pick up location
    // - (NSDictionary *)getPickupLocation;
	    Ex:
		    NSDictionary *value = [mapPolylineDesigner getPickupLocation]:


Use following methods to set and get drop off location

    // Set drop off location
    // - (Boolean)setDropoffLocationWithCoordinateOfLongitude:(float)longitude andLatitude:(float)latitude;
	    Ex:
		    Bool value = [mapPolylineDesigner setDropoffLocationWithCoordinateOfLongitude:_mapView.centerCoordinate.longitude andLatitude:_mapView.centerCoordinate.latitude];

    // Get drop off location
    // - (NSDictionary *)getDropoffLocation;
	    Ex:
		    NSDictionary *value = [mapPolylineDesigner getDropoffLocation]:


Use following methods to return more information related to route between pick up and drop off coordinates

    // - (void)getPolylineDataOfMapView:(NSDictionary *)polylineDataSource;
	    Ex:
		    NSDictionary *value = polylineDataSource;


Use following method to refresh/reload MKMapView

    // - (void)initMapView;
	    Ex:
		    [mapPolylineDesigner initMapView];


Created by Nadeeshan Jayawardana (NEngineering).
