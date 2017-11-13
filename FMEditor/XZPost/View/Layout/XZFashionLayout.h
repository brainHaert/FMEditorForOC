//
//  XZFashionLayout.h
//  FMB
//
//  Created by admin on 16/3/29.
//  Copyright © 2016年 ICompany. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XZFashionLayout;

@protocol XZFashionLayoutDelegate <NSObject>

- (CGFloat)moreHeightForCollectionView:(UICollectionView *)collectionView;

- (CGFloat)footerHeightForCollectionView:(UICollectionView *)collectionView;

@end

@interface XZFashionLayout : UICollectionViewFlowLayout

@property (nonatomic, strong) NSMutableArray *allCellSizeArr;

@property (nonatomic, strong) id<XZFashionLayoutDelegate>fashionLayoutDelegate;

@end
