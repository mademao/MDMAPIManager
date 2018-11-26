//
//  MDMAPIDiskCache.h
//  MDMAPIManager
//
//  Created by mademao on 2018/11/26.
//  Copyright © 2018 mademao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDMAPICacheObject.h"

NS_ASSUME_NONNULL_BEGIN

/**
 磁盘缓存
 */
@interface MDMAPIDiskCache : NSObject

/**
 缓存数据
 
 @param response 需要缓存的response
 @param responseObject 需要缓存的responseObject
 @param key 缓存的key值
 @param cacheTime 缓存有效时间
 */
- (void)saveResponse:(NSURLResponse *)response
      responseObject:(id)responseObject
                 key:(NSString *)key
           cacheTime:(NSTimeInterval)cacheTime;

/**
 获取缓存数据
 
 @param key 获取缓存数据的key值
 
 @return 获取到缓存的数据
 */
- (nullable MDMAPICacheObject *)getCacheObjectWithKey:(NSString *)key;

/**
 清空所有缓存数据
 */
- (void)cleanAll;

@end

NS_ASSUME_NONNULL_END
