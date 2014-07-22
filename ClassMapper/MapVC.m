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

@implementation MapVC {
    GMSMapView *_yaleMap;
    NSMutableArray *_curMarkers;
}

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
  
    _curMarkers = [[NSMutableArray alloc] init];
    
    [self createGMap];
    [self setupDaySegment];
    [self initCourseSchedule];
    [self loadCourses];
    // NOTE: Show Monday's courses in loadCourses()
    
}

// Create the Google Map focused on Yale campus.
- (void)createGMap {
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:41.314081
                                                            longitude:-72.928297
                                                                 zoom:15];
    _yaleMap = [GMSMapView mapWithFrame:CGRectMake(0, 0, 320, 568) camera:camera];
    _yaleMap.myLocationEnabled = YES;
    

    [self.view addSubview:_yaleMap];
    [self.view insertSubview:_yaleMap atIndex:0];
}

- (void)setupDaySegment {
    [_daySegment addTarget:self action:@selector(handleDaySegmentChange) forControlEvents:UIControlEventValueChanged];
}

- (void)handleDaySegmentChange {
    NSLog(@"index: %d", (int) _daySegment.selectedSegmentIndex);
    NSArray *days = @[@"M", @"T", @"W", @"TH", @"F"];
    
    NSInteger curSegment = _daySegment.selectedSegmentIndex;
    
    [self showCoursesForDay:[days objectAtIndex:curSegment]];
}

// Initializes the dictionary used to maintain the course schedule.
// Dictionary of 5 Arrays (one for each day of the week);
- (void)initCourseSchedule {
    _courseSchedule = [[NSMutableDictionary alloc] init];
    NSArray *days = @[@"M", @"T", @"W", @"TH", @"F"];
    
    for (NSString *day in days)
        [_courseSchedule setObject:[[NSMutableArray alloc] init] forKey:day];
}

// Store course information in the _courseSchedule dictionary.
- (void)loadCourses {
    for (NSString *course in _courseList) {
        NSArray *arr = [course componentsSeparatedByString:@" "];
        
        // Get the course's building info.
        PFQuery *query = [PFQuery queryWithClassName:@"Course"];
        [query whereKey:@"subject" containsString:arr[0]];
        [query whereKey:@"code" containsString:arr[1]];
        
        // TODO: Move into background.
        PFObject *courseObj = [query getFirstObject];
        
        NSString *building = [courseObj objectForKey:@"building"];
        
        // Days this course meets.
        NSArray *days = [courseObj objectForKey:@"meet_days"];
        
        // Look up the building's address.
        NSString *address = [[_buildingCodes objectForKey:building] objectForKey:@"address"];
  
        // Search the map for that address.
        MKLocalSearchRequest *req = [[MKLocalSearchRequest alloc] init];
        req.naturalLanguageQuery = address;
        
        MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:req];
        [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
            NSArray *arr = response.mapItems;
            for(MKMapItem *item in arr) {
                
//                NSLog(@"Map Item: %@", item);

                // Creates a marker at the specified location.
                GMSMarker *marker = [[GMSMarker alloc] init];
                marker.position = item.placemark.coordinate;
                marker.title = course;
                marker.snippet = item.placemark.name;
                
                for (NSString *day in days) {
                    [[_courseSchedule objectForKey:day] addObject:marker];
                    [_curMarkers addObject:marker];
                }
                
            }
            
            // Show Monday's courses in callback, so map isn't initially empty.
            [self showCoursesForDay:@"M"];

//            NSLog(@"Course Schedule: %@", _courseSchedule);

        }];
        
    }
}

- (void)setCourseList:(NSMutableArray *) courseList {
    _courseList = courseList;
}


- (void)showCoursesForDay:(NSString *) day {
    
    // Clear the map and the _curMarkers array.
    for (GMSMarker *marker in _curMarkers)
        marker.map = nil;
    
    [_curMarkers removeAllObjects];
    
    // Show the markers for the specified day.
    for (GMSMarker *marker in [_courseSchedule objectForKey:day]) {
        [_curMarkers addObject:marker];
        marker.map = _yaleMap;
    }
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
