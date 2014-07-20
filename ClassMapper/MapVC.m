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
#import "ClassListFileManager.h"

@interface MapVC ()

@end

@implementation MapVC 
    GMSMapView *mapView_;


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
    
    _buildingCodes = [ClassListFileManager retrieveObjectWithName:@"building_codes"];
    
    
  
    
    [self centerMap];
    [self annotateCourses];
}

- (void)createGMap {
    // Create a GMSCameraPosition that tells the map to display the
    // coordinate -33.86,151.20 at zoom level 6.
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:41.314081
                                                            longitude:-72.928297
                                                                 zoom:15];
    mapView_ = [GMSMapView mapWithFrame:CGRectMake(0, 0, 320, 568) camera:camera];
    mapView_.myLocationEnabled = YES;
    
    [self.view addSubview:mapView_];
    [self.view sendSubviewToBack:mapView_];
    
    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(-33.86, 151.20);
    marker.title = @"Sydney";
    marker.snippet = @"Australia";
    marker.map = mapView_;
}

- (void)centerMap {
    MKCoordinateRegion region;
    region.center.latitude = 41.314081;
    region.center.longitude = -72.928297;
    region.span.latitudeDelta = .04;
    region.span.longitudeDelta = .04;
    
    [_yaleMap setRegion:region];
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
        NSString *address = [[_buildingCodes objectForKey:building] objectForKey:@"address"];
        
        // Search the map for that address.
        MKLocalSearchRequest *req = [[MKLocalSearchRequest alloc] init];
        req.naturalLanguageQuery = address;
        
        MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:req];
        [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
            NSArray *arr = response.mapItems;
            for(MKMapItem *item in arr) {
                NSLog(@"%@", item);
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
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
        NSLog(@"Dismissed MapVC");
    }];
}


@end
