//
//  MapVC.m
//  ClassMapper
//
//  Created by Michael Zhao on 7/14/14.
//  Copyright (c) 2014 Michael Zhao. All rights reserved.
//

#import "MapVC.h"

@interface MapVC ()

@end

@implementation MapVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    MKCoordinateRegion region;
    region.center.latitude = 41.314081;
    region.center.longitude = -72.928297;
    region.span.latitudeDelta = .04;
    region.span.longitudeDelta = .04;
    
    [_map setRegion:region animated:YES];
    
    // Do any additional setup after loading the view.
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    NSLog(@"lat: %f", mapView.centerCoordinate.latitude);
    NSLog(@"long: %f", mapView.centerCoordinate.longitude);
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
