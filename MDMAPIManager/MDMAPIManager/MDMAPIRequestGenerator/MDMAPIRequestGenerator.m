//
//  MDMAPIRequestGenerator.m
//  MDMAPIManager
//
//  Created by mademao on 2018/11/26.
//  Copyright © 2018 mademao. All rights reserved.
//

#import "MDMAPIRequestGenerator.h"
#import <AFNetworking/AFURLRequestSerialization.h>

@interface MDMAPIRequestGenerator ()

@property (nonatomic, strong) AFHTTPRequestSerializer *requestSerializer;

@end

@implementation MDMAPIRequestGenerator

///构造一个request
+ (NSURLRequest *)requestWithAPIType:(MDMAPIType)apiType
                                 url:(NSString *)url
                              params:(NSDictionary *)params
                            formData:(MDMAPIFormData *)formData
{
    return [[self sharedInstance] requestWithAPIType:apiType url:url params:params formData:formData];
}


#pragma mark - private method

+ (instancetype)sharedInstance
{
    static MDMAPIRequestGenerator *generator = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        generator = [[MDMAPIRequestGenerator alloc] init];
    });
    return generator;
}

///构造一个request
- (NSURLRequest *)requestWithAPIType:(MDMAPIType)apiType
                                 url:(NSString *)url
                              params:(NSDictionary *)params
                            formData:(MDMAPIFormData *)formData
{
    if (apiType == MDMAPITypePOST) {
        if (formData) {
            return [self.requestSerializer multipartFormRequestWithMethod:@"POST" URLString:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull afFormData) {
                for (MDMAPIFormDataNormalItem *normalItem in formData.normalItemArray) {
                    [afFormData appendPartWithFormData:[normalItem.value dataUsingEncoding:NSUTF8StringEncoding] name:normalItem.key];
                }
                for (MDMAPIFormDataFileItem *fileItem in formData.fileItemArray) {
                    [afFormData appendPartWithFileData:fileItem.fileData name:fileItem.key fileName:fileItem.fileName mimeType:fileItem.mimeType];
                }
            } error:nil];
        } else {
            return [self.requestSerializer requestWithMethod:@"POST" URLString:url parameters:params error:nil];
        }
    }
    
    return [self.requestSerializer requestWithMethod:@"GET" URLString:url parameters:params error:nil];
}


#pragma mark - lazy load

- (AFHTTPRequestSerializer *)requestSerializer
{
    if (!_requestSerializer) {
        _requestSerializer = [[AFHTTPRequestSerializer alloc] init];
    }
    return _requestSerializer;
}

@end
