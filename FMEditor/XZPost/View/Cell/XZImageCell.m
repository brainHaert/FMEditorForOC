//
//  XZImageCell.m
//  XZMoveCollectIon
//
//  Created by admin on 16/3/17.
//  Copyright © 2016年 XieZi. All rights reserved.
//

#import "XZImageCell.h"

@implementation XZImageCell


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc]init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        self.backgroundView = _imageView;
        
        
    }
    return self;
}


-(void)setCellImage:(NSArray *)array indexPath:(NSIndexPath *)indePath{
    
//    if ([[array objectAtIndex:indePath.item]isKindOfClass:[NSDictionary class]]) {
//        NSDictionary *tampDict = [array objectAtIndex:indePath.item];
//        NSString *URLstr = [tampDict stringValueForKey:@"imageUrl"];
//        [_imageView sd_setImageWithURL:[NSURL URLWithString:URLstr] placeholderImage:[UIImage imageNamed:@"load_bg1.png"]];
//        return;
//    }
    _imageView.image = [array objectAtIndex:indePath.item];

}


- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    if (highlighted) {
        _imageView.alpha = .7f;
    }else {
        _imageView.alpha = 1.f;
    }
}

@end
