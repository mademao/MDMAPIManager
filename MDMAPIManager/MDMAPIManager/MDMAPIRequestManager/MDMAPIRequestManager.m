//
//  MDMAPIRequestManager.m
//  MDMAPIManager
//
//  Created by mademao on 2018/11/30.
//  Copyright © 2018 mademao. All rights reserved.
//

#import "MDMAPIRequestManager.h"
#import <AFNetworking/AFNetworking.h>

@interface MDMAPIRequestManager ()

///AFNetworking的manager
@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

///保存发起的请求
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, NSURLSessionDataTask *> *requestTable;

@end

@implementation MDMAPIRequestManager

#pragma mark - pubilc method

///发起一个request请求
+ (NSNumber *)sendRequest:(NSURLRequest *)request success:(MDMAPIRequestSuccess)success fail:(MDMAPIRequestFail)fail
{
    return [[MDMAPIRequestManager sharedInstance] sendRequest:request success:success fail:fail];
}

///取消一个请求
+ (void)cancelRequestWithRequestID:(NSNumber *)requestID
{
    [[MDMAPIRequestManager sharedInstance] cancelRequestWithRequestID:requestID];
}

///取消一组请求
+ (void)cancelRequestWithRequestIDList:(NSArray<NSNumber *> *)requestIDList
{
    [[MDMAPIRequestManager sharedInstance] cancelRequestWithRequestIDList:requestIDList];
}


#pragma mark - private method

+ (instancetype)sharedInstance
{
    static MDMAPIRequestManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[MDMAPIRequestManager alloc] init];
    });
    return manager;
}

///发起一个request请求
- (NSNumber *)sendRequest:(NSURLRequest *)request success:(MDMAPIRequestSuccess)success fail:(MDMAPIRequestFail)fail
{
    __weak typeof(self) weakSelf = self;
    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [self.sessionManager dataTaskWithRequest:request
                                         uploadProgress:nil
                                       downloadProgress:nil
                                      completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                                          NSNumber *requestID = @([dataTask taskIdentifier]);
                                          [weakSelf.requestTable removeObjectForKey:requestID];
                                          
                                          if (error) {
                                              fail ? fail(response, error) : nil;
                                          } else {
                                              success ? success(response, responseObject) : nil;
                                          }
                                      }];
    
    NSNumber *requestID = @([dataTask taskIdentifier]);
    [self.requestTable setObject:dataTask forKey:requestID];
    
    [dataTask resume];
    
    return requestID;
}

///取消一个请求
- (void)cancelRequestWithRequestID:(NSNumber *)requestID
{
    if ([self.requestTable.allKeys containsObject:requestID]) {
        NSURLSessionDataTask *dataTask = [self.requestTable objectForKey:requestID];
        [dataTask cancel];
        [self.requestTable removeObjectForKey:requestID];
    }
}

///取消一组请求
- (void)cancelRequestWithRequestIDList:(NSArray<NSNumber *> *)requestIDList
{
    for (NSNumber *requestID in requestIDList) {
        [self cancelRequestWithRequestID:requestID];
    }
}


#pragma mark - lazy load

- (AFHTTPSessionManager *)sessionManager
{
    if (!_sessionManager) {
        _sessionManager = [AFHTTPSessionManager manager];
        _sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    return _sessionManager;
}

- (NSMutableDictionary<NSNumber *,NSURLSessionDataTask *> *)requestTable
{
    if (!_requestTable) {
        _requestTable = [NSMutableDictionary dictionary];
    }
    return _requestTable;
}

@end
