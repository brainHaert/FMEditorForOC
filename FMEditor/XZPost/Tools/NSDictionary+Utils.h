//
//  NSDictionary+Utils.h
//
//  Created by xuhui on 13-1-20.
//
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Utils)
///从字典里取NSInteger(内带判空)
- (NSInteger)integerValueForKey:(id)key;
///从字典里取int(内带判空)
- (int)intValueForKey:(id)key;
///从字典里取BOOL(内带判空)
- (BOOL)boolValueForKey:(id)key;
///从字典里取float(内带判空)
- (float)floatValueForKey:(id)key;
///从字典里取字符串(内带判空)
- (NSString *)stringValueForKey:(id)key;
///从字典里取数组(内带判空)
- (NSArray *)arrayValueForKey:(id)key;
///从字典里取可变数组(内带判空)
- (NSMutableArray*)mutableArrayValueForKey:(NSString *)key;
///从字典里取字典(内带判空)
- (NSDictionary *)dictionaryValueForKey:(id)key;


- (NSDictionary* )parseHTML;
- (NSDictionary *)urlEncoded;

///把格式化的JSON格式的字符串转换成字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

@end
