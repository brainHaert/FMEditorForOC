//
//  XZDetailReusableView.m
//  FMB
//
//  Created by 揭子龙 on 16/3/30.
//  Copyright © 2016年 ICompany. All rights reserved.
//
#define MarginSide 15.f


#import "XZDetailReusableView.h"

@implementation XZDetailReusableView
{
    UILabel *_titleLabel;
    
    UIImageView *_headerView;
    
    UILabel *_nameLabel;
    
    UILabel *_tipLabel;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _titleLabel = [UILabel labelFrame:CGRectMake(MarginSide, 0, SCREEN_WIDTH - MarginSide * 2, HEADERHEIGHT) boldFont:28.f textColor:[UIColor blackColor] text:@"title" to:self];
        
        CGFloat headerW = 38.f;
        _headerView = [UIImageView imageViewWithFrame:CGRectMake(MarginSide, FMGetMaxY(_titleLabel), headerW, headerW) image:[UIImage imageNamed:@"account_noremal_head_icon.png"] contentView:self];
        [_headerView makeCornerRadius:headerW/2];
        
        CGFloat labelHeight = 20.f;
        _nameLabel = [UILabel labelFrame:CGRectMake(FMGetMaxX(_headerView) + MarginSide, _headerView.y, SCREEN_WIDTH, labelHeight) systemFont:14.f textColor:[UIColor blackColor] text:@"name" to:self];
        
        _tipLabel = [UILabel labelFrame:CGRectMake(_nameLabel.x, FMGetMaxY(_nameLabel), SCREEN_WIDTH, labelHeight) systemFont:12.f textColor:[UIColor grayColor] text:@"刚刚/45次阅读" to:self];
    }
    return self;
}

- (void)getDetailReuseableViewData:(NSDictionary *)dataDict {
    
    _titleLabel.text = [dataDict stringValueForKey:@"title"];
    NSString *URLstr = [dataDict stringValueForKey:@"head_pic"];
    [_headerView sd_setImageWithURL:[NSURL URLWithString:URLstr] placeholderImage:[UIImage imageNamed:@"account_noremal_head_icon.png"]];
    _nameLabel.text = [dataDict stringValueForKey:@"nick_name"];
//    _tipLabel.text = [dataDict stringValueForKey:@""];
    _tipLabel.text = @"未知字段";
}

@end
