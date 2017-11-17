//
//  MEUtils.m
//  
//
//  Created by Vince on 15/11/24.
//
//
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

#import "MEUtils.h"

//@implementation MEUtils
//
//@end

@implementation UIButton (Utils)
+ (UIButton *)buttonWithImage:(UIImage *)image frame:(CGRect)rect target:(id)target action:(SEL)action contentView:(UIView *)contentView{
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:rect];
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:button];
    return button;
    
}
+ (UIButton *)buttonImageName:(NSString *)image selectImageName:(NSString *)selImage frame:(CGRect)rect target:(id)target action:(SEL)action to:(UIView *)contentView{
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:rect];
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:selImage] forState:UIControlStateSelected];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:button];
    return button;
    
}
+ (UIButton *)buttonWithTitle:(NSString *)title titleColor:(UIColor *)color target:(id)target action:(SEL)action to:(UIView *)contentView{
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:color forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:button];
    return button;
    
}


@end

@implementation UILabel (Utils)
+(UILabel *)labelWithFrame:(CGRect)rect align:(NSTextAlignment)align font:(UIFont *)font color:(UIColor *)color text:(NSString *)text autoText:(BOOL)autotext contentView:(UIView *)contentView{
    UILabel *label=[[UILabel alloc]initWithFrame:rect];
    label.textAlignment=align;
    label.font=font;
    label.textColor=color;
    autotext?[label setAutoText:text]:[label setText:text];
    [contentView addSubview:label];
    return label;
}
- (void)setAutoText:(NSString *)text{
    CGSize size=[text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.font} context:nil].size;
    CGRect rect=CGRectMake(self.frame.origin.x-(size.width-self.frame.size.width)/2.0, self.frame.origin.y, size.width, size.height);
    [self setText:text];
    [self setFrame:rect];
}
+(UILabel *)labelFrame:(CGRect)rect align:(NSTextAlignment)align systemFont:(CGFloat)fontFloat textColor:(UIColor *)color text:(NSString *)text to:(UIView *)contentView{
    UILabel *label = [[UILabel alloc]initWithFrame:rect];
    label.font = [UIFont systemFontOfSize:fontFloat];
    label.textAlignment = align;
    label.textColor = color;
    label.text = text;
    [contentView addSubview:label];
    return label;
}
+(UILabel *)labelFrame:(CGRect)rect systemFont:(CGFloat)fontFloat textColor:(UIColor *)color text:(NSString *)text to:(UIView *)contentView{
    UILabel *label = [[UILabel alloc]initWithFrame:rect];
    label.font = [UIFont systemFontOfSize:fontFloat];
    label.textColor = color;
    label.text = text;
    [contentView addSubview:label];
    return label;
}
+(UILabel *)labelFrame:(CGRect)rect boldFont:(CGFloat)fontFloat textColor:(UIColor *)color text:(NSString *)text to:(UIView *)contentView{
    UILabel *label = [[UILabel alloc]initWithFrame:rect];
    label.font = [UIFont boldSystemFontOfSize:fontFloat];
    label.textColor = color;
    label.text = text;
    [contentView addSubview:label];
    return label;
}
+(UILabel *)labelWithFontFloat:(CGFloat)fontFloat color:(UIColor *)color text:(NSString *)text to:(UIView *)contentView{
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:fontFloat];
    label.text = text;
    label.textColor = color;
    [contentView addSubview:label];
    return label;
}
@end

@implementation UIImageView (Utils)
+(UIImageView *)imageViewWithFrame:(CGRect)rect image:(UIImage *)image contentView:(UIView *)contentView{
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:rect];
    [imageView setImage:image];
    [contentView addSubview:imageView];
    return imageView;
}
+(UIImageView *)allocWithFrame:(CGRect)rect imageName:(NSString *)imageName to:(UIView *)contentView{
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:rect];
    [imageView setImage:[UIImage imageNamed:imageName]];
    [contentView addSubview:imageView];
    return imageView;
}
@end

@implementation UIView (Utils)
+ (UIView *)viewWithFrame:(CGRect)rect color:(UIColor *)color contentView:(UIView *)contentView{
    UIView *view=[[UIView alloc]initWithFrame:rect];
    [view setBackgroundColor:color];
    [contentView addSubview:view];
    return view;
}
+ (UIView *)borderViewWithFrame:(CGRect)rect color:(UIColor *)color cornerRadius:(CGFloat)radius borderWidth:(CGFloat)width borderColor:(UIColor *)borderColor contentView:(UIView *)contentView{
    UIView *view=[[UIView alloc]initWithFrame:rect];
    [view setBackgroundColor:color];
    [view makeBorderWithCornerRadius:radius borderWidth:width borderColor:borderColor];
    [contentView addSubview:view];
    return view;
}
#pragma mark 设置圆角
- (void)makeCornerRadius:(CGFloat)radius {
    self.layer.cornerRadius = radius;
    self.layer.masksToBounds = YES;
}
#pragma mark 设置边框和圆角（大于0才设置）
- (void)makeBorderWithCornerRadius:(CGFloat)radius borderWidth:(CGFloat)width borderColor:(UIColor *)color{
    self.layer.borderWidth = width;
    self.layer.borderColor = [color CGColor];
    if (radius) {
        [self makeCornerRadius:radius];
    }
}
- (void)makeShadowWithColor:(UIColor *)color offSet:(CGSize)offSet opacity:(CGFloat)opacity{
    [self.layer setShadowOpacity:opacity];//设置阴影的透明度
    [self.layer setShadowColor:color.CGColor];
//    [self.layer setOpacity:0.5f];//设置View的透明度
    [self.layer setShadowOffset:offSet];//设置View Shadow的偏移量
}
#pragma mark 显示在主窗口
-(void)showViewOnMainWindow{
    if(!self.superview){
        NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
        for (UIWindow *window in frontToBackWindows){
            BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
            BOOL windowIsVisible = !window.hidden && window.alpha > 0;
            BOOL windowLevelNormal = window.windowLevel == UIWindowLevelNormal;
            
            if (windowOnMainScreen && windowIsVisible && windowLevelNormal) {
                [window addSubview:self];
                break;
            }
        }
    } else {
        // Ensure that overlay will be exactly on top of rootViewController (which may be changed during runtime).
        [self.superview bringSubviewToFront:self];
    }
}
@end

@implementation UITextField (Utils)

#pragma mark 初始化textField
+(UITextField *)allocMyTextFieldWithFontNumber:(CGFloat)fontNum placeHoder:(NSString *)hoder to:(UIView *)view{
    UITextField *textField = [[UITextField alloc]init];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.font = [UIFont systemFontOfSize:fontNum];
    textField.textAlignment = NSTextAlignmentCenter;
    textField.textColor = [UIColor blackColor];
    textField.returnKeyType = UIReturnKeyNext;
    textField.placeholder = hoder;
    [view addSubview:textField];
    return textField;
}

+(UITextField *)allocTextFieldWithFrame:(CGRect)rect placeHoder:(NSString *)hoder textAligment:(NSTextAlignment)textAligment font:(CGFloat)size toView:(UIView *)view{
    
    UITextField *textField = [[UITextField alloc] initWithFrame:rect];
    textField.placeholder = hoder;
    textField.textAlignment = textAligment;
    textField.font = [UIFont systemFontOfSize:size];
    [view addSubview:textField];
    return textField;
}
@end

