//
//  ClassListVC.m
//  ClassMapper
//
//  Created by Michael Zhao on 7/16/14.
//  Copyright (c) 2014 Michael Zhao. All rights reserved.
//

#import "ClassListFileManager.h"
#import "ClassListVC.h"
#import "MapVC.h"
#import <Parse/Parse.h>

@interface ClassListVC ()

@end

@implementation ClassListVC
UIModalTransitionStyle modalTransitionStyle;

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

    [self setupBuildingCodes];

    [self setupKeyboardDismissal];
    
    [self setupTextBoxes];
}

- (void)setupBuildingCodes {
    if ([ClassListFileManager fileExistsWithName:@"building_codes"]) {
        // TODO: Perform sanity checks on building data if the file exists.

        _buildingCodes = [ClassListFileManager retrieveObjectWithName:@"building_codes"];
        
//        NSLog(@"File 'building_codes' exists.\nBuilding codes: %@", _buildingCodes);
    }
    else {

        PFQuery *query = [PFQuery queryWithClassName:@"Building"];
        [query setLimit:150];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (error)
                NSLog(@"%@", error.userInfo);
            else {
                NSLog(@"Response: %@", objects);
                // Dictionary to store all building data.
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                
                for (id object in objects) {
                    PFObject *obj = object;
                    NSString *address = [obj objectForKey:@"address"];
                    NSString *code = [obj objectForKey:@"code"];
                    NSString *name = [obj objectForKey:@"name"];
                    
                    NSMutableDictionary *buildingDict = [NSMutableDictionary dictionaryWithObjects:@[name, address] forKeys:@[@"name", @"address"]];
                    
                    // Index on building code.
                    [dict setValue:buildingDict forKey:code];
                }
                
                // Store building codes.
                _buildingCodes = dict;
                
                // Save them in file system for future use.
                [ClassListFileManager storeObject:dict withName:@"building_codes"];

                //        NSLog(@"Creating file 'building_codes.");
            }
        }];
    }
}

- (void)setupKeyboardDismissal {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

- (void)dismissKeyboard {
    [_courseField resignFirstResponder];
    [_courseView resignFirstResponder];
}

- (void)setupTextBoxes {
    
    _delegate = [[ClassListDelegate alloc] initWithTextField:_courseField andTextView:_courseView];
    _courseView.delegate = _delegate;
    _courseField.delegate = _delegate;
}

/* Button action: transition to map view and map classes. */
- (IBAction)mapClasses:(id)sender {
    MapVC *map = [[MapVC alloc] initWithNibName:@"MapVC" bundle:nil];
    [map setCourseList:[_delegate getCourseList]];
    
    // Set transition animation style.
//    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//    map.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:map animated:YES completion:nil];
    
    map = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
