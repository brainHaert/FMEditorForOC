//
//  RACollectionViewTripletLayout.m
//  RACollectionViewTripletLayout-Demo
//
//  Created by Ryo Aoyama on 5/25/14.
//  Copyright (c) 2014 Ryo Aoyama. All rights reserved.
//
#define CellHeightPart 2
///在发布页面用到的头部高度
#define HEADERHEIGHT 80.f

#import "RACollectionViewTripletLayout.h"

@interface RACollectionViewTripletLayout()

@property (nonatomic, assign) NSInteger numberOfCells;
@property (nonatomic, assign) CGFloat numberOfLines;
@property (nonatomic, assign) CGFloat itemSpacing;
@property (nonatomic, assign) CGFloat lineSpacing;
@property (nonatomic, assign) CGFloat sectionSpacing;
@property (nonatomic, assign) CGSize collectionViewSize;
@property (nonatomic, assign) UIEdgeInsets insets;
@property (nonatomic, assign) CGRect oldRect;
@property (nonatomic, strong) NSArray *oldArray;

@property(nonatomic,assign)CGFloat lastMaxX;
@property(nonatomic,assign)CGFloat lastY;
@property(nonatomic,assign)CGFloat lastMaxY;
@property(nonatomic,assign)NSInteger lineCount;
@property(nonatomic,assign)CGFloat lastHeight;

@end

@implementation RACollectionViewTripletLayout

#pragma mark - Over ride flow layout methods

- (void)prepareLayout
{
    [super prepareLayout];
    
    //collection view size
    _collectionViewSize = self.collectionView.bounds.size;
    
    //some values
    _itemSpacing = 0;
    _lineSpacing = 0;
    _sectionSpacing = 0;
    _insets = UIEdgeInsetsMake(0, 0, 0, 0);
    if ([self.delegate respondsToSelector:@selector(minimumInteritemSpacingForCollectionView:)]) {
        _itemSpacing = [self.delegate minimumInteritemSpacingForCollectionView:self.collectionView];
    }
    if ([self.delegate respondsToSelector:@selector(minimumLineSpacingForCollectionView:)]) {
        _lineSpacing = [self.delegate minimumLineSpacingForCollectionView:self.collectionView];
    }
    if ([self.delegate respondsToSelector:@selector(sectionSpacingForCollectionView:)]) {
        _sectionSpacing = [self.delegate sectionSpacingForCollectionView:self.collectionView];
    }
    if ([self.delegate respondsToSelector:@selector(insetsForCollectionView:)]) {
        _insets = [self.delegate insetsForCollectionView:self.collectionView];
    }
    
    
}

- (CGFloat)contentHeight
{
    CGFloat contentHeight = 0;
    NSInteger numberOfSections = self.collectionView.numberOfSections;
    CGSize collectionViewSize = self.collectionView.bounds.size;
    
    UIEdgeInsets insets = UIEdgeInsetsZero;
    if ([self.delegate respondsToSelector:@selector(insetsForCollectionView:)]) {
        insets = [self.delegate insetsForCollectionView:self.collectionView];
    }
    CGFloat sectionSpacing = 0;
    if ([self.delegate respondsToSelector:@selector(sectionSpacingForCollectionView:)]) {
        sectionSpacing = [self.delegate sectionSpacingForCollectionView:self.collectionView];
    }
    
    CGFloat itemSpacing = 0;
    if ([self.delegate respondsToSelector:@selector(minimumInteritemSpacingForCollectionView:)]) {
        itemSpacing = [self.delegate minimumInteritemSpacingForCollectionView:self.collectionView];
    }
    
    CGFloat lineSpacing = 0;
    if ([self.delegate respondsToSelector:@selector(minimumLineSpacingForCollectionView:)]) {
       lineSpacing = [self.delegate minimumLineSpacingForCollectionView:self.collectionView];
    }
    
    contentHeight += insets.top + insets.bottom + sectionSpacing * (numberOfSections - 1);
    
    CGFloat lastSmallCellHeight = 0;
    for (NSInteger i = 0; i < numberOfSections; i++) {
        NSInteger numberOfLines = ceil((CGFloat)[self.collectionView numberOfItemsInSection:i] / 3.f);
        
        //cellsize的宽或高
        CGFloat largeCellSideLength = (2.f * (collectionViewSize.width - insets.left - insets.right) - itemSpacing) / 3.f;
        CGFloat smallCellSideLength = (largeCellSideLength - itemSpacing) / 2.f;
        //cellsize
        CGSize largeCellSize = CGSizeMake(largeCellSideLength, largeCellSideLength);
        CGSize smallCellSize = CGSizeMake(smallCellSideLength, smallCellSideLength);
        
        //如果用了代理来设置大cell的size，就重新计算
        if ([self.delegate respondsToSelector:@selector(collectionView:sizeForLargeItemsInSection:)]) {
            if (!CGSizeEqualToSize([self.delegate collectionView:self.collectionView sizeForLargeItemsInSection:i], RACollectionViewTripletLayoutStyleSquare)) {
                largeCellSize = [self.delegate collectionView:self.collectionView sizeForLargeItemsInSection:i];
                smallCellSize = CGSizeMake(collectionViewSize.width - largeCellSize.width - itemSpacing - insets.left - insets.right, (largeCellSize.height / 2.f) - (itemSpacing / 2.f));
            }
        }
        
        lastSmallCellHeight = smallCellSize.height;
        CGFloat largeCellHeight = largeCellSize.height;
        CGFloat lineHeight = numberOfLines * (largeCellHeight + lineSpacing) - lineSpacing;
        contentHeight += lineHeight;
    }
    
    NSInteger numberOfItemsInLastSection = [self.collectionView numberOfItemsInSection:numberOfSections -1];
    if ((numberOfItemsInLastSection - 1) % 3 == 0 && (numberOfItemsInLastSection - 1) % 6 != 0) {
        contentHeight -= lastSmallCellHeight + itemSpacing;
    }
    
    return contentHeight + HEADERHEIGHT;
}

- (void)setDelegate:(id<RACollectionViewDelegateTripletLayout>)delegate
{
    self.collectionView.delegate = delegate;
}

- (id<RACollectionViewDelegateTripletLayout>)delegate
{
    return (id<RACollectionViewDelegateTripletLayout>)self.collectionView.delegate;
}
#pragma mark collectionView的内容大小
- (CGSize)collectionViewContentSize {
    
    CGSize contentSize = CGSizeMake(_collectionViewSize.width, 0);
    
    if (self.allCellSizeArr.count) {
        
//        CGRect cellRect = [[self.allCellFrameArr lastObject]CGRectValue];
//        contentSize.height += cellRect.origin.y + cellRect.size.height + 64 + _insets.bottom;
        for (int iii = 0; iii < self.allCellSizeArr.count; iii ++) {
            CGFloat cellHeight = [[self.allCellSizeArr objectAtIndex:iii]CGSizeValue].height;
            contentSize.height += _lineSpacing + cellHeight;
        }
        
    } else {
        
        CGFloat cellWidth = [UIScreen mainScreen].bounds.size.width - _insets.left - _insets.right;
        CGFloat cellHeight = cellWidth/CellHeightPart;
        NSInteger numberOfItemsInLastSection = [self.collectionView numberOfItemsInSection:0];
        CGFloat contetHeight = (cellHeight + _lineSpacing) * numberOfItemsInLastSection;
        contentSize.height += contetHeight;// + HEADERHEIGHT + 64
    }
    
    contentSize.height += HEADERHEIGHT + 64 + _insets.bottom + _insets.top;
    return contentSize;
}
#pragma mark 不知道是啥大小
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    _oldRect = rect;
    NSMutableArray *attributesArray = [NSMutableArray array];
    for (NSInteger i = 0; i < self.collectionView.numberOfSections; i++) {
        NSInteger numberOfCellsInSection = [self.collectionView numberOfItemsInSection:i];
        for (NSInteger j = 0; j < numberOfCellsInSection; j++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:j inSection:i];
            UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
            if (CGRectIntersectsRect(rect, attributes.frame)) {
                [attributesArray addObject:attributes];
            }
        }
    }
    _oldArray = attributesArray;
    return  attributesArray;
}
#pragma mark cell size
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];

    if (self.allCellSizeArr.count > indexPath.item) {//有值的时候
        
        if (indexPath.item == 0) {
            self.lastHeight = 0;
            self.lastMaxY = HEADERHEIGHT + _insets.top;
        }
//        NSLog(@"有值-=== %@",[self.allCellSizeArr objectAtIndex:indexPath.item]);
        CGSize cellSize = [[self.allCellSizeArr objectAtIndex:indexPath.item] CGSizeValue];
        
//        CGFloat cellY = (self.lastHeight + _lineSpacing) * indexPath.item + HEADERHEIGHT;
        CGFloat cellY = self.lastMaxY + _lineSpacing;
        
        attribute.frame = CGRectMake(_insets.left, cellY, cellSize.width, cellSize.height);
//        NSLog(@"计算位置 = %@,item = %zd",NSStringFromCGRect(attribute.frame),indexPath.item);
        
        self.lastHeight = attribute.frame.size.height;
        self.lastMaxY = attribute.frame.origin.y + attribute.frame.size.height;
        
        return attribute;
        
    } else {//没有值的时候
        
//        NSLog(@"额米有值");
        
        //cellsize的宽或高
        CGFloat largeCellSideLength = [UIScreen mainScreen].bounds.size.width - _insets.left - _insets.right;
        CGFloat smallCellSideLength = (largeCellSideLength - _itemSpacing) / 2.f;
        
        //cellSize
        _largeCellSize = CGSizeMake(largeCellSideLength, largeCellSideLength/CellHeightPart);
        _smallCellSize = CGSizeMake(smallCellSideLength, smallCellSideLength);
        
        if ([self.delegate respondsToSelector:@selector(collectionView:sizeForLargeItemsInSection:)]) {
            if (!CGSizeEqualToSize([self.delegate collectionView:self.collectionView sizeForLargeItemsInSection:indexPath.section], RACollectionViewTripletLayoutStyleSquare)) {
                _largeCellSize = [self.delegate collectionView:self.collectionView sizeForLargeItemsInSection:indexPath.section];
                _smallCellSize = CGSizeMake(_collectionViewSize.width - _largeCellSize.width - _itemSpacing - _insets.left - _insets.right, (_largeCellSize.height / 2.f) - (_itemSpacing / 2.f));
            }
        }
        
        if (!_largeCellSizeArray) {
            _largeCellSizeArray = [NSMutableArray array];
        }
        
        if (!_smallCellSizeArray) {
            _smallCellSizeArray = [NSMutableArray array];
        }
        
        _largeCellSizeArray[indexPath.section] = [NSValue valueWithCGSize:_largeCellSize];
        _smallCellSizeArray[indexPath.section] = [NSValue valueWithCGSize:_smallCellSize];
        
        //section height
        CGFloat sectionHeight = 0;
        for (NSInteger i = 0; i <= indexPath.section - 1; i++) {
            NSInteger cellsCount = [self.collectionView numberOfItemsInSection:i];
            CGFloat largeCellHeight = [_largeCellSizeArray[i] CGSizeValue].height;
            CGFloat smallCellHeight = [_smallCellSizeArray[i] CGSizeValue].height;
            NSInteger lines = ceil((CGFloat)cellsCount / 3.f);
            sectionHeight += lines * (_lineSpacing + largeCellHeight) + _sectionSpacing;
            if ((cellsCount - 1) % 3 == 0 && (cellsCount - 1) % 6 != 0) {
                sectionHeight -= smallCellHeight + _itemSpacing;
            }
        }
        
        if (sectionHeight > 0) {
            sectionHeight -= _lineSpacing;
        }
        
        NSInteger line = indexPath.item;
        CGFloat lineOriginY = (_largeCellSize.height + _lineSpacing) * line + _insets.top + HEADERHEIGHT + _lineSpacing;
        
        attribute.frame = CGRectMake(_insets.left, lineOriginY, _largeCellSize.width, _largeCellSize.height);
        
        [self.allCellSizeArr addObject:[NSValue valueWithCGSize:attribute.frame.size]];
        [self.allCellFrameArr addObject:[NSValue valueWithCGRect:attribute.frame]];
        
        return attribute;
    }
    
}

#pragma mark 头
-(UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:indexPath];
    attribute.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, HEADERHEIGHT);
//    attribute.frame.size = CGSizeMake([UIScreen mainScreen].bounds.size.width, 100);
    return attribute;
}
#pragma mark 初始化array
-(NSMutableArray *)allCellSizeArr {
    if (!_allCellSizeArr) {
        _allCellSizeArr = [NSMutableArray array];
    }
    return _allCellSizeArr;
}
-(NSMutableArray *)allCellFrameArr {
    if (!_allCellFrameArr) {
        _allCellFrameArr = [NSMutableArray array];
    }
    return _allCellFrameArr;
}
@end
