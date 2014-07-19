//
//  MapVC.m
//  ClassMapper
//
//  Created by Michael Zhao on 7/14/14.
//  Copyright (c) 2014 Michael Zhao. All rights reserved.
//

#import <Parse/Parse.h>
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
    
    [self centerMap];
    [self annotateCourses];
}

- (void)centerMap {
    MKCoordinateRegion region;
    region.center.latitude = 41.314081;
    region.center.longitude = -72.928297;
    region.span.latitudeDelta = .04;
    region.span.longitudeDelta = .04;
    
    [_yaleMap setRegion:region animated:YES];
    _yaleMap.delegate = self;
}

- (void)annotateCourses {
    for (NSString *course in _courseList) {
        NSArray *arr = [course componentsSeparatedByString:@" "];
        
        // Get the course's building info.
        PFQuery *query = [PFQuery queryWithClassName:@"Course"];
        [query whereKey:@"subject" containsString:arr[0]];
        [query whereKey:@"code" containsString:arr[1]];
        PFObject *courseObj = [query getFirstObject];
        NSString *building = [courseObj objectForKey:@"building"];
        
        // Look up the building's address.
        PFQuery *locationQuery = [PFQuery queryWithClassName:@"Building"];
        [locationQuery whereKey:@"code" containsString:building];
        PFObject *locObj = [locationQuery getFirstObject];
        NSString *address = [locObj objectForKey:@"address"];
        
        // Search the map for that address.
        MKLocalSearchRequest *req = [[MKLocalSearchRequest alloc] init];
        req.naturalLanguageQuery = address;
        
        MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:req];
        [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
            NSArray *arr = response.mapItems;
            for(MKMapItem *item in arr) {

                [_yaleMap addAnnotation:item.placemark];
                
            }
        }];
        
    }
}


- (void)setCourseList:(NSMutableArray *) courseList {
    _courseList = courseList;
}

#pragma mark - MapView delegate methods

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
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"Dismissed MapVC");
    }];
}

@end
