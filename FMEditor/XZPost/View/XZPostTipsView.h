//
//  XZPostTipsView.h
//  FMB
//
//  Created by admin on 16/3/31.
//  Copyright © 2016年 ICompany. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XZPostTipsView : UILabel

///显示
- (void)showTipsView:(NSString *)string;

///我自己的rect
+ (CGRect)getTipsViewFrame;

@end
