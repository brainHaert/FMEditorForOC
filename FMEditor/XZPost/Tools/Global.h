//
//  Global.h
//  RecordsOfConsumption
//
//  Created by xuhui on 14/11/24.
//  Copyright (c) 2014年 xuhui. All rights reserved.
//

//#import <Foundation/Foundation.h>

#ifdef __OBJC__
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#endif

#define ALERT_MSG(msg) static UIAlertView *alert; alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];\
[alert show];\

///在发布页面用到的头部高度
#define HEADERHEIGHT 80.f

#define NavigationBar_HEIGHT 44
#define NavigationBarAndStatusBarHeight 64
#define TabBarHeight 49

/// 账户
/// 标题栏高度
#define Title_Height 35
#define Title_MaxScale 1.2

#define GBKEncoding CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)

//是不是iPhone、iPad、Retina屏
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

//屏幕尺寸
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

//version
#define CurrentSystemVersion [[UIDevice currentDevice] systemVersion]

//Image Name
#undef TTIMAGE
#define TTIMAGE(A) [UIImage imageNamed:A]


//Font Size
#define fontWithBoldSize(size) [UIFont boldSystemFontOfSize:size]
#define fontWithSize(size) [UIFont systemFontOfSize:size]

//字体大小
#define FontSize12 fontWithSize(IS_IPHONE_6P?14:12)
#define FontSize14 fontWithSize(IS_IPHONE_6P?16:14)
#define FontSize16 fontWithSize(IS_IPHONE_6P?18:16)

#define BoldFontSize12 fontWithBoldSize(IS_IPHONE_6P?14:12)
#define BoldFontSize14 fontWithBoldSize(IS_IPHONE_6P?16:14)
#define BoldFontSize16 fontWithBoldSize(IS_IPHONE_6P?18:16)

//padding
#define Padding10           IS_IPHONE_4_OR_LESS?10:15


/**公用CodeViewController*/
typedef NS_ENUM(NSUInteger, ControllerForType){
    ViewControllerTypeReg = 0,    //注册
    ViewControllerTypeForgot,     //找回密码
    ViewControllerTypeLogin       //登录
};
/**公用网络类型*/
typedef NS_ENUM(NSUInteger, HttpForType){
    HttpTypeDelete = 0,    //Delete
    HttpTypeGet,           //GET
    HttpTypePost,           //POST
    HttpTypePut             //put
};
/**记账发布界面类型*/
typedef NS_ENUM(NSUInteger, FMEditStyleForType){
    EditStyleTypePublish = 0,       //发布用
    EditStyleTypeEdit            //首页编辑
};
/**收入还是支出*/
typedef NS_ENUM(NSUInteger, UIMoneyForType) {
    MoneyTypePay = 0,//支出
    MoneyTypeIncome,  //收入
    MoneyTypeInvest
};
/**模态还是推出窗口*/
typedef NS_ENUM(NSUInteger, FMHowToShowView) {
    ShowPushView = 0,//推
    ShowPresentView  //模态
};
/**从哪里弹出分享窗口*/
typedef NS_ENUM(NSUInteger, FMShareFrom) {
    FMShareFromDetail = 0,//从详情页弹
    FMShareFromMe,  //从我弹
    FMShareFromDiscover, //从发现
    FMShareFromInsurance //从理财
};
///充值还是支付
typedef NS_ENUM(NSUInteger, FMPayFor) {
    FMPayForPay = 0,//支付
    FMPayForRecharge  //充值
};

///textView是否为第一响应者
typedef NS_ENUM(NSUInteger, FMResponder) {
    FMResponderBecomeFirst = 0,//第一响应者
    FMResponderResignFirst  //取消第一相应者
};

///是否从主窗口进入
typedef NS_ENUM(NSUInteger, FMToCapture) {
    FMToCaptureFromOther = 0,//
    FMToCaptureFromDiscover  //从广场
};

///是否从主窗口进入
typedef NS_ENUM(NSUInteger, XZFromWhere) {
    XZFromMian = 0,//从主窗口进
    XZFromLogin,  //登录进
    XZFromME,//从我进
    XZFromSeletTag,//选择投资类型界面
    XZFromPostEnd,//发布结束页
    XZFromComment,//评论页
    XZFromMyBill, //我的账单页
    XZFromInsurance // 理财
};

/// 期限类型
typedef NS_ENUM(NSUInteger, FMTimeType) {
    FMTimeTypeDay = 1, // 天
    FMTimeTypeMonth,  //月
    FMTimeTypeYear // 年
};

/// 理财类型查看更多
typedef NS_ENUM(NSUInteger, FMFinanceType) {
    FMFinanceTypeLive, // 活期
    FMFinanceTypeOrder,  // 定期
    FMFinanceTypeStock // 股权
};

typedef NS_ENUM(NSUInteger, FMFashionDetailType) {
    FMFashionDetailTypeMe = 0, // 我的帖子
    FMFashionDetailTypeOther  // 他人的帖子
};

typedef NS_ENUM(NSUInteger, FMInsuranceType) {
    FMInsuranceTypePaySucceed = 0, // 领款成功
    FMInsuranceTypeListSucceed,  // 出单成功
    FMInsuranceTypeListFailed  // 出单失败
};

/// 投保查找方式
typedef NS_ENUM(NSUInteger, FMInsuranceFindType) {
    /// 免费领取
    FMInsuranceFindFree,
    /// 查找领取
    FMInsuranceFindOwen
    
};

id StringToJSONObject(NSString *responseString);
UIFont *littleFont() ;

// Cell标识
/// 消息模块cell标识
extern NSString *const FMMessageCellIdentifier;

/// 消息模块评论cell标识
extern NSString *const FMNewCommentCellIndentifier;

/// 消息模块赞cell标识
extern NSString *const FMNewPraiseCellIndentifier;

/// 消费回报产品选择cell标识
extern NSString *const FMFinanceProductDetailCellIdentifier;

/// 理财产品结算cell标识
extern NSString *const FMFinanceAccountCellIdentifier;

/// 关注的投资类型cell标识
extern NSString *const FMFinanceAttentionCellIdentifier;

/// 账户模块
/// 我的
extern NSString *const  FMMeCellIdentifier;

extern NSString *const FMSettingCellIdentifier;

/// 疯蜜范主页
extern NSString *const FMFashionViewBigCellIdentifier;
extern NSString *const FMFashionViewSmallCellIdentifier;
/// 疯蜜范分类
extern NSString *const FMFashionCategoryCellIdentifier;



// 通知
/** 消息总数 */
extern NSString *const FMMessageCountNotification;
extern NSString *const FMMessageCountNotificationKey;

/** 评论cell头像点击 */
extern NSString *const FMNewCommentOtherImageClickNotification;
extern NSString *const FMNewCommentOtherImageClickNotificationKey;

extern NSString *const FMNewCommentMeImageClickNotification;
extern NSString *const FMNewCommentMeImageClickNotificationKey;

/** 理财 */
extern NSString *const FMFinanceYTMNotification;
extern NSString *const FMFinanceYTMNotificationModelKey;
extern NSString *const FMFinanceYTMNotificationBoolKey;



/** 账户 */
extern NSString *const FMLoginSucceedNotification;

extern NSString *const FMLogoutSucceedNotification;


extern NSString *const FMUpdateUserNameSucceedNotification;




// 本地数据存储Key值
extern NSString *const FMFansDataKey;

