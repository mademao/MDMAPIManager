//
//  MDMAPICacheObject.m
//  MDMAPIManager
//
//  Created by mademao on 2018/11/26.
//  Copyright © 2018 mademao. All rights reserved.
//

#import "MDMAPICacheObject.h"

@implementation MDMAPICacheObject


#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        NSURLResponse *response = [aDecoder decodeObjectForKey:@"response"];
        id responseObject = [aDecoder decodeObjectForKey:@"responseObject"];
        NSDate *lastUpdateDate = [aDecoder decodeObjectForKey:@"date"];
        NSNumber *cacheTime = [aDecoder decodeObjectForKey:@"cacheTime"];
        if (response == nil || responseObject == nil ||
            lastUpdateDate == nil || cacheTime == nil) {
            return nil;
        }
        self.response = response;
        self.responseObject = responseObject;
        self.lastUpdateDate = lastUpdateDate;
        self.cacheTime = [cacheTime doubleValue];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    @try {
        [aCoder encodeObject:self.response forKey:@"response"];
        [aCoder encodeObject:self.responseObject forKey:@"responseObject"];
        [aCoder encodeObject:self.lastUpdateDate forKey:@"date"];
        [aCoder encodeObject:@(self.cacheTime) forKey:@"cacheTime"];
    } @catch (NSException *exception) {
        NSLog(@"MDMAPICacheObject encode error");
    }
}

@end
