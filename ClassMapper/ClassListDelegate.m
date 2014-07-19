//
//  ClassListDelegate.m
//  ClassMapper
//
//  Created by Michael Zhao on 7/18/14.
//  Copyright (c) 2014 Michael Zhao. All rights reserved.
//

#import "ClassListDelegate.h"

@implementation ClassListDelegate


- (instancetype)initWithTextField:(UITextField *)textField andTextView:(UITextView *)textView
{
    self = [super init];
    if (self) {
        _textView = textView;
        _textField = textField;
        _courseList = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSMutableArray *)getCourseList {
    return _courseList;
}


# pragma mark - UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    NSString *newText = textField.text;
    [_courseList addObject:newText];
    
    NSLog(@"Course List: %@", _courseList);
    
    if (FALSE == [_textView.text isEqualToString:@""])
        newText = [NSString stringWithFormat:@"\n%@", newText];
    
    _textView.text = [NSString stringWithFormat:@"%@%@", _textView.text, newText];
    
    
    textField.text = @"";
    
    return YES;
}


@end
