//
//  XZTextViewCell.h
//  FMB
//
//  Created by 揭子龙 on 16/3/26.
//  Copyright © 2016年 ICompany. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XZTextViewCell;

@protocol XZTextViewCellDeleaget <NSObject>

- (void)textViewCellEndEditing:(NSString *)text indexPath:(NSIndexPath *)indexPath;

- (void)textViewCellBeginEditingWithIndexPath:(NSIndexPath *)indexPath;

- (void)textViewCellIsEditing:(UITextView *)textView indexPath:(NSIndexPath *)indexPath;

@end

@interface XZTextViewCell : UICollectionViewCell<UITextViewDelegate>

@property (nonatomic, strong)UITextView *textView;/**< 文*/

//@property (nonatomic, strong) CAShapeLayer *borderLayer;/**< 虚线*/

@property (nonatomic, strong) id<XZTextViewCellDeleaget>delegate;

- (void)setCellTextView:(NSIndexPath *)indexPath;

- (void)setCellTextView:(NSString *)text indexPath:(NSIndexPath *)indexPath ;

@end
