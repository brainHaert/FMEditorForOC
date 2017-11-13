//
//  UIView+Extension.m
//  FMsecert
//
//  Created by Vincent_Guo on 15-3-16.
//  Copyright (c) 2015年 Fung. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)

-(void)setSize:(CGSize)size{
    self.bounds = CGRectMake(0, 0, size.width, size.height);
}

-(CGSize)size{
    return self.bounds.size;
}

-(void)setW:(CGFloat)w{
    
    CGRect frm = self.frame;
    frm.size.width = w;
    self.frame = frm;
}

-(CGFloat)w{
    return self.size.width;
}


-(void)setH:(CGFloat)h{
    CGRect frm = self.frame;
    frm.size.height = h;
    self.frame = frm;
}

-(CGFloat)h{
    return self.size.height;
}

-(void)setX:(CGFloat)x{
    CGRect frm = self.frame;
    frm.origin.x = x;
    
    self.frame = frm;
}
-(CGFloat)x{
    return self.frame.origin.x;
}

-(void)setY:(CGFloat)y{
    CGRect frm = self.frame;
    frm.origin.y = y;
    self.frame = frm;
    
}

-(CGFloat)y{
    return self.frame.origin.y;
}


- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerX
{
    return self.center.x;
}

@end
