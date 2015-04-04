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
}

@synthesize center;
@synthesize radius;
@synthesize tail;
@synthesize stick;

-(id) init{
    if(self = [super init]){
        radius = kBalloonRadius;
        center = [[MMPoint alloc] init];
        center.attachable = NO;
        center.gravityModifier = ^(CGFloat g){
            return -g;
        };
        tail = [[MMPoint alloc] init];
        tail.x = radius;
        [tail nullVelocity];
        tail.gravityModifier = ^(CGFloat g){
            return g/10.0f;
        };
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


-(void) renderWithHighlight{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, CGSizeZero, kShadowWidth, [[UIColor whiteColor] colorWithAlphaComponent:kShadowOpacity].CGColor);
    [self render];
    CGContextRestoreGState(context);
}

-(void) render{
//    [center render];
    UIBezierPath* balloon = [UIBezierPath bezierPathWithArcCenter:self.center.asCGPoint
                                                       radius:radius
                                                   startAngle:0
                                                     endAngle:2*M_PI
                                                    clockwise:YES];
    
    [[UIColor colorWithRed:180/255.0 green:0 blue:0 alpha:1] setFill];
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
        center.gravityModifier = ^(CGFloat g){
            return -g;
        };
    }
    if(p == tail){
        tail = newP;
        tail.gravityModifier = ^(CGFloat g){
            return g/10.0f;
        };
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
}

-(id) initWithCoder:(NSCoder *)aDecoder{
    if(self = [self init]){
        [self replacePoint:center withPoint:[aDecoder decodeObjectForKey:@"center"]];
        [self replacePoint:tail withPoint:[aDecoder decodeObjectForKey:@"tail"]];
    }
    return self;
}

@end
