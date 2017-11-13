//
//  XZImageCell.h
//  XZMoveCollectIon
//
//  Created by admin on 16/3/17.
//  Copyright © 2016年 XieZi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XZImageCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;/**< 图*/

- (void)setCellImage:(NSArray *)array indexPath:(NSIndexPath *)indePath;

@end
