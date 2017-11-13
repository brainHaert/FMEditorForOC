//
//  RACollectionViewReorderableTripletLayout.m
//  RACollectionViewTripletLayout-Demo
//
//  Created by Ryo Aoyama on 5/27/14.
//  Copyright (c) 2014 Ryo Aoyama. All rights reserved.
//

#import "RACollectionViewReorderableTripletLayout.h"
#import "XMNRotateScaleView.h"
#import "XZArrowView.h"
#import "UIView+Extension.h"
#import "MEUtils.h"

typedef NS_ENUM(NSInteger, RAScrollDirction) {
    RAScrollDirctionNone,
    RAScrollDirctionUp,
    RAScrollDirctionDown
};


@interface UIImageView (RACollectionViewReorderableTripletLayout)

- (void)setCellCopiedImage:(UICollectionViewCell *)cell;

@end

@implementation UIImageView (RACollectionViewReorderableTripletLayout)

- (void)setCellCopiedImage:(UICollectionViewCell *)cell {
    UIGraphicsBeginImageContextWithOptions(cell.bounds.size, NO, 4.f);
    [cell.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.image = image;
}

@end


@interface RACollectionViewReorderableTripletLayout()<XMNRotateScaleViewDelegate>

@property (nonatomic, strong) UIView *cellFakeView;
@property (nonatomic, strong) XMNRotateScaleView *rotateCellFakeView;
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, assign) RAScrollDirction scrollDirection;
@property (nonatomic, strong) NSIndexPath *reorderingCellIndexPath;
@property (nonatomic, assign) CGPoint reorderingCellCenter;
@property (nonatomic, assign) CGPoint cellFakeViewCenter;
@property (nonatomic, assign) CGPoint panTranslation;
@property (nonatomic, assign) UIEdgeInsets scrollTrigerEdgeInsets;
@property (nonatomic, assign) UIEdgeInsets scrollTrigePadding;
@property (nonatomic, assign) BOOL setUped;
@property (nonatomic, strong) XZArrowView *muneView;
@property (nonatomic, strong) UITextView *textViewCell;
@property (nonatomic, strong) NSIndexPath *muneIndex;

@end

@implementation RACollectionViewReorderableTripletLayout

#pragma mark - 移除这两个控件（复制层）
- (void)removeAndNilCellFakeView {
    if (_rotateCellFakeView) {
        [_rotateCellFakeView removeFromSuperview];
        _rotateCellFakeView = nil;
    }
    if (_muneView) {
        [_muneView removeFromSuperview];
        _muneView = nil;
    }
}

#pragma mark - Override methods

- (void)setDelegate:(id<RACollectionViewDelegateReorderableTripletLayout>)delegate
{
    self.collectionView.delegate = delegate;
}

- (id<RACollectionViewDelegateReorderableTripletLayout>)delegate
{
    return (id<RACollectionViewDelegateReorderableTripletLayout>)self.collectionView.delegate;
}

- (void)setDatasource:(id<RACollectionViewReorderableTripletLayoutDataSource>)datasource
{
    self.collectionView.dataSource = datasource;
}

- (id<RACollectionViewReorderableTripletLayoutDataSource>)datasource
{
    return (id<RACollectionViewReorderableTripletLayoutDataSource>)self.collectionView.dataSource;
}

- (void)prepareLayout
{
    [super prepareLayout];
    //gesture
    [self setUpCollectionViewGesture];
    //scroll triger insets
    _scrollTrigerEdgeInsets = UIEdgeInsetsMake(50.f, 50.f, 50.f, 50.f);
    if ([self.delegate respondsToSelector:@selector(autoScrollTrigerEdgeInsets:)]) {
        _scrollTrigerEdgeInsets = [self.delegate autoScrollTrigerEdgeInsets:self.collectionView];
    }
    //scroll triger padding
    _scrollTrigePadding = UIEdgeInsetsMake(0, 0, 0, 0);
    if ([self.delegate respondsToSelector:@selector(autoScrollTrigerPadding:)]) {
        _scrollTrigePadding = [self.delegate autoScrollTrigerPadding:self.collectionView];
    }
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attribute = [super layoutAttributesForItemAtIndexPath:indexPath];
    if (attribute.representedElementCategory == UICollectionElementCategoryCell) {
        if ([attribute.indexPath isEqual:_reorderingCellIndexPath]) {
            CGFloat alpha = 0;
            if ([self.delegate respondsToSelector:@selector(reorderingItemAlpha:)]) {
                alpha = [self.delegate reorderingItemAlpha:self.collectionView];
                if (alpha >= 1.f) {
                    alpha = 1.f;
                }else if (alpha <= 0) {
                    alpha = 0;
                }
            }
            attribute.alpha = alpha;
        }
    }
    return attribute;
}

#pragma mark - Methods

- (void)setUpCollectionViewGesture
{
    if (!_setUped) {
        _longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapguesture:)];
        _longPressGesture.delegate = self;
        _panGesture.delegate = self;
        
        for (UIGestureRecognizer *gestureRecognizer in self.collectionView.gestureRecognizers) {
//            DLog(@"111 = %@", gestureRecognizer);
            if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]]) {
                [gestureRecognizer requireGestureRecognizerToFail:_longPressGesture];
            }
        }

        [self.collectionView addGestureRecognizer:_longPressGesture];
        [self.collectionView addGestureRecognizer:_panGesture];
        [self.collectionView addGestureRecognizer:_tapGesture];
        _setUped = YES;
    }
}

- (void)setUpDisplayLink
{
    if (_displayLink) {
        return;
    }
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(autoScroll)];
    [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

-  (void)invalidateDisplayLink
{
    [_displayLink invalidate];
    _displayLink = nil;
}

- (void)autoScroll
{
    CGPoint contentOffset = self.collectionView.contentOffset;
    UIEdgeInsets contentInset = self.collectionView.contentInset;
    CGSize contentSize = self.collectionView.contentSize;
    CGSize boundsSize = self.collectionView.bounds.size;
    CGFloat increment = 0;
    
    if (self.scrollDirection == RAScrollDirctionDown) {
        CGFloat percentage = (((CGRectGetMaxY(_cellFakeView.frame) - contentOffset.y) - (boundsSize.height - _scrollTrigerEdgeInsets.bottom - _scrollTrigePadding.bottom)) / _scrollTrigerEdgeInsets.bottom);
        increment = 10 * percentage;
        if (increment >= 10.f) {
            increment = 10.f;
        }
    }else if (self.scrollDirection == RAScrollDirctionUp) {
        CGFloat percentage = (1.f - ((CGRectGetMinY(_cellFakeView.frame) - contentOffset.y - _scrollTrigePadding.top) / _scrollTrigerEdgeInsets.top));
        increment = -10.f * percentage;
        if (increment <= -10.f) {
            increment = -10.f;
        }
    }
    
    if (contentOffset.y + increment <= -contentInset.top) {
        [UIView animateWithDuration:.07f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            CGFloat diff = -contentInset.top - contentOffset.y;
            self.collectionView.contentOffset = CGPointMake(contentOffset.x, -contentInset.top);
            _cellFakeViewCenter = CGPointMake(_cellFakeViewCenter.x, _cellFakeViewCenter.y + diff);
            _cellFakeView.center = CGPointMake(_cellFakeViewCenter.x + _panTranslation.x, _cellFakeViewCenter.y + _panTranslation.y);
        } completion:nil];
        [self invalidateDisplayLink];
        return;
    }else if (contentOffset.y + increment >= contentSize.height - boundsSize.height - contentInset.bottom) {
        [UIView animateWithDuration:.07f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            CGFloat diff = contentSize.height - boundsSize.height - contentInset.bottom - contentOffset.y;
            self.collectionView.contentOffset = CGPointMake(contentOffset.x, contentSize.height - boundsSize.height - contentInset.bottom);
            _cellFakeViewCenter = CGPointMake(_cellFakeViewCenter.x, _cellFakeViewCenter.y + diff);
            _cellFakeView.center = CGPointMake(_cellFakeViewCenter.x + _panTranslation.x, _cellFakeViewCenter.y + _panTranslation.y);
        } completion:nil];
        [self invalidateDisplayLink];
        return;
    }
    
    [self.collectionView performBatchUpdates:^{
        _cellFakeViewCenter = CGPointMake(_cellFakeViewCenter.x, _cellFakeViewCenter.y + increment);
        _cellFakeView.center = CGPointMake(_cellFakeViewCenter.x + _panTranslation.x, _cellFakeViewCenter.y + _panTranslation.y);
        self.collectionView.contentOffset = CGPointMake(contentOffset.x, contentOffset.y + increment);
    } completion:nil];
    [self moveItemIfNeeded];
}
#pragma mark - 长按手势
- (void)handleLongPressGesture:(UILongPressGestureRecognizer *)longPress {
    
    if (self.datasource && [self.datasource respondsToSelector:@selector(canMoveCollectionView:)]) {
        if (![self.datasource canMoveCollectionView:self.collectionView]) {
            return;
        }
    }
    
    switch (longPress.state) {
        case UIGestureRecognizerStateBegan: {
            
            [self removeAndNilCellFakeView];
            
            //indexPath
            NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:[longPress locationInView:self.collectionView]];
            //can move
            if ([self.datasource respondsToSelector:@selector(collectionView:canMoveItemAtIndexPath:)]) {
                if (![self.datasource collectionView:self.collectionView canMoveItemAtIndexPath:indexPath]) {

                    return;
                }
            }
            //will begin dragging
            if ([self.delegate respondsToSelector:@selector(collectionView:layout:willBeginDraggingItemAtIndexPath:)]) {
                [self.delegate collectionView:self.collectionView layout:self willBeginDraggingItemAtIndexPath:indexPath];
            }
            
            //indexPath
            _reorderingCellIndexPath = indexPath;
            //scrolls top off
            self.collectionView.scrollsToTop = NO;
            //cell fake view
            UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
            

//            if ([UIMenuController sharedMenuController]) {
//                [UIMenuController sharedMenuController].menuVisible = YES;
//            }
            
            _cellFakeView = [[UIView alloc] initWithFrame:cell.frame];
            _cellFakeView.layer.shadowColor = [UIColor blackColor].CGColor;
            _cellFakeView.layer.shadowOffset = CGSizeMake(0, 0);
            _cellFakeView.layer.shadowOpacity = .5f;
            _cellFakeView.layer.shadowRadius = 3.f;
            UIImageView *cellFakeImageView = [[UIImageView alloc] initWithFrame:cell.bounds];
            UIImageView *highlightedImageView = [[UIImageView alloc] initWithFrame:cell.bounds];
            cellFakeImageView.contentMode = UIViewContentModeScaleAspectFill;
            highlightedImageView.contentMode = UIViewContentModeScaleAspectFill;
            cellFakeImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
            highlightedImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
            cell.highlighted = YES;
            [highlightedImageView setCellCopiedImage:cell];
            cell.highlighted = NO;
            [cellFakeImageView setCellCopiedImage:cell];
            [self.collectionView addSubview:_cellFakeView];
            [_cellFakeView addSubview:cellFakeImageView];
            [_cellFakeView addSubview:highlightedImageView];
            //set center
            _reorderingCellCenter = cell.center;
            _cellFakeViewCenter = _cellFakeView.center;
            [self invalidateLayout];
            //animation
            //            CGRect fakeViewRect = CGRectMake(cell.center.x - (self.smallCellSize.width / 2.f), cell.center.y - (self.smallCellSize.height / 2.f), self.smallCellSize.width, self.smallCellSize.height);
            CGRect fakeViewRect = cell.frame;
            [UIView animateWithDuration:.3f delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
                _cellFakeView.center = cell.center;
                _cellFakeView.frame = fakeViewRect;
                _cellFakeView.alpha = 0.3f;
                _cellFakeView.transform = CGAffineTransformMakeScale(1.1f, 1.1f);
                highlightedImageView.alpha = 0;
            } completion:^(BOOL finished) {
                [highlightedImageView removeFromSuperview];
            }];
            //did begin dragging
            if ([self.delegate respondsToSelector:@selector(collectionView:layout:didBeginDraggingItemAtIndexPath:)]) {
                [self.delegate collectionView:self.collectionView layout:self didBeginDraggingItemAtIndexPath:indexPath];
            }
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            NSIndexPath *currentCellIndexPath = _reorderingCellIndexPath;
            
            //will end dragging
            if ([self.delegate respondsToSelector:@selector(collectionView:layout:willEndDraggingItemAtIndexPath:)]) {
                [self.delegate collectionView:self.collectionView layout:self willEndDraggingItemAtIndexPath:currentCellIndexPath];
            }
            
            //scrolls top on
            self.collectionView.scrollsToTop = YES;
            //disable auto scroll
            [self invalidateDisplayLink];
            //remove fake view
            
            //            UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:currentCellIndexPath.item inSection:currentCellIndexPath.section]];
            
            UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:currentCellIndexPath];
            
            //            NSLog(@"currentCellIndexPath = %@\nattributes = %@\ncell.frmae = %@",currentCellIndexPath,NSStringFromCGRect(attributes.frame),NSStringFromCGRect(cell.frame));
            
            [UIView animateWithDuration:.3f delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
                _cellFakeView.transform = CGAffineTransformIdentity;
                _cellFakeView.frame = cell.frame;
            } completion:^(BOOL finished) {
                [_cellFakeView removeFromSuperview];
                _cellFakeView = nil;
                _reorderingCellIndexPath = nil;
                _reorderingCellCenter = CGPointZero;
                _cellFakeViewCenter = CGPointZero;
                [self invalidateLayout];
                if (finished) {
                    //did end dragging
                    if ([self.delegate respondsToSelector:@selector(collectionView:layout:didEndDraggingItemAtIndexPath:)]) {
                        [self.delegate collectionView:self.collectionView layout:self didEndDraggingItemAtIndexPath:currentCellIndexPath];
                    }
                }
            }];
            break;
        }
        default:
            break;
    }
}
#pragma mark - 拖动手势
- (void)handlePanGesture:(UIPanGestureRecognizer *)pan
{
    switch (pan.state) {
        case UIGestureRecognizerStateChanged: {
            //translation
            _panTranslation = [pan translationInView:self.collectionView];
            _cellFakeView.center = CGPointMake(_cellFakeViewCenter.x + _panTranslation.x, _cellFakeViewCenter.y + _panTranslation.y);
            //move layout
            [self moveItemIfNeeded];
            //scroll
            if (CGRectGetMaxY(_cellFakeView.frame) >= self.collectionView.contentOffset.y + (self.collectionView.bounds.size.height - _scrollTrigerEdgeInsets.bottom -_scrollTrigePadding.bottom)) {
                if (ceilf(self.collectionView.contentOffset.y) < self.collectionView.contentSize.height - self.collectionView.bounds.size.height) {
                    self.scrollDirection = RAScrollDirctionDown;
                    [self setUpDisplayLink];
                }
            }else if (CGRectGetMinY(_cellFakeView.frame) <= self.collectionView.contentOffset.y + _scrollTrigerEdgeInsets.top + _scrollTrigePadding.top) {
                if (self.collectionView.contentOffset.y > -self.collectionView.contentInset.top) {
                    self.scrollDirection = RAScrollDirctionUp;
                    [self setUpDisplayLink];
                }
            }else {
                self.scrollDirection = RAScrollDirctionNone;
                [self invalidateDisplayLink];
            }
            break;
        }
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
            [self invalidateDisplayLink];
            break;
            
        default:
            break;
    }
}
#pragma mark - 移动cell
- (void)moveItemIfNeeded
{
    NSIndexPath *atIndexPath = _reorderingCellIndexPath;
    NSIndexPath *toIndexPath = [self.collectionView indexPathForItemAtPoint:_cellFakeView.center];
    
    if (toIndexPath == nil || [atIndexPath isEqual:toIndexPath]) {
        return;
    }
    //can move
    if ([self.datasource respondsToSelector:@selector(collectionView:itemAtIndexPath:canMoveToIndexPath:)]) {
        if (![self.datasource collectionView:self.collectionView itemAtIndexPath:atIndexPath canMoveToIndexPath:toIndexPath]) {
            return;
        }
    }
    
    //will move
    if ([self.datasource respondsToSelector:@selector(collectionView:itemAtIndexPath:willMoveToIndexPath:)]) {
        [self.datasource collectionView:self.collectionView itemAtIndexPath:atIndexPath willMoveToIndexPath:toIndexPath];
    }
    
    //move
    [self.collectionView performBatchUpdates:^{
        //update cell indexPath
        _reorderingCellIndexPath = toIndexPath;
        [self.collectionView moveItemAtIndexPath:atIndexPath toIndexPath:toIndexPath];
        //did move
        if ([self.datasource respondsToSelector:@selector(collectionView:itemAtIndexPath:didMoveToIndexPath:)]) {
            [self.datasource collectionView:self.collectionView itemAtIndexPath:atIndexPath didMoveToIndexPath:toIndexPath];
        }
    } completion:nil];
}
#pragma mark - 点击手势
- (void)handleTapguesture:(UITapGestureRecognizer *)tap {
    
    [self removeAndNilCellFakeView];
    
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:[tap locationInView:self.collectionView]];
    
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
    //    NSLog(@"cell.tag = %zd",cell.tag);
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(customCollectionView:didSeleted:)]) {
        [self.delegate customCollectionView:self.collectionView didSeleted:indexPath];
    }
    
    if (self.collectionView.tag == -1) {
        return;
    }
    
    XZMuneType muneType;
    
    if (cell.tag == 888) {
        
        muneType = XZMuneTypeImage;
        
        if (!_rotateCellFakeView) {
            
            _rotateCellFakeView = [[XMNRotateScaleView alloc] initWithFrame:cell.frame muneType:muneType];
            _rotateCellFakeView.delegate = self;
            _rotateCellFakeView.tag = indexPath.item;
            
            //    _rotateCellFakeView.backgroundColor = [UIColor blackColor];
            //    NSLog(@"\nindexPath = %@\ncell = %@ \n_rotateCellFakeView = %@",indexPath,cell,_rotateCellFakeView);
            
            UIImageView *cellFakeImageView = [[UIImageView alloc] initWithFrame:cell.bounds];
            
            cellFakeImageView.contentMode = UIViewContentModeScaleAspectFill;
            cellFakeImageView.clipsToBounds = YES;
            cellFakeImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
            
            cell.highlighted = YES;
            
            cell.highlighted = NO;
            
            [cellFakeImageView setCellCopiedImage:cell];
            
            //    _rotateCellFakeView.contentView = cellFakeImageView;
            
            [self.collectionView addSubview:_rotateCellFakeView];
        }
        
    } else {
        
        muneType = XZMuneTypeText;
        
        
    }
    
    _muneIndex = indexPath;
    
    int btnNum;
    if (muneType == XZMuneTypeImage) {
        btnNum = 2;
    } else {
        btnNum = 3;
    }
    
    
    if (!_muneView) {
        CGFloat muneH = 60.f;
        CGFloat muneW = muneH * 2;
        CGFloat muneX = ([UIScreen mainScreen].bounds.size.width - muneW)/2;
        _muneView = [[XZArrowView alloc]initWithFrame:CGRectMake(muneX, cell.frame.origin.y - muneH + 4.f, muneW, muneH)];
        [_muneView setArrowTextHidden];
        _muneView.layer.shadowColor = [UIColor blackColor].CGColor;
        _muneView.layer.shadowOffset = CGSizeMake(0, 0);
        _muneView.layer.shadowOpacity = .5f;
        _muneView.layer.shadowRadius = 3.f;
        [self.collectionView addSubview:_muneView];
        
        //为了减少全局变量，只好这样用tag来传值
        NSInteger largeBtnNum = btnNum * 10;
        CGFloat lineHeight = _muneView.h/2 - 8.f;
        [UIView viewWithFrame:CGRectMake(_muneView.w/2, 16.f, 1.f, lineHeight) color:[UIColor whiteColor] contentView:_muneView];
        [self allocMyButton:0 width:muneH to:_muneView tag:1 + largeBtnNum];
        [self allocMyButton:muneH width:muneH to:_muneView tag:2 + largeBtnNum];
    }
    
    
}
#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([_panGesture isEqual:gestureRecognizer]) {
        if (_longPressGesture.state == 0 || _longPressGesture.state == 5) {
            return NO;
        }
    }else if ([_longPressGesture isEqual:gestureRecognizer]) {
        if (self.collectionView.panGestureRecognizer.state != 0 && self.collectionView.panGestureRecognizer.state != 5) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ([_panGesture isEqual:gestureRecognizer]) {
        if (_longPressGesture.state != 0 && _longPressGesture.state != 5) {
            if ([_longPressGesture isEqual:otherGestureRecognizer]) {
                return YES;
            }
            return NO;
        }
    }else if ([_longPressGesture isEqual:gestureRecognizer]) {
        if ([_panGesture isEqual:otherGestureRecognizer]) {
            return YES;
        }
    }else if ([self.collectionView.panGestureRecognizer isEqual:gestureRecognizer]) {
        if (_longPressGesture.state == 0 || _longPressGesture.state == 5) {
            return NO;
        }
    }
    return YES;
}
#pragma mark - XMNRotateScaleView代理
-(void)rotateScaleViewDidRotateAndScale:(XMNRotateScaleView *)rotateScaleView {
    NSLog(@"在放大 == %@",rotateScaleView);
    NSInteger viewTag = rotateScaleView.tag;
    CGSize cellSize = [[self.allCellSizeArr objectAtIndex:viewTag]CGSizeValue];
    cellSize.height = rotateScaleView.frame.size.height;
    
    [self.allCellSizeArr replaceObjectAtIndex:viewTag withObject:[NSValue valueWithCGSize:cellSize]];
    
    //    [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:rotateScaleView.tag inSection:0]]];
    
    [self.collectionView reloadData];
//    [self invalidateLayout];
}
-(void)rotateScaleViewEndRotateAndScale:(XMNRotateScaleView *)rotateScaleView {
    NSLog(@"结束放大 == %zd",rotateScaleView.tag);
    //    [rotateScaleView removeFromSuperview];
    //    rotateScaleView = nil;
}
#pragma mark 菜单按钮
- (UIButton *)allocMyButton:(CGFloat)xx width:(CGFloat)width to:(UIView *)view tag:(NSInteger)tag{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    width -= 20;
    btn.frame = CGRectMake(xx + 10, 6, width, width);
    [btn addTarget:self action:@selector(muneButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    btn.tag = tag;
    NSString *imageName = @"";
    if (tag == 21) {
        imageName = @"post09_icon_a.png";
    } else if (tag == 22) {
        imageName = @"post05_icon_c.png";
    } else if (tag == 31) {
        imageName = @"post05_icon_a.png";
    } else {
        imageName = @"post05_icon_c.png";
    }
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    return btn;
}
- (void)muneButtonClick:(UIButton *)button {
    //    NSLog(@"%zd",button.tag);
    //    NSLog(@"%@",_muneIndex);
    NSInteger btnTag = button.tag;
    if (btnTag == 21) {//20开头是图片cell
        //换图
        if (self.delegate && [self.delegate respondsToSelector:@selector(customCollectionView:changeImage:)]) {
            [self.delegate customCollectionView:self.collectionView changeImage:_muneIndex];
        }
    } else if (btnTag == 22) {
        //删除
        if (self.delegate && [self.delegate respondsToSelector:@selector(customCollectionView:deleteCell:)]) {
            [self.delegate customCollectionView:self.collectionView deleteCell:_muneIndex];
            [self removeAndNilCellFakeView];
        }
    } else if (btnTag == 31) {//30开头是textCell
        //编辑
        if (self.delegate && [self.delegate respondsToSelector:@selector(customCollectionView:editText:)]) {
            [self.delegate customCollectionView:self.collectionView editText:_muneIndex];
            [self removeAndNilCellFakeView];
        }
    } else {
        //删除
        if (self.delegate && [self.delegate respondsToSelector:@selector(customCollectionView:deleteCell:)]) {
            [self.delegate customCollectionView:self.collectionView deleteCell:_muneIndex];
            [self removeAndNilCellFakeView];
        }
    }
}
@end
