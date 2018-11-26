//
//  MDMAPIMemoryCache.m
//  MDMAPIManager
//
//  Created by mademao on 2018/11/26.
//  Copyright © 2018 mademao. All rights reserved.
//

#import "MDMAPIMemoryCache.h"

@interface MDMAPIMemoryCache ()

@property (nonatomic, strong) NSCache<NSString *, MDMAPICacheObject *> *cache;

@end

@implementation MDMAPIMemoryCache

- (void)saveResponse:(NSURLResponse *)response
      responseObject:(id)responseObject
                 key:(NSString *)key
           cacheTime:(NSTimeInterval)cacheTime
{
    if (response == nil || responseObject == nil || key == nil) {
        return;
    }
    
    MDMAPICacheObject *cacheObject = [[MDMAPICacheObject alloc] init];
    cacheObject.response = response;
    cacheObject.responseObject = responseObject;
    cacheObject.lastUpdateDate = [NSDate date];
    cacheObject.cacheTime = cacheTime;
    
    [self.cache setObject:cacheObject forKey:key];
}

- (MDMAPICacheObject *)getCacheObjectWithKey:(NSString *)key
{
    if (key == nil) {
        return nil;
    }
    
    MDMAPICacheObject *cacheObject = nil;
    cacheObject = [self.cache objectForKey:key];
    
    if (cacheObject &&
        cacheObject.cacheTime != 0.0 &&
        [[NSDate date] timeIntervalSinceDate:cacheObject.lastUpdateDate] > cacheObject.cacheTime) {
        [self.cache removeObjectForKey:key];
        cacheObject = nil;
    }
    
    return cacheObject;
}

- (void)cleanAll
{
    [self.cache removeAllObjects];
}


#pragma mark - lazy load

- (NSCache<NSString *, MDMAPICacheObject *> *)cache
{
    if (!_cache) {
        _cache = [[NSCache alloc] init];
    }
    return _cache;
}

@end
