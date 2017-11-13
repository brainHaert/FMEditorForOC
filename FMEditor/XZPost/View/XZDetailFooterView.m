//
//  XZFooterReusableView.m
//  FMB
//
//  Created by admin on 16/3/31.
//  Copyright © 2016年 ICompany. All rights reserved.
//

#import "XZDetailFooterView.h"

@implementation XZDetailFooterView
{
    UILabel *_praisedLabel;
//    UIImageView *_collected;
    UILabel *_collectedLabel;
    
    UIImageView *_praisedImageView;
    
    UIImageView *_collectImageView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CGFloat imageWidth = 60.f;
        CGFloat labelHeight = 20.f;
        CGFloat labelFloat = 12.f;
        
        // 打赏
        _praisedImageView = [UIImageView imageViewWithFrame:CGRectMake((self.w/2 - imageWidth)/2, (self.h - imageWidth - labelHeight)/2, imageWidth, imageWidth) image:[UIImage imageNamed:@"details_shang_icon@2x.png"] contentView:self];
        
        _praisedImageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(praiseImageClick:)];
        
        [_praisedImageView addGestureRecognizer:tap];
        
        
        _praisedLabel = [UILabel labelFrame:CGRectMake(0, FMGetMaxY(_praisedImageView), SCREEN_WIDTH/2, labelHeight) align:NSTextAlignmentCenter systemFont:12.f textColor:[UIColor blackColor] text:@"被打赏" to:self];

        
        // 收藏
        _collectImageView = [UIImageView imageViewWithFrame:CGRectMake((self.w/2 - imageWidth)/2 + self.w/2, _praisedImageView.y, imageWidth, imageWidth) image:[UIImage imageNamed:@"details_shoucang_icon@2x.png"] contentView:self];
        
        _collectImageView.userInteractionEnabled = YES;
        
        tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(collectImageClick:)];
        
        [_collectImageView addGestureRecognizer:tap];
        
        
        
        _collectedLabel = [UILabel labelFrame:CGRectMake(self.w/2, _praisedLabel.y, SCREEN_WIDTH/2, labelHeight) align:NSTextAlignmentCenter systemFont:labelFloat textColor:[UIColor blackColor] text:@"被收藏" to:self];
        
    }
    return self;
}
#pragma mark 从外部拿数据
- (void)setDetailFooterData:(NSDictionary *)dataDict {
    
    _praisedLabel.text = [NSString stringWithFormat:@"被打赏：￥%.02f",[dataDict floatValueForKey:@"praise_amount"]];
    
    _collectedLabel.text = [NSString stringWithFormat:@"被收藏：%zd次",[dataDict integerValueForKey:@"collect_num"]];
    
    NSString *imageName = @"";
    NSInteger tag;
    
    NSLog(@"=======%zd", [dataDict boolValueForKey:@"is_collect"]);
    
    if ([dataDict boolValueForKey:@"is_collect"]) {
        tag = 1;
        imageName = @"details_shoucang_icon_s@2x.png";
    } else {
        tag = 0;
        imageName = @"details_shoucang_icon@2x.png";
    }
    _collectImageView.image = [UIImage imageNamed:imageName];
    _collectImageView.tag = tag;
    if ([dataDict boolValueForKey:@"is_praise"]) {
        tag = 1;
        imageName = @"details_shang_icon_s@2x.png";
    } else {
        tag = 0;
        imageName = @"details_shang_icon@2x.png";
    }
    _praisedImageView.tag = tag;
    _praisedImageView.image = [UIImage imageNamed:imageName];
}
#pragma mark 赞点击
- (void)praiseImageClick:(UIGestureRecognizer *)guesture {
    if (guesture.view.tag) {
        return;
    }
//    if ([self.userID isEqualToString:[GETUID stringValue]]) {
//        return;
//    }
    if (!GETTOKEN) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(detailFooterViewTipsNotLogin)]) {
            [self.delegate detailFooterViewTipsNotLogin];
            return;
        }
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(detailFooterViewPraiseImageClick)]) {
        [self.delegate detailFooterViewPraiseImageClick];
    }
    _praisedImageView.image = [UIImage imageNamed:@"details_shang_icon_s@2x.png"];
}
#pragma mark 收藏图片点击
- (void)collectImageClick:(UIGestureRecognizer *)guesture {
    
    if (!GETTOKEN) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(detailFooterViewTipsNotLogin)]) {
            [self.delegate detailFooterViewTipsNotLogin];
            return;
        }
    }
    
    if (guesture.view.tag) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(detailFooterViewDeleteCollect)]) {
            [self.delegate detailFooterViewDeleteCollect];
        }
        
        _collectImageView.image = [UIImage imageNamed:@"details_shoucang_icon@2x.png"];
        
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(detailFooterViewAddCollect)]) {
        [self.delegate detailFooterViewAddCollect];
    }
    
    _collectImageView.image = [UIImage imageNamed:@"details_shoucang_icon_s@2x.png"];
    
}
@end
