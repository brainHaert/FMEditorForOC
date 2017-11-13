//
//  XZDetailReusableView.h
//  FMB
//
//  Created by 揭子龙 on 16/3/30.
//  Copyright © 2016年 ICompany. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XZDetailHeaderViewDelegate <NSObject>

- (void)detailHeaderImageViewClick:(NSString *)userID;

@end

@interface XZDetailHeaderView : UICollectionReusableView

- (void)getDetailReuseableViewData:(NSDictionary *)dataDict;

@property (nonatomic, strong)id<XZDetailHeaderViewDelegate>delegate;

@end
