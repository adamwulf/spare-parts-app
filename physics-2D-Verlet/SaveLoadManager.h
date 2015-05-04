//
//  SaveLoadManager.h
//  spareparts
//
//  Created by Adam Wulf on 4/2/15.
//  Copyright (c) 2015 Milestone made. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SaveLoadManager : NSObject

-(id) init NS_UNAVAILABLE;

+(SaveLoadManager*) sharedInstance;

-(void) savePoints:(NSArray*)points andSticks:(NSArray*)sticks forName:(NSString*)name;

-(NSDictionary*) loadName:(NSString*)name;

-(void) deleteItemForName:(NSString*)name;

-(NSArray*) allSavedItems;

@end
