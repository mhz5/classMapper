//
//  MapVC.h
//  ClassMapper
//
//  Created by Michael Zhao on 7/14/14.
//  Copyright (c) 2014 Michael Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapVC : UIViewController <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *yaleMap;
@property (weak, nonatomic) NSArray *courseList;

- (IBAction)toClassList:(id)sender;

@end
