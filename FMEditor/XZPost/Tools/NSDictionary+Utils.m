//
//  NSDictionary+Utils.m
//
//  Created by xuhui on 13-1-20.
//
//

#import "NSDictionary+Utils.h"


@implementation NSDictionary (Utils)
#pragma mark 从字典里取integer
- (NSInteger)integerValueForKey:(id)key {
    id value = [self notNullValueForKey:key];
    return value == nil ? 0 : [value integerValue];
}
#pragma mark 从字典里取int
- (int)intValueForKey:(id)key {
    id value = [self notNullValueForKey:key];
    return value == nil ? 0 : [value intValue];
}
#pragma mark 从字典里取BOOL
- (BOOL)boolValueForKey:(id)key {
    id value = [self notNullValueForKey:key];
    return value == nil ? NO : [value boolValue];
}
#pragma mark 从字典里取float
- (float)floatValueForKey:(id)key {
    id value = [self notNullValueForKey:key];
    return value == nil ? NO : [value floatValue];
}
#pragma mark 从字典里取字符串
- (NSString *)stringValueForKey:(id)key {
    return [self notNullValueForKey:key];
}
#pragma mark 从字典里取数组
- (NSArray *)arrayValueForKey:(id)key {
    id value = [self notNullValueForKey:key];
    if(![value isKindOfClass:[NSArray class]]) {
        return nil;
    }
    return value;
}
#pragma mark 从字典里取可变数组
- (NSMutableArray*)mutableArrayValueForKey:(NSString *)key {
    id value = [self notNullValueForKey:key];
    if(![value isKindOfClass:[NSMutableArray class]]) {
        return nil;
    }
    return value;
}
#pragma mark 从字典里取字典
- (NSDictionary *)dictionaryValueForKey:(id)key {
    id value = [self notNullValueForKey:key];
    if(![value isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    return value;
}
#pragma mark 判断是否null
- (BOOL)isNullValue:(id)value {
    return [value isEqual:[NSNull null]];
}

- (id)notNullValueForKey:(id)key {
    id value = [self objectForKey:key];
    if([self isNullValue:value]) {
        return nil;
    }
    return value;
}

- (NSDictionary* )parseHTML {
    NSMutableDictionary* resultDic = [[NSMutableDictionary alloc] init];
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if([obj respondsToSelector:@selector(parseHTML)]) {
            id obj2 = [obj parseHTML];
            [resultDic setObject:obj2 forKey:key];
        } else {
            [resultDic setObject:obj forKey:key];
        }
    }];
    return resultDic;
}

- (NSDictionary *)urlEncoded {
    NSMutableDictionary* resultDic = [[NSMutableDictionary alloc] init];
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if([obj respondsToSelector:@selector(urlEncoded)]) {
            [resultDic setObject:[obj urlEncoded] forKey:key];
        } else {
            [resultDic setObject:obj forKey:key];
        }
    }];
    return resultDic;
}
/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
@end
