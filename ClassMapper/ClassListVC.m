//
//  ClassListVC.m
//  ClassMapper
//
//  Created by Michael Zhao on 7/16/14.
//  Copyright (c) 2014 Michael Zhao. All rights reserved.
//

#import "ClassListVC.h"
#import "MapVC.h"

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/* Button action: transition to map view and map classes. */
- (IBAction)mapClasses:(id)sender {
    MapVC *map = [[MapVC alloc] initWithNibName:@"MapVC" bundle:nil];
    
    // Set transition animation style.
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    map.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:map animated:YES completion:nil];
}
@end
