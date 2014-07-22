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
    
    if ([[self trimWhitespace:textField.text] isEqualToString:@""]) {
        [textField resignFirstResponder];
        textField.text = @"";
        return YES;
    }

    
    NSString *newCourse = [self parseCourseInput:textField.text];
    
    // If the course is already in the user's courseList, don't let them add it again.
    if ([_courseList containsObject:newCourse]) {
        UIAlertView *errorView = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"You've already added that class." delegate:self cancelButtonTitle:@"Cool" otherButtonTitles:nil, nil];
        [errorView show];
        
        // Clear the text field.
        textField.text = @"";
    }
    else {
        [_courseList addObject:newCourse];
        
        NSLog(@"Course List: %@", _courseList);
        
        if (FALSE == [_textView.text isEqualToString:@""])
            newCourse = [NSString stringWithFormat:@"\n%@", newCourse];
        
        _textView.text = [NSString stringWithFormat:@"%@%@", _textView.text, newCourse];
        
        
        textField.text = @"";
    }
    
    return YES;
}

// Parses user course input.
// Generates course name in format: "SUBJ CODE" with whitespace in between.
- (NSString *)parseCourseInput:(NSString *)input {
    NSString *tmp = [input uppercaseString];
//    NSRange subjRange = [tmp rangeOfCharacterFromSet:[NSCharacterSet uppercaseLetterCharacterSet]];

    NSUInteger sep = [tmp rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]].location;
    
    // If there is no CODE, then sep becomes large number. Reset it to string length.
    // TODO: throw an error here.
    sep = sep > 100 ? [tmp length] : sep;
    NSString *subj = [self trimWhitespace:[tmp substringWithRange:NSMakeRange(0, sep)]];
    NSString *code = [self trimWhitespace:[tmp substringWithRange:NSMakeRange(sep, [tmp length] - sep)]];
    
    return [NSString stringWithFormat:@"%@ %@", subj, code];
}

- (NSString *)trimWhitespace:(NSString *)str {
    return [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}
            
@end
