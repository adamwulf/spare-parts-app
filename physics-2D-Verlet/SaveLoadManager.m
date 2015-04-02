//
//  SaveLoadManager.m
//  spareparts
//
//  Created by Adam Wulf on 4/2/15.
//  Copyright (c) 2015 Milestone made. All rights reserved.
//

#import "SaveLoadManager.h"

@implementation SaveLoadManager

-(id) init{
    if(self = [super init]){
        
    }
    return self;
}

static SaveLoadManager* _instance;

+(SaveLoadManager*) sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[[SaveLoadManager class] alloc] init];
    });
    return _instance;
}

-(NSString*) documentsPath{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
}

-(void) savePoints:(NSArray*)points andSticks:(NSArray*)sticks andBallons:(NSArray*)balloons forName:(NSString*)name{
    NSDictionary* infoToSave = @{
                                 @"points" : points,
                                 @"sticks" : sticks,
                                 @"balloons" : balloons
                                 };
    
    NSString* pathToSaveTo = [[[self documentsPath] stringByAppendingPathComponent:name] stringByAppendingPathExtension:@".parts"];
    
    [NSKeyedArchiver archiveRootObject:infoToSave toFile:pathToSaveTo];
}

@end
