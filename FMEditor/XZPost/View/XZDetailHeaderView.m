//
//  XZDetailReusableView.m
//  FMB
//
//  Created by 揭子龙 on 16/3/30.
//  Copyright © 2016年 ICompany. All rights reserved.
//
#define MarginSide 15.f


#import "XZDetailHeaderView.h"

@implementation XZDetailHeaderView
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
        _titleLabel.numberOfLines = 0;
        
        CGFloat headerW = 38.f;
        _headerView = [UIImageView imageViewWithFrame:CGRectMake(MarginSide, FMGetMaxY(_titleLabel), headerW, headerW) image:[UIImage imageNamed:@"account_noremal_head_icon.png"] contentView:self];
        [_headerView makeCornerRadius:headerW/2];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headerImageViewClick:)];
        _headerView.userInteractionEnabled = YES;
        [_headerView addGestureRecognizer:tap];
        _headerView.backgroundColor = [UIColor redColor];
        _headerView.tag = -1;
        
        CGFloat labelHeight = 20.f;
        _nameLabel = [UILabel labelFrame:CGRectMake(FMGetMaxX(_headerView) + MarginSide, _headerView.y, SCREEN_WIDTH, labelHeight) systemFont:14.f textColor:[UIColor blackColor] text:@"name" to:self];
        
        _tipLabel = [UILabel labelFrame:CGRectMake(_nameLabel.x, FMGetMaxY(_nameLabel), SCREEN_WIDTH, labelHeight) systemFont:12.f textColor:[UIColor grayColor] text:@"刚刚/45次阅读" to:self];
    }
    return self;
}

- (void)getDetailReuseableViewData:(NSDictionary *)dataDict {
    
    NSString *title = [dataDict stringValueForKey:@"title"];
    
    CGFloat height = [NSString heightFromString:title withLabelWidth:SCREEN_WIDTH - MarginSide * 2 andLabelFont:[UIFont boldSystemFontOfSize:28.f]];
    
    CGFloat addHeight = 0.f;
    if (height > HEADERHEIGHT) {
        addHeight = height - HEADERHEIGHT + HEADERHEIGHT/2;
    }
    
    _titleLabel.h = addHeight + HEADERHEIGHT;
    
    _titleLabel.text = title;
    
    NSString *URLstr = [dataDict stringValueForKey:@"head_pic"];
    
    [_headerView sd_setImageWithURL:[NSURL URLWithString:URLstr] placeholderImage:[UIImage imageNamed:@"account_noremal_head_icon.png"]];
    _headerView.tag = [dataDict integerValueForKey:@"user_id"];
    _headerView.y = FMGetMaxY(_titleLabel);
    
    _nameLabel.text = [dataDict stringValueForKey:@"nick_name"];
    _nameLabel.y = _headerView.y;
    
    NSString *time = [NSString stringWithFormat:@"%zd",[dataDict integerValueForKey:@"create_time"]/1000];
    NSString *timeStr = [NSString changeResultFromTimestamp:time];
    
    NSInteger read = [dataDict integerValueForKey:@"read_num"];
    
    _tipLabel.text = [NSString stringWithFormat:@"%@/%zd次阅读",timeStr,read];
    _tipLabel.y = FMGetMaxY(_nameLabel);
}

- (void)headerImageViewClick:(UIGestureRecognizer *)tap {
    if (tap.view.tag == -1) {
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(detailHeaderImageViewClick:)]) {
        [self.delegate detailHeaderImageViewClick:[NSString stringWithFormat:@"%zd",tap.view.tag]];
    }
}
@end
