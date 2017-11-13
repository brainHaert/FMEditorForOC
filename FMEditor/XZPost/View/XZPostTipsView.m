//
//  XZPostTipsView.m
//  FMB
//
//  Created by admin on 16/3/31.
//  Copyright © 2016年 ICompany. All rights reserved.
//
#define TipHeight 54.f

#import "XZPostTipsView.h"
#import "UIView+Extension.h"

@implementation XZPostTipsView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor redColor];
        self.font = [UIFont systemFontOfSize:18.f];
        self.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

#pragma mark 显示
- (void)showTipsView:(NSString *)string {
    self.text = string;
    [UIView animateWithDuration:0.3f animations:^{
        self.y = 0.f;
        
    } completion:^(BOOL finished) {
        [self performSelector:@selector(dismissMyseft) withObject:self afterDelay:0.9f];
    }];
}

- (void)dismissMyseft {
    [UIView animateWithDuration:0.3f animations:^{
        self.y = -TipHeight;
    } completion:^(BOOL finished) {
//        [self removeFromSuperview];
    }];
    
}

- (UILabel *)labelFrame:(CGRect)rect align:(NSTextAlignment)align systemFont:(CGFloat)fontFloat textColor:(UIColor *)color text:(NSString *)text to:(UIView *)contentView{
    UILabel *label = [[UILabel alloc]initWithFrame:rect];
    label.font = [UIFont systemFontOfSize:fontFloat];
    label.textAlignment = align;
    label.textColor = color;
    label.text = text;
    [contentView addSubview:label];
    return label;
}

#pragma mark 我自己的rect
+ (CGRect)getTipsViewFrame {
    return CGRectMake(0.f, -TipHeight, SCREEN_WIDTH, TipHeight);
}

@end
