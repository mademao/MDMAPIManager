//
//  MDMAPIDiskCache.m
//  MDMAPIManager
//
//  Created by mademao on 2018/11/26.
//  Copyright © 2018 mademao. All rights reserved.
//

#import "MDMAPIDiskCache.h"
#include <CommonCrypto/CommonCrypto.h>

NSString * _mdm_md5String(NSString *string)
{
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(data.bytes, (CC_LONG)data.length, result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

@implementation MDMAPIDiskCache

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
    
    [NSKeyedArchiver archiveRootObject:cacheObject toFile:[[self cachePath] stringByAppendingPathComponent:_mdm_md5String(key)]];
}

- (MDMAPICacheObject *)getCacheObjectWithKey:(NSString *)key
{
    if (key == nil) {
        return nil;
    }
    
    MDMAPICacheObject *cacheObject = nil;
    cacheObject = [NSKeyedUnarchiver unarchiveObjectWithFile:[[self cachePath] stringByAppendingPathComponent:_mdm_md5String(key)]];
    
    if (cacheObject &&
        cacheObject.cacheTime != 0.0 &&
        [[NSDate date] timeIntervalSinceDate:cacheObject.lastUpdateDate] > cacheObject.cacheTime) {
        NSFileManager *manager = [NSFileManager defaultManager];
        [manager removeItemAtPath:[[self cachePath] stringByAppendingPathComponent:key] error:nil];
        cacheObject = nil;
    }
    
    return cacheObject;
}

- (void)cleanAll
{
    NSFileManager *manager = [NSFileManager defaultManager];
    [manager removeItemAtPath:[self cachePath] error:nil];
}

///获取缓存位置
- (NSString *)cachePath
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    path = [path stringByAppendingPathComponent:@"MDMAPICache"];
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:path]) {
        [manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return path;
}

@end
