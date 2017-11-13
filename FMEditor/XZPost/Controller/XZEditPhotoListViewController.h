//
//  DPPhotoListViewController.h
//  DPPictureSelector
//
//  Created by boombox on 15/9/1.
//  Copyright (c) 2015年 lidaipeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPPhotoGroupViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
@class XZEditPhotoListViewController;

@protocol XZEditPhotoListDelegate <NSObject>

@optional
/**
 *  选择完图片回调
 */
- (void)addEditSelectPhotos:(NSMutableArray *)photos;

@end

@interface DPPhotoListCell : UICollectionViewCell

@property (strong, nonatomic) UIImageView *imageView;
@property (assign, nonatomic) BOOL isChoose;/**< 是否已选择 */
- (void)setNumberStr:(NSString *)btnNumStr;
- (void)setNumber:(NSInteger)btnNum;
@end

@interface XZEditPhotoListViewController : UIViewController

@property (strong, nonatomic) ALAssetsGroup *group;/**< 相薄 */
@property (assign, nonatomic) NSInteger seletedCount;/**< 已经选择的照片数 */
@property (assign, nonatomic) NSInteger maxSelectionCount;/**< 最多选择图片张数 */
@property (strong, nonatomic) id<XZEditPhotoListDelegate>delegate;

@end
