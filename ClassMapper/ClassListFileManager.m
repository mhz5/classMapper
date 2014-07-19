//
//  ClassListFileManager.m
//  ClassMapper
//
//  Created by Michael Zhao on 7/18/14.
//  Copyright (c) 2014 Michael Zhao. All rights reserved.
//

#import "ClassListFileManager.h"

@implementation ClassListFileManager

+ (void)storeObject:(NSMutableDictionary *)dict withName:(NSString *)name {
    
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *savePath = [filePath stringByAppendingString:name];
    
    if (FALSE == [[NSFileManager defaultManager] fileExistsAtPath:savePath])
        [[NSFileManager defaultManager] createFileAtPath:savePath contents:nil attributes:nil];

    [dict writeToFile:savePath atomically:NO];
}

+ (NSMutableDictionary *)retrieveObjectWithName:(NSString *)name {
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *savePath = [filePath stringByAppendingString:name];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:savePath];
    if (!dict)
        return [NSMutableDictionary dictionary];
    
    return dict;
}

+ (BOOL)fileExistsWithName:(NSString *)name {
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *savePath = [filePath stringByAppendingString:name];
    
    return [[NSFileManager defaultManager] fileExistsAtPath:savePath];
}

@end
