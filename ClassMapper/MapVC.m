//
//  MapVC.m
//  ClassMapper
//
//  Created by Michael Zhao on 7/14/14.
//  Copyright (c) 2014 Michael Zhao. All rights reserved.
//

#import "MapVC.h"
#import "ClassListVC.h"

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
    
    [_yaleMap setRegion:region animated:YES];
    

    CLLocationCoordinate2D coor;
    coor.latitude = 41.314081;
    coor.longitude = -72.928297;
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = coor;
    
    [_yaleMap addAnnotation:annotation];
    
    MKLocalSearchRequest *req = [[MKLocalSearchRequest alloc] init];
    req.naturalLanguageQuery = @"grove street and whitney, New Haven, CT";
    req.region = region;
    
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:req];
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        NSArray *arr = response.mapItems;
        for(MKMapItem *item in arr)
            NSLog(@"Search Results: %@", item.placemark);
    }];
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

- (IBAction)toClassList:(id)sender {
    ClassListVC *classList = [[ClassListVC alloc] init];
    [self presentViewController:classList animated:YES completion:nil];
}
@end
