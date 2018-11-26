//
//  MDMAPIFormDataNormalItem.h
//  MDMAPIManager
//
//  Created by mademao on 2018/11/26.
//  Copyright © 2018 mademao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 表单数据中的普通键值对参数
 */
@interface MDMAPIFormDataNormalItem : NSObject

///参数名
@property (nonatomic, copy) NSString *key;
///参数值
@property (nonatomic, copy) NSString *value;

- (instancetype)initWithKey:(NSString *)key value:(NSString *)value;
+ (instancetype)normalItemWithKey:(NSString *)key value:(NSString *)value;

@end

NS_ASSUME_NONNULL_END
