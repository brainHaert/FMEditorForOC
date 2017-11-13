//
//  NSString+Format.m
//
//
//  Created by xuhui on 13-11-6.
//
//

#import "NSString+Format.h"

@implementation NSString (Format)

- (BOOL)isDecimal
{
    if (self.length<=0) {
        return NO;
    }
    NSString *numberRegex = @"^[1-9]+(\\.[0-9]{2})?$";
    NSPredicate *numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegex];
    return [numberTest evaluateWithObject:self];
}

-(BOOL)isValidateEmail {
//    if(!TTIsStringWithAnyText(self)) {
//        return NO;
//    }
    if (self.length<=0) {
        return NO;
    }
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

-(BOOL)isMobileNumber {
    
    /**
     
     *
     手机号码
     
     *
     移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     
     *
     联通：130,131,132,152,155,156,185,186
     
     *
     电信：133,1349,153,180,189
     
     */
    
    NSString*
    MOBILE=
    @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    
    /**
     *
     中国移动：China Mobile
     
     *
     134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     
     */
    
    //    NSString*
    //    CM=
    //    @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    //
    //    /**
    //
    //     *
    //     中国联通：China Unicom
    //
    //     *
    //     130,131,132,152,155,156,185,186
    //
    //     */
    //
    //    NSString*
    //    CU=
    //    @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    //
    //    /**
    //
    //     *
    //     中国电信：China Telecom
    //
    //     *
    //     133,1349,153,180,189
    //
    //     */
    //
    //    NSString*
    //    CT=
    //    @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    
    NSPredicate* regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    
    if(([regextestmobile evaluateWithObject:self] == YES))
        
    {
        return YES;
    }
    else
        
    {
        return NO;
    }
    
}

-(BOOL)isPhoneNum {
    /**
     
     *
     大陆地区固话及小灵通
     
     *
     区号：010,020,021,022,023,024,025,027,028,029
     
     *
     号码：七位或八位
     
     */
    
    //
    NSString * PHS = @"^(0(10|2[0-5789]|\\d{3})){0,4}-?\\d{7,8}$";
    NSPredicate* regextestphone = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];
    return [regextestphone evaluateWithObject:self];
}
#pragma mark -- 获取系统当前时间的字符串格式 格式例如yyyy-MM-dd HH:mm:ss:SSS
+ (NSString *)stringDateByFormatString:(NSString *)formatString {
    NSDateFormatter * dateFromatter=[[NSDateFormatter alloc] init];
    [dateFromatter setTimeStyle:NSDateFormatterShortStyle];
    if(formatString!=nil) {
        [dateFromatter setDateFormat:formatString];
    }
    NSString * strDate=[dateFromatter stringFromDate:[NSDate date]];
    return strDate;
}

#pragma mark - 把date转成字符串yyyy-MM-dd
+(NSString *)changeEnglishStringFromDate:(NSDate *)pickerDate
{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    //    dateFormatter
    //    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    return [dateFormatter stringFromDate:pickerDate];
}
#pragma mark - 把date转成字符串yyyy年MM月dd日
+(NSString *)changeIntoStringFromDate:(NSDate *)pickerDate
{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    //    dateFormatter
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    return [dateFormatter stringFromDate:pickerDate];
}
#pragma mark - 把date转成字符串MM月dd日
+(NSString *)changeMMDDStringFromDate:(NSDate *)pickerDate
{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    //    dateFormatter
    [dateFormatter setDateFormat:@"MM月dd日"];
    return [dateFormatter stringFromDate:pickerDate];
}
#pragma mark - 把date转成字符串YYYYorMMorDD 1.yyyy;2.MM;3.dd.
+(NSString *)changeYYYYorMMorDDStringFromDate:(NSDate *)pickerDate DateStyle:(NSInteger)style
{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    //    dateFormatter
    if (style == 1) {
        [dateFormatter setDateFormat:@"yyyy"];
    } else if (style == 2) {
        [dateFormatter setDateFormat:@"MM"];
    } else {
        [dateFormatter setDateFormat:@"dd"];
    }
    
    return [dateFormatter stringFromDate:pickerDate];
}
#pragma mark - 根据label的宽度计算字体高度的方法
+(CGFloat)heightFromString:(NSString *)string withLabelWidth:(CGFloat)width andLabelFont:(UIFont *)yourFont{
    // 计算字体尺寸
    NSMutableDictionary *att = [NSMutableDictionary dictionary];
    att[NSFontAttributeName] = yourFont;
    CGSize textSize = [string boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:att context:nil].size;
    return textSize.height;
}
#pragma mark - 根据label的宽度和最大高度计算字体高度的方法
+(CGFloat)heightFromString:(NSString *)string LabelWidth:(CGFloat)width maxHeight:(CGFloat)maxH LabelFont:(UIFont *)yourFont{
    // 计算字体尺寸
    NSMutableDictionary *att = [NSMutableDictionary dictionary];
    att[NSFontAttributeName] = yourFont;
    CGSize textSize = [string boundingRectWithSize:CGSizeMake(width, maxH) options:NSStringDrawingUsesLineFragmentOrigin attributes:att context:nil].size;
    return textSize.height;
}
#pragma mark - 根据label的高度计算字体宽度的方法
+(CGFloat)widthFromString:(NSString *)string withLabelHeight:(CGFloat)height andLabelFont:(UIFont *)yourFont{
    // 计算字体尺寸
    NSMutableDictionary *att = [NSMutableDictionary dictionary];
    att[NSFontAttributeName] = yourFont;
    CGSize textSize = [string boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:att context:nil].size;
    return textSize.width;
}
#pragma mark 转换时间戳
+ (NSString *)changeResultWithTimestamp:(NSString *)timestamp{
    NSTimeInterval timeInterval_since = [timestamp doubleValue];
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:timeInterval_since];
    NSTimeInterval  timeInterval = [date timeIntervalSinceNow];
    timeInterval = -timeInterval;
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if((temp = timeInterval/60) <60){
        result =[NSString stringWithFormat:@"%ld分钟前",temp];
    }
    
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%ld小时前",temp];
    }
    
    else if((temp = temp/24) <30){
        result = [NSString stringWithFormat:@"%ld天前",temp];
    }
    
    else if((temp = temp/30) <12){
        result = [NSString stringWithFormat:@"%ld月前",temp];
    }
    else{
        temp = temp/12;
        result = [NSString stringWithFormat:@"%ld年前",temp];
    }
    return result;
}
#pragma mark 转换时间戳(包含3种格式)
+ (NSString *)changeResultFromTimestamp:(NSString *)timestamp{
    NSTimeInterval timeInterval_since = [timestamp doubleValue];
    NSDate *detaildate = [NSDate dateWithTimeIntervalSince1970:timeInterval_since];
    NSTimeInterval  timeInterval = [detaildate timeIntervalSinceNow];
    timeInterval = -timeInterval;
    
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if ((temp = timeInterval/60) <60){
        result =[NSString stringWithFormat:@"%ld分钟前",temp];
    }
    
    else if ((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%ld小时前",temp];
    }
    
    else if ((temp = temp/24) <30){
//        result = [NSString stringWithFormat:@"%ld天前",temp];
        [dateFormatter setDateFormat:@"MM-dd HH:mm"];
        result = [dateFormatter stringFromDate: detaildate];
    }
    
    else if ((temp = temp/30) <12){
//        result = [NSString stringWithFormat:@"%ld月前",temp];
        [dateFormatter setDateFormat:@"MM-dd HH:mm"];
        result = [dateFormatter stringFromDate: detaildate];
    }
    else {
        temp = temp/12;
//        result = [NSString stringWithFormat:@"%ld年前",temp];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        result = [dateFormatter stringFromDate: detaildate];
    }
    return result;
}
#pragma mark 转换时间戳格式yyyy-MM-dd HH:mm:ss
+ (NSString *)timeFormatted:(NSString *)totalSeconds
{
    NSTimeInterval time=[totalSeconds doubleValue];
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    return currentDateStr;
    
}
#pragma mark 转换时间戳格式yyyy-MM-dd HH:mm
+ (NSString *)timeToFormatted:(NSString *)totalSeconds
{
    NSTimeInterval time=[totalSeconds doubleValue];
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    return currentDateStr;
    
}
#pragma mark 转换时间戳格式MM月dd日 HH时mm分
+ (NSString *)timeFormattedInChiese:(NSString *)totalSeconds
{
    NSTimeInterval time=[totalSeconds doubleValue];
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"MM月dd日HH时mm分"];
    
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    return currentDateStr;
    
}
#pragma mark 转换时间戳格式yyyy-MM-dd
+ (NSString *)timeFormattedToyyyyMMdd:(NSString *)totalSeconds
{
    NSTimeInterval time = [totalSeconds doubleValue];
    NSDate *detaildate = [NSDate dateWithTimeIntervalSince1970:time];
    
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    return currentDateStr;
    
}
#pragma mark 转换时间戳格式yyyy年MM月dd日
+ (NSString *)timeFormattedToChieseyyyyMMdd:(NSString *)totalSeconds
{
    NSTimeInterval time = [totalSeconds doubleValue];
    NSDate *detaildate = [NSDate dateWithTimeIntervalSince1970:time];
    
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    return currentDateStr;
    
}
#pragma mark 转换时间戳格式MM月dd日
+ (NSString *)timeFormattedToMMdd:(NSString *)totalSeconds
{
    NSTimeInterval time = [totalSeconds doubleValue];
    NSDate *detaildate = [NSDate dateWithTimeIntervalSince1970:time];
    
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"MM月dd日"];
    
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    return currentDateStr;
    
}

#pragma mark 转换时间戳格式HHmmss(从现在开始算起)
+ (NSString *)timeFormattedFromNowToHHmmss:(NSString *)totalSeconds
{
    NSTimeInterval time = [totalSeconds doubleValue];
    NSDate *detaildate = [NSDate dateWithTimeIntervalSinceNow:time];
    
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"HHmmss"];
    
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    
    return currentDateStr;
    
}
#pragma mark 转换时间戳判断是否今天
+ (NSString *)changeResultIntoTimestamp:(NSString *)timestamp{
    NSTimeInterval timeInterval_since = [timestamp doubleValue];
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:timeInterval_since];
    
    NSTimeInterval  timeInterval = [date timeIntervalSinceNow];
    timeInterval = -timeInterval;
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
        return result;
    }
    if((temp = timeInterval/60) <60){
        result =[NSString stringWithFormat:@"%ld分钟前",temp];
        return result;
    }
    
    if((temp = temp/60) <24){
        return result = [NSString stringWithFormat:@"%ld小时前",temp];
    }
    
//    NSTimeInterval time=[timestamp doubleValue];
//    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *currentDateStr = [dateFormatter stringFromDate: date];
    return currentDateStr;

}

- (NSString *)stringLocalizedStringFromNumber {
    if(![self isKindOfClass:[NSString class]]){
        return self;
    }
    float oldf = [self floatValue];
    long long oldll = [self longLongValue];
    float tmptf = oldf - oldll;
    NSString *currencyStr = nil;
    if(tmptf > 0){
        currencyStr = [NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithFloat:oldll]
                                                       numberStyle:NSNumberFormatterDecimalStyle];
    }else{
        currencyStr = [NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithLongLong:oldll]
                                                       numberStyle:NSNumberFormatterDecimalStyle];
    }
    return currencyStr;
}



+ (NSString *)translation:(NSString *)arebic
{
    if (!arebic.length) return @"三";
    
    NSString *str = arebic;
    NSArray *arabic_numerals = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0"];
    NSArray *chinese_numerals = @[@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"零"];
    NSArray *digits = @[@"个",@"十",@"百",@"千",@"万",@"十",@"百",@"千",@"亿",@"十",@"百",@"千",@"兆"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:chinese_numerals forKeys:arabic_numerals];
    
    NSMutableArray *sums = [NSMutableArray array];
    for (int i = 0; i < str.length; i ++) {
        NSString *substr = [str substringWithRange:NSMakeRange(i, 1)];
        NSString *a = [dictionary objectForKey:substr];
        NSString *b = digits[str.length -i-1];
        NSString *sum = [a stringByAppendingString:b];
        if ([a isEqualToString:chinese_numerals[9]])
        {
            if([b isEqualToString:digits[4]] || [b isEqualToString:digits[8]])
            {
                sum = b;
                if ([[sums lastObject] isEqualToString:chinese_numerals[9]])
                {
                    [sums removeLastObject];
                }
            }else
            {
                sum = chinese_numerals[9];
            }
            
            if ([[sums lastObject] isEqualToString:sum])
            {
                continue;
            }
        }
        
        [sums addObject:sum];
    }
    
    NSString *sumStr = [sums  componentsJoinedByString:@""];
    NSString *chinese = [sumStr substringToIndex:sumStr.length-1];
    
    return chinese;
}
#pragma mark 把字典和数组转换成json字符串
+(NSString *)stringTOjson:(id)temps
{
    NSData* jsonData =[NSJSONSerialization dataWithJSONObject:temps options:NSJSONWritingPrettyPrinted error:nil];
    NSString *strs=[[NSString alloc] initWithData:jsonData
                                         encoding:NSUTF8StringEncoding];
    return strs;
}
#pragma mark 把字典和数组转换成kNilOptions格式json字符串
+(NSString *)stringTOkNilOptionsjson:(id)temps
{
    NSData* jsonData =[NSJSONSerialization dataWithJSONObject:temps options:kNilOptions error:nil];
    NSString *strs=[[NSString alloc] initWithData:jsonData
                                         encoding:NSUTF8StringEncoding];
    return strs;
}
@end
