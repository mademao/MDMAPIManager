//
//  MDMAPIFormDataNormalItem.m
//  MDMAPIManager
//
//  Created by mademao on 2018/11/26.
//  Copyright © 2018 mademao. All rights reserved.
//

#import "MDMAPIFormDataNormalItem.h"

@implementation MDMAPIFormDataNormalItem

- (instancetype)initWithKey:(NSString *)key value:(NSString *)value
{
    if (self = [super init]) {
        self.key = key;
        self.value = value;
    }
    return self;
}

+ (instancetype)normalItemWithKey:(NSString *)key value:(NSString *)value
{
    return [[self alloc] initWithKey:key value:value];
}

@end
