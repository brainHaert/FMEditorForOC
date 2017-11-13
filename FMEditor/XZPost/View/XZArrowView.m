//
//  XZArrowView.m
//  NavigationViewController
//
//  Created by 揭子龙 on 16/3/27.
//  Copyright © 2016年 Zll. All rights reserved.
//

#define MinueHeight 10.f

#import "XZArrowView.h"

@implementation XZArrowView
{
    UILabel *_label;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - MinueHeight)];
        _label.text = @"100%";
        _label.textColor = [UIColor whiteColor];
        _label.font = [UIFont systemFontOfSize:16];
        _label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_label];
    }
    return self;
}
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    CGFloat myWidth = self.frame.size.width;
    CGFloat myHeight = self.frame.size.height - MinueHeight;
    CGFloat arrowWidth = 8.f;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextMoveToPoint(context, 0, 0);
    
    CGContextAddLineToPoint(context, myWidth, 0);
    
    CGContextAddLineToPoint(context, myWidth, myHeight);
    
    CGContextAddLineToPoint(context, myWidth/2 + arrowWidth/2, myHeight);
    
    CGContextAddLineToPoint(context, myWidth/2, myHeight + arrowWidth/5*3);
    
    CGContextAddLineToPoint(context, myWidth/2 - arrowWidth/2, myHeight);
    
    CGContextAddLineToPoint(context, 0, myHeight);
    
    [[UIColor redColor] setFill];
    
    [[UIColor redColor] setStroke];
    
    CGContextDrawPath(context , kCGPathEOFillStroke);
    
    CGContextClosePath(context);
}
- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    _label.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - MinueHeight);
}

- (void)setArrowText:(NSString *)text {
    _label.text = [text stringByAppendingString:@"%"];
}

- (void)setArrowTextHidden {
    _label.hidden = YES;
}
@end
