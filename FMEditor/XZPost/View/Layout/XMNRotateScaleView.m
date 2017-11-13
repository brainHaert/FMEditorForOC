//
//  XMNSizeView.m
//  XMNSizeTextExample
//
//  Created by shscce on 15/11/26.
//  Copyright © 2015年 xmfraker. All rights reserved.
//

#import "XMNRotateScaleView.h"


CG_INLINE CGFloat CGPointGetDistance(CGPoint point1, CGPoint point2)
{
    //Saving Variables.
    CGFloat fx = (point2.x - point1.x);
    CGFloat fy = (point2.y - point1.y);
    
    return sqrt((fx*fx + fy*fy));
//    return sqrt(0);
}

CG_INLINE CGRect CGRectScale(CGRect rect, CGFloat wScale, CGFloat hScale)
{
    return CGRectMake(0, 0 , rect.size.width * wScale, rect.size.height * hScale);
}



@interface XMNRotateScaleView ()
{
    //1.放大手势需要用到的变量
    CGRect  _initalFrame; /**< 放大之前的XMNTextField的frame */
    CGFloat _initalDistance; /**< 放大之前触摸点距离XMNTextField center的距离 */
    CGPoint _initCenter; /**< 放大之前XMNTextField的center */
    CGFloat _initAngle; /**< 旋转之前角度 */
    
    CGPoint _touchStart;
    
    BOOL _moved; /**< touchEnd时根据_moved判断是否移动过,未移动则改写state */
    
}

@property (nonatomic, strong) UIImageView *rotateScaleIV;
@property (nonatomic, strong) UIView *rotateScaleView;

@end

@implementation XMNRotateScaleView


#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame muneType:(XZMuneType)muneType{
    
    if ([super initWithFrame:frame]) {
        
        
        self.muneType = muneType;
        
        [self setup];
        
        if (self.muneType == XZMuneTypeImage) {
            
            self.layer.borderWidth = 2.f;
            self.layer.borderColor = [UIColor redColor].CGColor;
            self.rotateScaleIV.hidden = NO;
            self.rotateScaleView.hidden = NO;
            
        } else {
            
            self.layer.borderWidth = 0;
            self.layer.borderColor = [UIColor clearColor].CGColor;
            self.rotateScaleIV.hidden = YES;
            self.rotateScaleView.hidden = YES;
        }
        
    }
    return self;
    
}
#pragma mark - Public Methods
#pragma mark 重写frame方法
-(void)setFrame:(CGRect)frame {
    //重新计算frame,缩放到最小的size后,不能继续缩放
    CGRect scaleRect = frame;
    if (frame.size.width <= self.minSize.width && frame.size.height <= self.minSize.height) {
        scaleRect= CGRectMake(frame.origin.x, frame.origin.y, self.minSize.width, self.minSize.height);
    }else if (frame.size.width <= self.minSize.width) {
        scaleRect= CGRectMake(frame.origin.x, frame.origin.y, self.minSize.width, frame.size.height);
    }else if (frame.size.height <= self.minSize.height) {
        
        scaleRect= CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, self.minSize.height);
        
    }else if (frame.size.width >= self.maxSize.width && frame.size.height >= self.maxSize.height) {
        scaleRect= CGRectMake(frame.origin.x, frame.origin.y, self.maxSize.width, self.maxSize.height);
    } else if (frame.size.width >= self.maxSize.width) {
        scaleRect= CGRectMake(frame.origin.x, frame.origin.y, self.maxSize.width, frame.size.height);
    } else if (frame.size.height >= self.maxSize.height) {
        scaleRect= CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, self.maxSize.height);
    }
    
    [super setFrame:frame];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    _touchStart = [[touches anyObject] locationInView:self.superview];
}



#pragma mark - Private Methods

- (void)setup {
    
    //1.计算出中心center,为重写计算frame前,用来确定view的位置(不用)
    _initCenter = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    
    //2.初始化默认borderColor,borderWidth
    self.borderColor = [UIColor yellowColor];
    self.borderWidth = 1.0f;
    
    //3.初始化默认最小、最大大小
    self.minSize = CGSizeMake(self.frame.size.width, self.frame.size.height / 3);
//    CGFloat maxWidth = [UIScreen mainScreen].bounds.size.width;
    self.maxSize = CGSizeMake(self.frame.size.width, [UIScreen mainScreen].bounds.size.width * 2);
    
    //4.设置默认状态
    self.state = XMNRotateScaleViewStateNormal;
    
    //5.添加旋转控制IV,边框
    [self addSubview:self.rotateScaleIV];
    [self addSubview:self.rotateScaleView];
    
    //6.计算当前旋转角度
//    _initAngle = atan2(self.frame.origin.y+self.frame.size.height - self.center.y,self.frame.origin.x+self.frame.size.width - self.center.x);
    
}


- (void)handleRotateScalePan:(UIPanGestureRecognizer *)pan {
    
    CGPoint touchPoint = [pan locationInView:self.superview];
    CGPoint beginPoint = CGPointMake(self.frame.origin.x + self.frame.size.width/2, self.frame.origin.y);
    
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        _initalFrame = self.frame;
        _initalDistance = CGPointGetDistance(beginPoint, touchPoint);
        
    }else if (pan.state == UIGestureRecognizerStateChanged) {
        [self setNeedsDisplay];
        
        //        double scale = sqrtf(CGPointGetDistance(beginPoint, touchPoint)/_initalDistance);
        double scale = CGPointGetDistance(beginPoint, touchPoint)/_initalDistance;
        CGRect scaleRect = CGRectScale(_initalFrame, scale, scale);
        
        
        if (scaleRect.size.width <= self.minSize.width) {
            scaleRect.size.width = self.minSize.width;
        } else if (scaleRect.size.height <= self.minSize.height) {
            scaleRect.size.height = self.minSize.height;
        } else if (scaleRect.size.width >= self.maxSize.width) {
            scaleRect.size.width = self.maxSize.width;
        } else if (scaleRect.size.height >= self.maxSize.height) {
            scaleRect.size.height = self.maxSize.height;
        }
        
        if (scaleRect.size.height <= self.minSize.height) {
            scaleRect.size.height = self.minSize.height;
        } else if (scaleRect.size.height >= self.maxSize.height) {
            scaleRect.size.height = self.maxSize.height;
        }
        
        if (self.frame.size.width != scaleRect.size.width || self.frame.size.height != scaleRect.size.height) {
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, scaleRect.size.height);
            if (self.delegate && [self.delegate respondsToSelector:@selector(rotateScaleViewDidRotateAndScale:)]) {
                [self.delegate rotateScaleViewDidRotateAndScale:self];
            }
        }

        
    }else if (pan.state == UIGestureRecognizerStateCancelled || pan.state == UIGestureRecognizerStateEnded){//拖动结束

        if (self.delegate && [self.delegate respondsToSelector:@selector(rotateScaleViewEndRotateAndScale:)]) {
            [self.delegate rotateScaleViewEndRotateAndScale:self];
        }
    }
}

#pragma mark - Setters

- (void)setContentView:(UIView *)contentView {
    [_contentView removeFromSuperview];
    
    _contentView = contentView;
//    _contentView.frame = CGRectInset(self.bounds, kXMNInset + kXMNBorderInset, kXMNInset + kXMNBorderInset);
    _contentView.frame = self.bounds;
    contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:contentView];
    [self bringSubviewToFront:self.rotateScaleIV];
    [self bringSubviewToFront:self.rotateScaleView];
}

#pragma mark - Getters
#pragma mark 那个小红点（现在设置很大，而且透明）
- (UIImageView *)rotateScaleIV {
    if (!_rotateScaleIV) {
        _rotateScaleIV = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width - kXMNRotateScaleControlWidth)/2, self.frame.size.height - kXMNRotateScaleControlHeight + 10, kXMNRotateScaleControlWidth, kXMNRotateScaleControlHeight)];

        _rotateScaleIV.userInteractionEnabled = YES;

        _rotateScaleIV.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;

        UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotateScalePan:)];
        [_rotateScaleIV addGestureRecognizer:panGes];
        
    }
    return _rotateScaleIV;
}
- (UIView *)rotateScaleView {
    if (!_rotateScaleView) {
        _rotateScaleView = [[UIView alloc] initWithFrame:CGRectMake((self.frame.size.width - kXMNRotateScaleAlhpWidth)/2, self.frame.size.height - kXMNRotateScaleAlhpWidth/2, kXMNRotateScaleAlhpWidth, kXMNRotateScaleAlhpWidth)];
        _rotateScaleView.userInteractionEnabled = YES;
        _rotateScaleView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
        _rotateScaleView.backgroundColor = [UIColor yellowColor];
        UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotateScalePan:)];
        [_rotateScaleView addGestureRecognizer:panGes];
    }
    return _rotateScaleView;
}
@end
