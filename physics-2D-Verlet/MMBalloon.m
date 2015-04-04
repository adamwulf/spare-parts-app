//
//  MMBalloon.m
//  physics-2D-Verlet
//
//  Created by Adam Wulf on 3/26/15.
//  Copyright (c) 2015 Milestone made. All rights reserved.
//

#import "MMBalloon.h"
#import "Constants.h"
#import "MMStick.h"

@implementation MMBalloon{
    UIImage* texture;
    NSInteger color;
}

@synthesize center;
@synthesize radius;
@synthesize tail;
@synthesize stick;

-(id) init{
    if(self = [super init]){
        color = rand() % 4;
        radius = kBalloonRadius;
        center = [[MMPoint alloc] init];
        center.attachable = NO;
        center.gravityModifier = -1;
        tail = [[MMPoint alloc] init];
        tail.x = radius;
        [tail nullVelocity];
        tail.gravityModifier = .1;
        texture = [UIImage imageNamed:@"balloon-texture.png"];
        
        stick = [MMStick stickWithP0:center andP1:tail];
    }
    return self;
}

+(MMBalloon*) balloonWithCGPoint:(CGPoint)p{
    MMBalloon* ret = [[MMBalloon alloc] init];
    ret.center.x = p.x;
    ret.center.y = p.y;
    [ret.center nullVelocity];
    ret.tail.x = p.x;
    ret.tail.y = p.y + ret.radius;
    [ret.tail nullVelocity];
    return ret;
}
-(void) setRadius:(CGFloat)_radius{
    radius = _radius;
    stick.length = _radius;
}

-(MMPoint*) p0{
    return center;
}

-(MMPoint*) p1{
    return tail;
}


#pragma mark - Update

-(void) updateWithGravity:(CGFloat)gravity andFriction:(CGFloat)friction{
    [center updateWithGravity:-gravity andFriction:friction];
}


-(void) render{
//    [center render];
    UIBezierPath* balloon = [UIBezierPath bezierPathWithArcCenter:self.center.asCGPoint
                                                       radius:radius
                                                   startAngle:0
                                                     endAngle:2*M_PI
                                                    clockwise:YES];
    
    if(color == 0){
        [[UIColor colorWithRed:180/255.0 green:0 blue:0 alpha:1] setFill];
    }else if(color == 1){
        [[UIColor colorWithRed:0 green:180/255.0 blue:0 alpha:1] setFill];
    }else if(color == 2){
        [[UIColor colorWithRed:0 green:0 blue:180/255.0 alpha:1] setFill];
    }else if(color == 3){
        [[UIColor colorWithRed:180/255.0 green:180/255.0 blue:.2 alpha:1] setFill];
    }
    [balloon fill];
    [texture drawInRect:CGRectMake(self.center.x-radius, self.center.y - radius, radius*2, radius*2)];
    
    UIBezierPath* triangle = [UIBezierPath bezierPath];
    [triangle moveToPoint:CGPointZero];
    [triangle addLineToPoint:CGPointMake(5, 10)];
    [triangle addLineToPoint:CGPointMake(-5, 10)];
    [triangle closePath];
    CGPoint rot = CGPointMake(tail.x - center.x,
                tail.y - center.y);
    [triangle applyTransform:CGAffineTransformMakeRotation(-atan2f(rot.x, rot.y))];
    [triangle applyTransform:CGAffineTransformMakeTranslation(tail.x, tail.y)];
    [triangle fill];
}

-(void) replacePoint:(MMPoint*)p withPoint:(MMPoint*)newP{
    if(p == center){
        center = newP;
        center.attachable = NO;
        newP.gravityModifier = center.gravityModifier;
    }
    if(p == tail){
        tail = newP;
        newP.gravityModifier = tail.gravityModifier;
    }
    [stick replacePoint:p withPoint:newP];
}

-(CGFloat) distanceFromPoint:(CGPoint)point{
    CGFloat dst = [center distanceFromPoint:point];
    return dst;
}

-(void) constrain{
    [stick constrain];
}

-(MMBalloon*) cloneObject{
    return [MMBalloon balloonWithCGPoint:center.asCGPoint];
}

-(NSArray*) allPoints{
    return @[center, tail];
}

#pragma mark - NSCoding

-(void) encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:center forKey:@"center"];
    [aCoder encodeObject:tail forKey:@"tail"];
    [aCoder encodeObject:[NSNumber numberWithFloat:radius] forKey:@"radius"];
    [aCoder encodeObject:[NSNumber numberWithInt:color] forKey:@"color"];
}

-(id) initWithCoder:(NSCoder *)aDecoder{
    if(self = [self init]){
        [self replacePoint:center withPoint:[aDecoder decodeObjectForKey:@"center"]];
        [self replacePoint:tail withPoint:[aDecoder decodeObjectForKey:@"tail"]];
        color = [[aDecoder decodeObjectForKey:@"color"] intValue];
        radius = [[aDecoder decodeObjectForKey:@"radius"] floatValue];
    }
    return self;
}

@end
