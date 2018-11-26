//
//  MDMAPICache.h
//  MDMAPIManager
//
//  Created by mademao on 2018/11/26.
//  Copyright © 2018 mademao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDMAPICacheObject.h"
#import "MDMAPIManagerDefines.h"

NS_ASSUME_NONNULL_BEGIN

/**
 API缓存
 */
@interface MDMAPICache : NSObject

+ (instancetype)sharedInstance;

/**
 缓存数据
 
 @param response 需要缓存的response
 @param responseObject 需要缓存的responseObject
 @param key 缓存的key值
 @param memoryCacheTime 内存缓存有效时间
 @param diskCacheTime 磁盘缓存有效时间
 @param cachePolicy 缓存策略
 */
- (void)saveResponse:(NSURLResponse *)response
      responseObject:(id)responseObject
                 key:(NSString *)key
     memoryCacheTime:(NSTimeInterval)memoryCacheTime
       diskCacheTime:(NSTimeInterval)diskCacheTime
         cachePolicy:(MDMAPICachePolicy)cachePolicy;

/**
 获取缓存数据
 
 @param key 获取缓存数据的key值
 @param cachePolicy 缓存策略
 
 @return 获取到缓存的数据
 */
- (nullable MDMAPICacheObject *)getCacheObjectWithKey:(NSString *)key
                                          cachePolicy:(MDMAPICachePolicy)cachePolicy;

/**
 清空所有内存缓存数据
 */
- (void)cleanAllMemoryCache;

/**
 清空所有磁盘缓存数据
 */
- (void)cleanAllDiskCache;

@end

NS_ASSUME_NONNULL_END
