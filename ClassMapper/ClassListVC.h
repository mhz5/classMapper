//
//  ClassListVC.h
//  ClassMapper
//
//  Created by Michael Zhao on 7/16/14.
//  Copyright (c) 2014 Michael Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassListVC : UIViewController


@property (weak, nonatomic) IBOutlet UITextField *courseField;
@property (weak, nonatomic) IBOutlet UITextView *courseView;

- (IBAction)mapClasses:(id)sender;


//@property (weak, nonatomic) 

@end
