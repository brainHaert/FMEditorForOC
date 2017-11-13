//
//  XZCellTextView.m
//  FMB
//
//  Created by admin on 16/3/29.
//  Copyright © 2016年 ICompany. All rights reserved.
//

#import "XZTextCellFakeView.h"
#import "MEUtils.h"

@interface XZTextCellFakeView ()
@property(nonatomic,assign) CGPoint selectedPoint;
@property(nonatomic,assign) CGRect cellFram;
@end


@implementation XZTextCellFakeView
{
    UIView *_coverView;
}

- (instancetype)initWithFrame:(CGRect)frame indexPath:(NSIndexPath *)indexPath
{
    self = [super initWithFrame:frame];
    if (self) {
        self.cellFram=frame;
        
        self.font = [UIFont systemFontOfSize:16];
        self.textColor = [UIColor blackColor];
        _borderLayer = [CAShapeLayer layer];
        _borderLayer.fillColor = nil;
        _borderLayer.lineWidth = 1.f;
        _borderLayer.lineDashPattern = @[@2, @2];
        _borderLayer.strokeColor = [UIColor blackColor].CGColor;
        _borderLayer.path = [UIBezierPath bezierPathWithRect:CGRectInset(self.bounds, 1, 1)].CGPath;
        [self.layer addSublayer:self.borderLayer];
        self.indexPath = indexPath;
        // 监听文本变化
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextViewTextDidChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textBeginChange) name:UITextViewTextDidBeginEditingNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textEndChange) name:UITextViewTextDidEndEditingNotification object:nil];
        
        _coverView = [UIView viewWithFrame:self.bounds color:[UIColor clearColor] contentView:self];
        
        
        for (UIGestureRecognizer *gestureRecognizer in self.gestureRecognizers) {
            NSLog(@"333 == %@", gestureRecognizer);
        }
#warning ---- 8.3系统不能复制粘贴，要加多一个长按手势给他
        //给cell添加手势,长按调出UIMenuController，单击移动光标
                UILongPressGestureRecognizer *longPre = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGestures:)];
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPress:)];
        double version = [[UIDevice currentDevice].systemVersion doubleValue];
        if (version < 9.0) {
            [self addGestureRecognizer:longPre];
        }

        [self addGestureRecognizer:tap];
        
    }
    return self;
}
- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    self.borderLayer.path = [UIBezierPath bezierPathWithRect:CGRectInset(bounds, 1, 1)].CGPath;
    _coverView.frame = bounds;
}

- (void)textChange {
    if (self.cellTextViewDelegate && [self.cellTextViewDelegate respondsToSelector:@selector(cellTextFakeViewIsEditing:indexPath:)]) {
        [self.cellTextViewDelegate cellTextFakeViewIsEditing:self indexPath:self.indexPath];
    }
}
- (void)textBeginChange {
    if (self.cellTextViewDelegate && [self.cellTextViewDelegate respondsToSelector:@selector(cellTextFakeViewBeginEdit:indexPath:)]) {
        [self.cellTextViewDelegate cellTextFakeViewBeginEdit:self indexPath:self.indexPath];
    }
}
- (void)textEndChange {
    if (self.cellTextViewDelegate && [self.cellTextViewDelegate respondsToSelector:@selector(cellTextFakeViewEndEdit:indexPath:)]) {
        [self.cellTextViewDelegate cellTextFakeViewEndEdit:self indexPath:self.indexPath];
    }
}
#pragma mark---手势点击
-(void)handleLongPressGestures:(UIGestureRecognizer *)gest{
    
    CGPoint cellPoit=[gest locationInView:self];
    
    
    
    switch (gest.state) {
        case UIGestureRecognizerStateEnded:
            
          
            if ([UIMenuController sharedMenuController]) {

                CGPoint point=[gest locationInView:self];
                UITextPosition *position=[self closestPositionToPoint:point];
                
                [self setSelectedTextRange:[self textRangeFromPosition:position toPosition:position]];
                
                CGSize textS = [self.text sizeWithFont:[UIFont systemFontOfSize:16]];
                float x;
//                cellPoit.x > textS.width ? x=textS.width : x=cellPoit.x;
                if (cellPoit.x > textS.width) {
                    x = textS.width;
                }else{
                    x = cellPoit.x;
                }

                
                UIMenuController *menu=[UIMenuController sharedMenuController];
                [menu setTargetRect:CGRectMake(x - 50, (int)cellPoit.y/20 * 20 , 100, 100) inView:self];

                [menu setMenuVisible:YES animated:YES];

            }
            break;
        
        default:
            break;
    }
    
    
}
-(void)tapPress:(UIGestureRecognizer *)gest{
    
 
    
    if (gest.state==UIGestureRecognizerStateEnded) {
        self.editable=YES;
        self.dataDetectorTypes=UIDataDetectorTypeNone;
        [self becomeFirstResponder];
        
        CGPoint point=[gest locationInView:self];
        UITextPosition *position=[self closestPositionToPoint:point];
//        NSLog(@"%@",position);
        [self setSelectedTextRange:[self textRangeFromPosition:position toPosition:position]];
        
    }
    
}

@end