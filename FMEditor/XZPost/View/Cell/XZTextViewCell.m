//
//  XZTextViewCell.m
//  FMB
//
//  Created by 揭子龙 on 16/3/26.
//  Copyright © 2016年 ICompany. All rights reserved.
//

#import "XZTextViewCell.h"

@implementation XZTextViewCell
{
    NSIndexPath *_indexPath;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _textView = [[UITextView alloc]initWithFrame:self.bounds];
        
        _textView.font = [UIFont systemFontOfSize:16];
        
        _textView.textColor = [UIColor blackColor];
        
        _textView.delegate = self;
        
        self.backgroundView = _textView;
        
//        [self.layer addSublayer:self.borderLayer];
    }
    return self;
}

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
//    self.borderLayer.path = [UIBezierPath bezierPathWithRect:CGRectInset(self.bounds, 1, 1)].CGPath;
    
}

- (void)setCellTextView:(NSIndexPath *)indexPath {
//    self.borderLayer.hidden = NO;
}
- (void)setCellTextView:(NSString *)text indexPath:(NSIndexPath *)indexPath {
    //    self.borderLayer.hidden = NO;
    _textView.text = text;
    _indexPath = indexPath;
}

//#pragma mark setter
//- (CAShapeLayer *)borderLayer {
//    if (!_borderLayer) {
//        _borderLayer = [CAShapeLayer layer];
//        _borderLayer.fillColor = nil;
//        _borderLayer.lineWidth = 1.f;
//        _borderLayer.lineDashPattern = @[@2, @2];
//        _borderLayer.strokeColor = [UIColor blackColor].CGColor;
//    }
//    return _borderLayer;
//}
#pragma mark textView代理
#pragma mark 结束编辑的代理
- (void)textViewDidEndEditing:(UITextView *)textView {
//    DLog(@"textView代理 = %@ ,_indexPath = %@", textView.text,_indexPath);
    if (self.delegate && [self.delegate respondsToSelector:@selector(textViewCellEndEditing:indexPath:)]) {
        [self.delegate textViewCellEndEditing:textView.text indexPath:_indexPath];
    }
}
#pragma mark 开始编辑的代理
- (void)textViewDidBeginEditing:(UITextView *)textView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(textViewCellBeginEditingWithIndexPath:)]) {
        [self.delegate textViewCellBeginEditingWithIndexPath:_indexPath];
    }
}
#pragma mark 正在编辑的事件
- (void)textViewDidChange:(UITextView *)textView {
//    DLog(@"%@", textView.text);
    if (self.delegate && [self.delegate respondsToSelector:@selector(textViewCellIsEditing:indexPath:)]) {
        [self.delegate textViewCellIsEditing:textView indexPath:_indexPath];
    }
}
//-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
//    if (![UIMenuController  sharedMenuController]) {
//        [UIMenuController sharedMenuController].menuVisible=YES;
//    }
//    return YES;
//}
@end
