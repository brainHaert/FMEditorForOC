//
//  XZFashionLayout.m
//  FMB
//
//  Created by admin on 16/3/29.
//  Copyright © 2016年 ICompany. All rights reserved.
//
#define CellHeightPart 2

#import "XZFashionLayout.h"

@implementation XZFashionLayout
{
    CGFloat _lastY;
    CGFloat _lastMaxY;
    CGFloat _lastHeight;
    CGFloat _moreHerderHeight;
    CGFloat _footerHeight;
}

- (void)prepareLayout {
    [super prepareLayout];
//    NSLog(@"self.allCellSizeArr = %@", self.allCellSizeArr);
//    NSLog(@"self.sectionInset = %@", NSStringFromUIEdgeInsets(self.sectionInset));
    _moreHerderHeight = 0;
    if (self.fashionLayoutDelegate && [self.fashionLayoutDelegate respondsToSelector:@selector(moreHeightForCollectionView:)]) {
        _moreHerderHeight = [self.fashionLayoutDelegate moreHeightForCollectionView:self.collectionView];
    }
    _footerHeight = 0;
    if (self.fashionLayoutDelegate && [self.fashionLayoutDelegate respondsToSelector:@selector(footerHeightForCollectionView:)]) {
        _footerHeight = [self.fashionLayoutDelegate footerHeightForCollectionView:self.collectionView];
    }
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    if (self.allCellSizeArr.count) {
        CGSize cellSize = [[self.allCellSizeArr objectAtIndex:indexPath.item] CGSizeValue];
        if (indexPath.item == 0) {
            _lastHeight = 0;
            _lastMaxY = self.sectionInset.top + _moreHerderHeight;
        }
        CGFloat cellY = _lastMaxY + self.minimumLineSpacing;
        
        CGFloat cellWidth = SCREEN_WIDTH - self.sectionInset.left - self.sectionInset.right;
        CGFloat cellHeight = cellSize.height/cellSize.width * cellWidth;
        
        attribute.frame = CGRectMake(self.sectionInset.left, cellY, cellWidth, cellHeight);
        
        _lastHeight = attribute.frame.size.height;
        _lastMaxY = attribute.frame.origin.y + attribute.frame.size.height;
//        NSLog(@"1attribute = %@", NSStringFromCGRect(attribute.frame));
//        NSLog(@"后self.sectionInset = %@", NSStringFromUIEdgeInsets(self.sectionInset));
        return attribute;
    }
    
    //cellsize的宽或高
    CGFloat largeCellSideLength = [UIScreen mainScreen].bounds.size.width - self.sectionInset.left - self.sectionInset.right;
    
    //cellSize
    CGSize largeCellSize = CGSizeMake(largeCellSideLength, largeCellSideLength/CellHeightPart);
    
    NSInteger line = indexPath.item;
    CGFloat lineOriginY = (largeCellSize.height + self.minimumLineSpacing) * line + self.sectionInset.top + _moreHerderHeight + self.minimumLineSpacing;
    
    attribute.frame = CGRectMake(self.sectionInset.left, lineOriginY, largeCellSize.width, largeCellSize.height);
    NSLog(@"2attribute = %@", NSStringFromCGRect(attribute.frame));
    [self.allCellSizeArr addObject:[NSValue valueWithCGSize:attribute.frame.size]];
    
    return attribute;
}
#pragma mark 不知道是啥大小
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
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
    
    UICollectionViewLayoutAttributes *headerAttributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    [attributesArray addObject:headerAttributes];
    
    UICollectionViewLayoutAttributes *footerAttributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
//    NSLog(@"footerAttributes = %@", footerAttributes);
    [attributesArray addObject:footerAttributes];
    
    return  attributesArray;
}
- (CGSize)collectionViewContentSize {
    
    CGSize contentSize = CGSizeMake(self.collectionView.bounds.size.width, 0);
    
    if (self.allCellSizeArr.count) {
        
        for (int iii = 0; iii < self.allCellSizeArr.count; iii ++) {
            CGSize cellSize = [[self.allCellSizeArr objectAtIndex:iii] CGSizeValue];
            CGFloat cellWidth = SCREEN_WIDTH - self.sectionInset.left - self.sectionInset.right;
            CGFloat cellHeight = cellSize.height/cellSize.width * cellWidth;
            
            contentSize.height += self.minimumLineSpacing + cellHeight;
        }
        
    } else {
        
        CGFloat cellWidth = [UIScreen mainScreen].bounds.size.width - self.sectionInset.left - self.sectionInset.right;
        CGFloat cellHeight = cellWidth/CellHeightPart;
        NSInteger numberOfItemsInLastSection = [self.collectionView numberOfItemsInSection:0];
        CGFloat contetHeight = (cellHeight + self.minimumLineSpacing) * numberOfItemsInLastSection;
        contentSize.height += contetHeight;// + HEADERHEIGHT + 64
    }
    
    contentSize.height +=  64 + self.sectionInset.bottom + self.sectionInset.top + _moreHerderHeight + _footerHeight;
    return contentSize;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    
    if (elementKind == UICollectionElementKindSectionHeader) {
        
        UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:indexPath];
        
        attribute.frame = CGRectMake(0, 0, SCREEN_WIDTH, _moreHerderHeight);
        
        return attribute;
        
    }
    
    UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:indexPath];
    
    attribute.frame = CGRectMake(0, _lastMaxY + self.minimumLineSpacing, SCREEN_WIDTH, _footerHeight);
    
    return attribute;
    
}

#pragma mark 初始化array
-(NSMutableArray *)allCellSizeArr {
    if (!_allCellSizeArr) {
        _allCellSizeArr = [NSMutableArray array];
    }
    return _allCellSizeArr;
}
@end
