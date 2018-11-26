//
//  MDMAPIFormDataFileItem.m
//  MDMAPIManager
//
//  Created by mademao on 2018/11/26.
//  Copyright © 2018 mademao. All rights reserved.
//

#import "MDMAPIFormDataFileItem.h"

@implementation MDMAPIFormDataFileItem

- (instancetype)initWithKey:(NSString *)key fileData:(NSData *)fileData fileName:(NSString *)fileName mimeType:(NSString *)mimeType
{
    if (self = [super init]) {
        self.key = key;
        self.fileData = fileData;
        self.fileName = fileName;
        self.mimeType = mimeType;
    }
    return self;
}

+ (instancetype)fileItemWithKey:(NSString *)key fileData:(NSData *)fileData fileName:(NSString *)fileName mimeType:(NSString *)mimeType
{
    return [[self alloc] initWithKey:key fileData:fileData fileName:fileName mimeType:mimeType];
}

@end
