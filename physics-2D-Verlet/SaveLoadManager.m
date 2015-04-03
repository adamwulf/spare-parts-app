//
//  SaveLoadManager.m
//  spareparts
//
//  Created by Adam Wulf on 4/2/15.
//  Copyright (c) 2015 Milestone made. All rights reserved.
//

#import "SaveLoadManager.h"
#import "MMStick.h"

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

-(NSString*) pathForName:(NSString*)name{
    return [[[self documentsPath] stringByAppendingPathComponent:name] stringByAppendingPathExtension:@".parts"];
}

-(void) savePoints:(NSArray*)points andSticks:(NSArray*)sticks andBallons:(NSArray*)balloons forName:(NSString*)name{
    NSDictionary* infoToSave = @{
                                 @"points" : points,
                                 @"sticks" : sticks,
                                 @"balloons" : balloons
                                 };
    
    NSString* pathToSaveTo = [self pathForName:name];
    
    [NSKeyedArchiver archiveRootObject:infoToSave toFile:pathToSaveTo];
}

-(NSDictionary*) loadName:(NSString*)name{
    NSString* pathToLoadFrom = [self pathForName:name];
    NSDictionary* data = [NSKeyedUnarchiver unarchiveObjectWithFile:pathToLoadFrom];
    
    
    NSArray* points = [data objectForKey:@"points"];
    NSArray* sticks = [data objectForKey:@"sticks"];
    NSArray* balloons = [data objectForKey:@"balloons"];
    for(MMStick* stick in [sticks arrayByAddingObjectsFromArray:balloons]){
        for (MMPoint* p in [stick allPoints]) {
            if([points containsObject:p]){
                // good to go
            }else{
                @throw [NSException exceptionWithName:@"LoadContraptionException" reason:@"unknown point loaded" userInfo:nil];
            }
        }
    }
    
    return data;
}

@end
