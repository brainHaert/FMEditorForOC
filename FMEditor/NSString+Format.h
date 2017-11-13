//
//  NSString+Format.h
//
//
//  Created by xuhui on 13-11-6.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Format)

- (BOOL)isDecimal;

-(BOOL)isValidateEmail;
/**是否手机号*/
-(BOOL)isMobileNumber;
/**是否固话*/
-(BOOL)isPhoneNum;


/** 获取系统当前时间的字符串格式 格式例如yyyy-MM-dd HH:mm:ss:SSS */
+ (NSString *)stringDateByFormatString:(NSString *)formatString;
/**
 *把date转成字符串yyyy-MM-dd
 */
+(NSString *)changeEnglishStringFromDate:(NSDate *)pickerDate;
/**
 *把date转成字符串中文yyyy年MM月dd日
 */
+(NSString *)changeIntoStringFromDate:(NSDate *)pickerDate;
/**
 *把date转成字符串中文MM月dd日
 */
+(NSString *)changeMMDDStringFromDate:(NSDate *)pickerDate;

/**把date转成字符串YYYYorMMorDD 1.yyyy;2.MM;3.dd.*/
+(NSString *)changeYYYYorMMorDDStringFromDate:(NSDate *)pickerDate DateStyle:(NSInteger)style;

/**
 *转换时间戳格式%ld小时前
 */
+ (NSString *)changeResultWithTimestamp:(NSString *)timestamp;

///转换时间戳(包含3种格式)
+ (NSString *)changeResultFromTimestamp:(NSString *)timestamp;

/***转换时间戳格式yyyy-MM-dd HH:mm:ss*/
+ (NSString *)timeFormatted:(NSString *)totalSeconds;

/***转换时间戳格式yyyy-MM-dd HH:mm*/
+ (NSString *)timeToFormatted:(NSString *)totalSeconds;

/** 转换时间戳格式yyyy-MM-dd */
+ (NSString *)timeFormattedToyyyyMMdd:(NSString *)totalSeconds;

/** 转换时间戳中文格式MM月dd日 */
+ (NSString *)timeFormattedToMMdd:(NSString *)totalSeconds;
/** 转换时间戳中文格式MM月dd日 HH时mm分*/
+ (NSString *)timeFormattedInChiese:(NSString *)totalSeconds;
/** 转换时间戳中文格式yyyy年MM月dd日*/
+ (NSString *)timeFormattedToChieseyyyyMMdd:(NSString *)totalSeconds;
/** 转换时间(从现在开始)戳格式HHmmss*/
+ (NSString *)timeFormattedFromNowToHHmmss:(NSString *)totalSeconds;
/**
 *判断是否今天转换时间戳格式yyyy-MM-dd-刚刚之类
 */
+ (NSString *)changeResultIntoTimestamp:(NSString *)timestamp;
/**
 *计算字体宽度的方法
 */
+(CGFloat)widthFromString:(NSString *)string withLabelHeight:(CGFloat)height andLabelFont:(UIFont *)yourFont;

/**
 *计算字体高度的方法
 */
+(CGFloat)heightFromString:(NSString *)string withLabelWidth:(CGFloat)width andLabelFont:(UIFont *)yourFont;
///根据label的宽度和最大高度计算字体高度的方法
+(CGFloat)heightFromString:(NSString *)string LabelWidth:(CGFloat)width maxHeight:(CGFloat)maxH LabelFont:(UIFont *)yourFont;

/// 数字格式化为每隔三位用逗号隔开
- (NSString *)stringLocalizedStringFromNumber;

/**
 *   阿拉伯数字转化为中文数字
 *
 *  @param arebic 阿拉伯数字
 *
 *  @return 中文数字
 */
+ (NSString *)translation:(NSString *)arebic;
///把字典和数组转换成json字符串
+(NSString *)stringTOjson:(id)temps;
///把字典和数组转换成kNilOptions格式json字符串
+(NSString *)stringTOkNilOptionsjson:(id)temps;
@end
