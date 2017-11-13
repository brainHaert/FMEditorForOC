//
//  Global.m
//  RecordsOfConsumption
//
//  Created by xuhui on 14/11/24.
//  Copyright (c) 2014年 xuhui. All rights reserved.
//

#import "Global.h"


id StringToJSONObject(NSString *responseString)
{
    NSError * responseError = nil;
    id responseData = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding]
                                                      options:NSJSONReadingAllowFragments
                                                        error:&responseError];
    return responseData;
}

UIFont *littleFont() {
    CGFloat littleFloat = 14;
    
    if (IS_IPHONE_4_OR_LESS || IS_IPHONE_5) {
        littleFloat = 12;
    }
    if (IS_IPHONE_6P) {
        littleFloat = 16;
    }
    return [UIFont systemFontOfSize:littleFloat];
}

// Cell标识
/// 消息模块cell标识
NSString *const FMMessageCellIdentifier = @"FMMessageCellIdentifier";


/// 消息模块评论cell标识
NSString *const FMNewCommentCellIndentifier = @"FMNewCommentCellIndentifier";

/// 消息模块赞cell标识
NSString *const FMNewPraiseCellIndentifier = @"FMNewPraiseCellIndentifier";

/// 消费回报产品选择cell标识
NSString *const FMFinanceProductDetailCellIdentifier = @"FMFinanceProductDetailCellIdentifier";

/// 理财产品结算cell标识
NSString *const FMFinanceAccountCellIdentifier = @"FMFinanceAccountCellIdentifier";

/// 关注的投资类型cell标识
NSString *const FMFinanceAttentionCellIdentifier = @"FMFinanceAttentionCellIdentifier";

/// 账户模块
/// 我的
NSString *const  FMMeCellIdentifier = @"FMMeCellIdentifier";

NSString *const FMSettingCellIdentifier = @"FMSettingCellIdentifier";

/// 疯蜜范主页
NSString *const FMFashionViewBigCellIdentifier = @"FMFashionViewBigCellIdentifier";
NSString *const FMFashionViewSmallCellIdentifier = @"FMFashionViewSmallCellIdentifier";
/// 疯蜜范分类
NSString *const FMFashionCategoryCellIdentifier = @"FMFashionCategoryCellIdentifier";

// 通知
/// 消息总数
NSString *const FMMessageCountNotification = @"FMMessageCountNotification";
NSString *const FMMessageCountNotificationKey = @"FMMessageCountNotificationKey";

/** 评论cell头像点击 */
NSString *const FMNewCommentOtherImageClickNotification = @"FMNewCommentOtherImageClickNotification";
NSString *const FMNewCommentOtherImageClickNotificationKey = @"FMNewCommentOtherImageClickNotificationKey";

NSString *const FMNewCommentMeImageClickNotification = @"FMNewCommentMeImageClickNotification";
NSString *const FMNewCommentMeImageClickNotificationKey = @"FMNewCommentMeImageClickNotificationKey";

NSString *const FMFinanceYTMNotification = @"FMFinanceYTMNotification";
NSString *const FMFinanceYTMNotificationModelKey = @"FMFinanceYTMNotificationModelKey";
NSString *const FMFinanceYTMNotificationBoolKey = @"FMFinanceYTMNotificationBoolKey";

NSString *const FMLoginSucceedNotification = @"FMLoginSucceedNotification";

NSString *const FMLogoutSucceedNotification = @"FMLogoutSucceedNotification";

NSString *const FMUpdateUserNameSucceedNotification = @"FMUpdateUserNameSucceedNotification";



// 本地数据存储Key值
NSString *const FMFansDataKey = @"FMFansDataKey";
