//
//  MDMAPICache.m
//  MDMAPIManager
//
//  Created by mademao on 2018/11/26.
//  Copyright © 2018 mademao. All rights reserved.
//

#import "MDMAPICache.h"
#import "MDMAPIMemoryCache.h"
#import "MDMAPIDiskCache.h"

@interface MDMAPICache ()

@property (nonatomic, strong) MDMAPIMemoryCache *memoryCache;

@property (nonatomic, strong) MDMAPIDiskCache *diskCache;

@end

@implementation MDMAPICache

+ (instancetype)sharedInstance
{
    static MDMAPICache *cache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cache = [[MDMAPICache alloc] init];
    });
    return cache;
}

- (void)saveResponse:(NSURLResponse *)response
      responseObject:(id)responseObject
                 key:(NSString *)key
     memoryCacheTime:(NSTimeInterval)memoryCacheTime
       diskCacheTime:(NSTimeInterval)diskCacheTime
         cachePolicy:(MDMAPICachePolicy)cachePolicy
{
    if (cachePolicy & MDMAPICachePolicyMemory) {
        [self.memoryCache saveResponse:response responseObject:responseObject key:key cacheTime:memoryCacheTime];
    }
    
    if (cachePolicy & MDMAPICachePolicyDisk) {
        [self.diskCache saveResponse:response responseObject:responseObject key:key cacheTime:diskCacheTime];
    }
}

- (nullable MDMAPICacheObject *)getCacheObjectWithKey:(NSString *)key
                                          cachePolicy:(MDMAPICachePolicy)cachePolicy
{
    MDMAPICacheObject *cacheObject = nil;
    
    if (cachePolicy & MDMAPICachePolicyMemory) {
        cacheObject = [self.memoryCache getCacheObjectWithKey:key];
        
        if (cacheObject) {
            return cacheObject;
        }
    }
    
    if (cachePolicy & MDMAPICachePolicyDisk) {
        cacheObject = [self.diskCache getCacheObjectWithKey:key];
        
        if (cacheObject) {
            return cacheObject;
        }
    }
    
    return cacheObject;
}

/**
 清空所有内存缓存数据
 */
- (void)cleanAllMemoryCache
{
    [_memoryCache cleanAll];
}

/**
 清空所有磁盘缓存数据
 */
- (void)cleanAllDiskCache
{
    [self.diskCache cleanAll];
}


#pragma mark - lazy load

- (MDMAPIMemoryCache *)memoryCache
{
    if (!_memoryCache) {
        _memoryCache = [[MDMAPIMemoryCache alloc] init];
    }
    return _memoryCache;
}

- (MDMAPIDiskCache *)diskCache
{
    if (!_diskCache) {
        _diskCache = [[MDMAPIDiskCache alloc] init];
    }
    return _diskCache;
}

@end
