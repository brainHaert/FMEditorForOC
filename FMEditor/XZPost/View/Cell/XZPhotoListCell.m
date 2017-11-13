//
//  XZPhotoListCell.m
//  XZMoveCollectIon
//
//  Created by admin on 16/3/24.
//  Copyright © 2016年 XieZi. All rights reserved.
//

#import "XZPhotoListCell.h"

#pragma mark - ---------------------- cell
@implementation XZPhotoListCell{
    UIButton *_selecedBtn;  /**< 是否选中按钮 */
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self.contentView addSubview:_imageView];
        
        _selecedBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        //        [_selecedBtn setImage:[UIImage imageNamed:@"gallery_chs_normal"] forState:UIControlStateNormal];
        //        [_selecedBtn setImage:[UIImage imageNamed:@"gallery_chs_seleceted"] forState:UIControlStateSelected];
        [_selecedBtn setTitle:@"" forState:UIControlStateNormal];
        [_selecedBtn setTitle:@"1" forState:UIControlStateSelected];
        [_selecedBtn.titleLabel setFont:[UIFont systemFontOfSize:38]];
        _selecedBtn.userInteractionEnabled = NO;
        [self.contentView addSubview:_selecedBtn];
    }
    return self;
}

- (void)setIsChoose:(BOOL)isChoose{
    _isChoose = isChoose;
    _selecedBtn.selected = isChoose;
    if (isChoose) {
        _selecedBtn.backgroundColor = [UIColor colorWithRed:252/255.0 green:190/255.0 blue:0 alpha:0.5f];
//        _selecedBtn.alpha = 0.3f;
    } else {
        _selecedBtn.backgroundColor = [UIColor clearColor];
    }
}

- (void)setNumberStr:(NSString *)btnNumStr {
//    DLog(@"btnNumstr = %@", btnNumStr);
    [_selecedBtn setTitle:@"" forState:UIControlStateNormal];
}
- (void)setNumber:(NSInteger)btnNum {
//    DLog(@"btnNum = %zd", btnNum);
    [_selecedBtn setTitle:[NSString stringWithFormat:@"%zd",btnNum] forState:UIControlStateSelected];
}
@end
