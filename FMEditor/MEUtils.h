//
//  MEUtils.h
//  
//
//  Created by Vince on 15/11/24.
//
//
#define GRAYFONTCOLOR RGBCOLOR(138, 138, 138)
#define YELLOWFONTCOLOR RGBCOLOR(252, 200, 0)

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//#import "NSString+ThreeDES.h"
//@interface MEUtils : NSObject
//
//@end

@interface UIButton (Utils)
///设按钮图片按钮
+ (UIButton *)buttonImageName:(NSString *)image selectImageName:(NSString *)selImage frame:(CGRect)rect target:(id)target action:(SEL)action to:(UIView *)contentView;
+ (UIButton *)buttonWithImage:(UIImage *)image frame:(CGRect)rect target:(id)target action:(SEL)action contentView:(UIView *)contentView;
///（最简）纯文字按钮
+ (UIButton *)buttonWithTitle:(NSString *)title titleColor:(UIColor *)color target:(id)target action:(SEL)action to:(UIView *)contentView;


@end

@interface UILabel (Utils)

+(UILabel *)labelWithFrame:(CGRect)rect align:(NSTextAlignment)align font:(UIFont *)font color:(UIColor *)color text:(NSString *)text autoText:(BOOL)autotext contentView:(UIView *)contentView;
- (void)setAutoText:(NSString *)text;
///默认是左对齐的(小号字)
+(UILabel *)labelFrame:(CGRect)rect systemFont:(CGFloat)fontFloat textColor:(UIColor *)color text:(NSString *)text to:(UIView *)contentView;
///默认是左对齐的(粗体字)
+(UILabel *)labelFrame:(CGRect)rect boldFont:(CGFloat)fontFloat textColor:(UIColor *)color text:(NSString *)text to:(UIView *)contentView;
///什么龟都有的
+(UILabel *)labelFrame:(CGRect)rect align:(NSTextAlignment)align systemFont:(CGFloat)fontFloat textColor:(UIColor *)color text:(NSString *)text to:(UIView *)contentView;
///（最简）左对齐，不设frame
+(UILabel *)labelWithFontFloat:(CGFloat)fontFloat color:(UIColor *)color text:(NSString *)text to:(UIView *)contentView;

@end

@interface UIImageView (Utils)

+ (UIImageView *)imageViewWithFrame:(CGRect)rect image:(UIImage*)image contentView:(UIView *)contentView;

+ (UIImageView *)allocWithFrame:(CGRect)rect imageName:(NSString *)imageName to:(UIView *)contentView;

@end

@interface UIView (Utils)

+ (UIView *)viewWithFrame:(CGRect)rect color:(UIColor *)color contentView:(UIView *)contentView;

+ (UIView *)borderViewWithFrame:(CGRect)rect color:(UIColor *)color cornerRadius:(CGFloat)radius borderWidth:(CGFloat)width borderColor:(UIColor *)borderColor contentView:(UIView *)contentView;
///圆角
- (void)makeCornerRadius:(CGFloat)radius;
///设置边框和圆角（大于0才设置）
- (void)makeBorderWithCornerRadius:(CGFloat)radius borderWidth:(CGFloat)width borderColor:(UIColor *)color;
///制造阴影
- (void)makeShadowWithColor:(UIColor *)color offSet:(CGSize)offSet opacity:(CGFloat)opacity;
///显示在主窗口
-(void)showViewOnMainWindow;

@end

@interface UITextField (Utils)

+(UITextField *)allocMyTextFieldWithFontNumber:(CGFloat)fontNum placeHoder:(NSString *)hoder to:(UIView *)view;
//设置大小，占位符，字体显示的位置，字体的大小
+(UITextField *)allocTextFieldWithFrame:(CGRect)rect placeHoder:(NSString *)hoder textAligment:(NSTextAlignment)textAligment font:(CGFloat)size toView:(UIView *)view;


@end
