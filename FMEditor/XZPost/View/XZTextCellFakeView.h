//
//  XZCellTextView.h
//  FMB
//
//  Created by admin on 16/3/29.
//  Copyright © 2016年 ICompany. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XZTextCellFakeView;

@protocol XZTextCellFakeViewDelegate <NSObject>

- (void)cellTextFakeViewBeginEdit:(UITextView *)textView indexPath:(NSIndexPath *)indexPath;
- (void)cellTextFakeViewIsEditing:(UITextView *)textView indexPath:(NSIndexPath *)indexPath;
- (void)cellTextFakeViewEndEdit:(UITextView *)textView indexPath:(NSIndexPath *)indexPath;

@end

@interface XZTextCellFakeView : UITextView

- (instancetype)initWithFrame:(CGRect)frame indexPath:(NSIndexPath *)indexPath;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) CAShapeLayer *borderLayer;/**< 虚线*/

@property (nonatomic, strong) id<XZTextCellFakeViewDelegate>cellTextViewDelegate;

@end
