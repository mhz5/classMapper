//
//  MapVC.h
//  ClassMapper
//
//  Created by Michael Zhao on 7/14/14.
//  Copyright (c) 2014 Michael Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <GoogleMaps/GoogleMaps.h>

@interface MapVC : UIViewController <MKMapViewDelegate, GMSMapViewDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *yaleMap;
@property (weak, nonatomic) NSArray *courseList;
@property (strong, nonatomic) NSMutableDictionary *buildingCodes;

- (IBAction)toClassList:(id)sender;

@end
