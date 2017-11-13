//
//  XZPhotoListCell.h
//  XZMoveCollectIon
//
//  Created by admin on 16/3/24.
//  Copyright © 2016年 XieZi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XZPhotoListCell : UICollectionViewCell

@property (strong, nonatomic) UIImageView *imageView;
@property (assign, nonatomic) BOOL isChoose;/**< 是否已选择 */

- (void)setNumberStr:(NSString *)btnNumStr;
- (void)setNumber:(NSInteger)btnNum;
@end
