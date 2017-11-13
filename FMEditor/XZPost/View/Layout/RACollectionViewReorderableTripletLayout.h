//
//  RACollectionViewReorderableTripletLayout.h
//  RACollectionViewTripletLayout-Demo
//
//  Created by Ryo Aoyama on 5/27/14.
//  Copyright (c) 2014 Ryo Aoyama. All rights reserved.
//

#import "RACollectionViewTripletLayout.h"

@protocol RACollectionViewReorderableTripletLayoutDataSource <RACollectionViewTripletLayoutDatasource>

@optional

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath willMoveToIndexPath:(NSIndexPath *)toIndexPath;
- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath didMoveToIndexPath:(NSIndexPath *)toIndexPath;

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath;
///全部是否可以移动
- (BOOL)canMoveCollectionView:(UICollectionView *)collectionView;

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath canMoveToIndexPath:(NSIndexPath *)toIndexPath;

@end

@protocol RACollectionViewDelegateReorderableTripletLayout <RACollectionViewDelegateTripletLayout>

@optional

- (CGFloat)reorderingItemAlpha:(UICollectionView * )collectionview; //Default 0.
- (UIEdgeInsets)autoScrollTrigerEdgeInsets:(UICollectionView *)collectionView; //Sorry, has not supported horizontal scroll.
- (UIEdgeInsets)autoScrollTrigerPadding:(UICollectionView *)collectionView;

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout willBeginDraggingItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout didBeginDraggingItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout willEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout didEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath;
///自定义的点击了哪个cell
- (void)customCollectionView:(UICollectionView *)collectionView didSeleted:(NSIndexPath *)indexPath;
///自定义的删除cell
- (void)customCollectionView:(UICollectionView *)collectionView deleteCell:(NSIndexPath *)indexPath;
///自定义的编辑文字cell
- (void)customCollectionView:(UICollectionView *)collectionView editText:(NSIndexPath *)indexPath;
///自定义的更换cell图片
- (void)customCollectionView:(UICollectionView *)collectionView changeImage:(NSIndexPath *)indexPath;
///自定义的切换文字cell对齐方式（暂时不实现）
- (void)customCollectionView:(UICollectionView *)collectionView changeAlignment:(NSIndexPath *)indexPath;

@end



@interface RACollectionViewReorderableTripletLayout : RACollectionViewTripletLayout <UIGestureRecognizerDelegate>

@property (nonatomic, weak) id<RACollectionViewDelegateReorderableTripletLayout> delegate;
@property (nonatomic, weak) id<RACollectionViewReorderableTripletLayoutDataSource> datasource;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGesture;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
- (void)removeAndNilCellFakeView;
@end
