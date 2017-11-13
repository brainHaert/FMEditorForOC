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

typedef NS_ENUM(NSUInteger, XZSeletePhotoType) {
    XZAllSelete,/**< 选全部 */
    XZOneSelete,/**< 选一个 */
};

@class XZPostPhotoListViewController;

@protocol XZPostPhotoListViewControllerDelegate <NSObject>

@optional
/**
 *  选择完图片回调
 */
- (void)didSelectPhotos:(NSMutableArray *)photos;

@end

@protocol XZGetOnePhotoDelegate <NSObject>

@optional
/**
 *  选择完一张图片回调
 */
- (void)didSelectOnePhotos:(UIImage *)image item:(NSInteger)item;

@end

@interface XZPostPhotoListViewController : UIViewController

- (instancetype)initWithSeleteType:(XZSeletePhotoType)type;

@property (strong, nonatomic) ALAssetsGroup *group;/**< 相薄 */
@property (assign, nonatomic) NSInteger maxSelectionCount;/**< 最多选择图片张数 */
@property (strong, nonatomic) id<XZPostPhotoListViewControllerDelegate>delegate;
@property (strong, nonatomic) id<XZGetOnePhotoDelegate>oneDelegate;

@end
