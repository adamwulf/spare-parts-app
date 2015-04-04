//
//  MMPoint.m
//  physics-2D-Verlet
//
//  Created by Adam Wulf on 3/23/15.
//  Copyright (c) 2015 Milestone made. All rights reserved.
//

#import "MMPoint.h"
#import "Constants.h"

@implementation MMPoint{
    UIImage* image;
}

@synthesize x;
@synthesize y;
@synthesize oldx;
@synthesize oldy;
@synthesize immovable;
@synthesize attachable;
@synthesize gravityModifier;


-(id) init{
    if(self = [super init]){
        int screwType = rand() % 9;
        NSString* imageName = [NSString stringWithFormat:@"screw-%d.png", screwType];
        image = [UIImage imageNamed:imageName];
        attachable = YES;
        
        self.gravityModifier = 1;
        self.shadowOpacity = 1;
        self.shadowSize = 15;
    }
    return self;
}

+(MMPoint*) point{
    return [[MMPoint alloc] init];
}

+(MMPoint*) pointWithCGPoint:(CGPoint)p{
    MMPoint* ret = [MMPoint point];
    ret.x = p.x;
    ret.y = p.y;
    ret.oldx = ret.x;
    ret.oldy = ret.y;
    return ret;
}

+(MMPoint*) pointWithX:(CGFloat)x andY:(CGFloat)y{
    MMPoint* ret = [MMPoint point];
    ret.x = x;
    ret.y = y;
    ret.oldx = ret.x;
    ret.oldy = ret.y;
    return ret;
}

-(CGPoint) velocityForFriction:(CGFloat)friction{
    CGPoint ret;
    ret.x = (self.x - self.oldx) * friction;
    ret.y = (self.y - self.oldy) * friction;
    return ret;
}

-(void) bump{
    self.oldx = x + (rand() % 10 - 5);
    self.oldy = y + (rand() % 10 - 5);
}

-(void) bumpBy:(CGPoint)diff{
    x += diff.x;
    y += diff.y;
}

-(CGFloat) distanceFromPoint:(CGPoint)p{
    return [MMPoint distance:self.asCGPoint and:p];
}

-(void) setX:(CGFloat)_x{
    if(isnan(_x) || !isfinite(_x)){
        @throw [NSException exceptionWithName:@"NaNException" reason:@"nan" userInfo:nil];
    }
    x = _x;
}
-(void) setY:(CGFloat)_y{
    if(isnan(_y) || !isfinite(_y)){
        @throw [NSException exceptionWithName:@"NaNException" reason:@"nan" userInfo:nil];
    }
    y = _y;
}

-(CGPoint) asCGPoint{
    return CGPointMake(x, y);
}

-(void) render{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    // translate
    CGContextTranslateCTM(context, self.x, self.y);

    [self renderAtZeroZero];
    
    CGContextRestoreGState(context);
}

-(void) renderAtZeroZero{
    CGSize sizeToRender = CGSizeMake(kPointRadius*2, kPointRadius*2);
    CGPoint center = CGPointZero;
    
    [image drawInRect:CGRectMake(center.x - sizeToRender.width/2, center.y - sizeToRender.height/2, sizeToRender.width, sizeToRender.height)];
}

-(void) nullVelocity{
    oldx = x;
    oldy = y;
}

#pragma mark - Update

-(void) updateWithGravity:(CGFloat)gravity andFriction:(CGFloat)friction{
    gravity = gravity * gravityModifier;
    if(!self.immovable){
        CGFloat vx = (self.x - self.oldx) * friction;
        CGFloat vy = (self.y - self.oldy) * friction;
        
        self.oldx = self.x;
        self.oldy = self.y;
        self.x += vx;
        self.y += vy;
        self.y += gravity;
    }
}

-(CGPoint) differenceFrom:(MMPoint*)p{
    return CGPointMake(self.asCGPoint.x - p.asCGPoint.x,
                       self.asCGPoint.y - p.asCGPoint.y);
}


#pragma mark - Helper

+(CGFloat) distance:(CGPoint)p0 and:(CGPoint)p1{
    CGFloat dx = p1.x - p0.x,
    dy = p1.y - p0.y;
    return sqrtf(dx * dx + dy * dy);
}

-(NSString*) description{
    return [NSString stringWithFormat:@"[Point %f %f]", x, y];
}

#pragma mark - NSCoding

-(void) encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:[NSNumber numberWithFloat:x] forKey:@"x"];
    [aCoder encodeObject:[NSNumber numberWithFloat:y] forKey:@"y"];
    [aCoder encodeObject:[NSNumber numberWithFloat:oldx] forKey:@"oldx"];
    [aCoder encodeObject:[NSNumber numberWithFloat:oldy] forKey:@"oldy"];
    [aCoder encodeObject:[NSNumber numberWithBool:immovable] forKey:@"immovable"];
    [aCoder encodeObject:[NSNumber numberWithBool:attachable] forKey:@"attachable"];
    [aCoder encodeObject:[NSNumber numberWithFloat:gravityModifier] forKey:@"gravityModifier"];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if(self = [self init]){
        x = [[aDecoder decodeObjectForKey:@"x"] floatValue];
        y = [[aDecoder decodeObjectForKey:@"y"] floatValue];
        oldx = [[aDecoder decodeObjectForKey:@"oldx"] floatValue];
        oldy = [[aDecoder decodeObjectForKey:@"oldy"] floatValue];
        immovable = [[aDecoder decodeObjectForKey:@"immovable"] boolValue];
        attachable = [[aDecoder decodeObjectForKey:@"attachable"] boolValue];
        gravityModifier = [[aDecoder decodeObjectForKey:@"gravityModifier"] floatValue];
    }
    return self;
}

@end
