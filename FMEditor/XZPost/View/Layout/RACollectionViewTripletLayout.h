//
//  RACollectionViewTripletLayout.h
//  RACollectionViewTripletLayout-Demo
//
//  Created by Ryo Aoyama on 5/25/14.
//  Copyright (c) 2014 Ryo Aoyama. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RACollectionViewTripletLayout;

#define RACollectionViewTripletLayoutStyleSquare CGSizeZero

@protocol RACollectionViewDelegateTripletLayout <UICollectionViewDelegateFlowLayout>

@optional

- (CGSize)collectionView:(UICollectionView *)collectionView sizeForLargeItemsInSection:(NSInteger)section; //Default to automaticaly grow square !
- (UIEdgeInsets)insetsForCollectionView:(UICollectionView *)collectionView;
- (CGFloat)sectionSpacingForCollectionView:(UICollectionView *)collectionView;
- (CGFloat)minimumInteritemSpacingForCollectionView:(UICollectionView *)collectionView;
- (CGFloat)minimumLineSpacingForCollectionView:(UICollectionView *)collectionView;

@end

@protocol RACollectionViewTripletLayoutDatasource <UICollectionViewDataSource>

@end

@interface RACollectionViewTripletLayout : UICollectionViewFlowLayout

@property (nonatomic, weak) id<RACollectionViewDelegateTripletLayout> delegate;
@property (nonatomic, weak) id<RACollectionViewTripletLayoutDatasource> datasource;


//@property (nonatomic, assign, readonly) CGSize largeCellSize;
//@property (nonatomic, assign, readonly) CGSize smallCellSize;
@property (nonatomic, assign, readonly) CGSize largeCellSize;
@property (nonatomic, assign, readonly) CGSize smallCellSize;
@property (nonatomic, strong) NSMutableArray *largeCellSizeArray;
@property (nonatomic, strong) NSMutableArray *smallCellSizeArray;

@property (nonatomic, strong) NSMutableArray *allCellSizeArr;/**< size数组 */
@property (nonatomic, strong) NSMutableArray *allCellFrameArr;

- (CGFloat)contentHeight;

@end
