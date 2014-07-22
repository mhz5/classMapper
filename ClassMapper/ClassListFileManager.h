//
//  ClassListFileManager.h
//  ClassMapper
//
//  Created by Michael Zhao on 7/18/14.
//  Copyright (c) 2014 Michael Zhao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClassListFileManager : NSObject

+ (void)storeObject:(NSMutableDictionary *)dict withName:(NSString *)name;
+ (void)deleteObjectWithName:(NSString *)name;
+ (NSMutableDictionary *)retrieveObjectWithName:(NSString *)name;
+ (BOOL)fileExistsWithName:(NSString *)name;

@end
