//
//  XMNSizeView.h
//  XMNSizeTextExample
//
//  Created by shscce on 15/11/26.
//  Copyright © 2015年 xmfraker. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kXMNInset                   8
#define kXMNBorderInset             8
#define kXMNRotateScaleControlWidth 200
#define kXMNRotateScaleControlHeight 60
#define kXMNRotateScaleAlhpWidth 8

typedef NS_ENUM(NSUInteger, XMNRotateScaleViewState) {
    XMNRotateScaleViewStateNormal,
    XMNRotateScaleViewStateEditing,
};

typedef NS_ENUM(NSUInteger, XZMuneType) {
    XZMuneTypeImage,/**< 图片菜单的类型 */
    XZMuneTypeText,/**< 文字菜单的类型 */
};

@protocol XMNRotateScaleViewDelegate;
@interface XMNRotateScaleView : UIView

///初始化方法
- (instancetype)initWithFrame:(CGRect)frame muneType:(XZMuneType)muneType;

@property (nonatomic, weak) UIView *contentView; /**< 显示的具体内容view */
@property (nonatomic, weak) id<XMNRotateScaleViewDelegate> delegate;

@property (nonatomic, assign) CGSize minSize;/**< 最小的宽度 默认为CGSizeMake(76, 76)  */

@property (nonatomic, assign) CGSize maxSize;/**< 最大的宽度 屏幕宽  */

@property (nonatomic, strong) UIColor *borderColor; /**< 边框颜色,默认红色 */
@property (nonatomic, assign) CGFloat borderWidth; /**< 边框粗细,默认为1.0f */

@property (nonatomic, assign) XMNRotateScaleViewState state;

@property (nonatomic, assign) XZMuneType muneType;/**< 菜单的类型 */

@end


@protocol XMNRotateScaleViewDelegate <NSObject>

@optional
- (void)rotateScaleViewDidRotateAndScale:(XMNRotateScaleView *)rotateScaleView;
- (void)rotateScaleViewEndRotateAndScale:(XMNRotateScaleView *)rotateScaleView;

@end