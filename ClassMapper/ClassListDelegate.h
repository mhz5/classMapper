//
//  ClassListDelegate.h
//  ClassMapper
//
//  Created by Michael Zhao on 7/18/14.
//  Copyright (c) 2014 Michael Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface ClassListDelegate : NSObject <UITextViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) UITextField *textField;
@property (strong, nonatomic) UITextView *textView;
@property (strong, nonatomic) NSMutableArray *courseList;

// Methods
- (instancetype)initWithTextField:(UITextField *)textField andTextView:(UITextView *)textView;

- (NSMutableArray *)getCourseList;


@end
