//
//  XZFooterReusableView.h
//  FMB
//
//  Created by admin on 16/3/31.
//  Copyright © 2016年 ICompany. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XZDetailFooterView;

@protocol XZDetailFooterViewDelegate <NSObject>

- (void)detailFooterViewPraiseImageClick;

- (void)detailFooterViewAddCollect;

- (void)detailFooterViewDeleteCollect;

- (void)detailFooterViewTipsNotLogin;

@end

@interface XZDetailFooterView : UICollectionReusableView

- (void)setDetailFooterData:(NSDictionary *)dataDict;

@property (nonatomic, strong)id<XZDetailFooterViewDelegate>delegate;

@property (nonatomic, copy)NSString *userID;

@end
