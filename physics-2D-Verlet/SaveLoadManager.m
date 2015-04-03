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
    return [[[self documentsPath] stringByAppendingPathComponent:name] stringByAppendingPathExtension:@"parts"];
}

-(NSString*) thumbForName:(NSString*)name{
    return [[[self documentsPath] stringByAppendingPathComponent:name] stringByAppendingPathExtension:@"png"];
}

-(void) savePoints:(NSArray*)points andSticks:(NSArray*)sticks andBallons:(NSArray*)balloons forName:(NSString*)name{
    NSDictionary* infoToSave = @{
                                 @"points" : points,
                                 @"sticks" : sticks,
                                 @"balloons" : balloons
                                 };
    
    NSString* pathToSaveTo = [self pathForName:name];
    
    [NSKeyedArchiver archiveRootObject:infoToSave toFile:pathToSaveTo];
    
    
    CGPoint translate = CGPointMake(CGFLOAT_MAX, CGFLOAT_MAX);
    CGPoint maxP = CGPointZero;
    for (MMStick* stick in [sticks arrayByAddingObjectsFromArray:balloons]) {
        for (MMPoint* p in [stick allPoints]) {
            if(p.x < translate.x) translate.x = p.x;
            if(p.y < translate.y) translate.y = p.y;
            if(p.x > maxP.x) maxP.x = p.x;
            if(p.y > maxP.y) maxP.y = p.y;
        }
    }
    translate.x -= 40;
    translate.y -= 40;
    maxP.x += 40;
    maxP.y += 40;
    CGSize deviceSize = CGSizeMake(maxP.x - translate.x, maxP.y - translate.y);
    CGSize targetSize = CGSizeMake(100, 100);
    CGFloat scale = MIN(targetSize.width / deviceSize.width,
                        targetSize.height / deviceSize.height);
    
    CGPoint transCenter = CGPointMake(deviceSize.width * scale, deviceSize.height * scale);
    transCenter.x = (targetSize.width - transCenter.x)/2;
    transCenter.y = (targetSize.height - transCenter.y)/2;
    
    UIGraphicsBeginImageContext(CGSizeMake(100, 100));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(context, scale, scale);
    CGContextTranslateCTM(context, -translate.x + transCenter.x/scale,
                          -translate.y + transCenter.y/scale);
    
    for (MMStick* stick in sticks) {
        [stick render];
    }
    for (MMStick* balloon in balloons) {
        [balloon render];
    }
    
    UIImage* thumb = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [UIImagePNGRepresentation(thumb) writeToFile:[self thumbForName:name] atomically:YES];
    NSLog(@"saved to : %@", [self thumbForName:name]);
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
