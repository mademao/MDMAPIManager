//
//  MDMAPIBaseManager.m
//  MDMAPIManager
//
//  Created by mademao on 2018/11/30.
//  Copyright © 2018 mademao. All rights reserved.
//

#import "MDMAPIBaseManager.h"
#import "MDMAPIRequestGenerator.h"
#import "MDMAPIRequestManager.h"
#import "MDMAPIRequestPluginManager.h"
#import "MDMAPIResponsePluginManager.h"
#import "MDMAPICache.h"

@interface MDMAPIBaseManager ()

///持有子类本身，用于强制子类实现某些方法
@property (nonatomic, weak) id<MDMAPIManagerProtocol> child;

///所有发起的请求
@property (nonatomic, strong) NSMutableArray<NSNumber *> *requestIDList;

@end

@implementation MDMAPIBaseManager

#pragma mark - init

- (instancetype)init
{
    if (self = [super init]) {
        if ([self isMemberOfClass:[MDMAPIBaseManager class]]) {
            return self;
        }
        
        _delegate = nil;
        _shouldCheckCacheBeginRequest = NO;
        _shouldIgnoreRequestPlugin = NO;
        _shouldIgnoreResponsePlugin = NO;
        
        _cachePolicy = MDMAPICachePolicyNoCache;
        _memoryCacheSecond = 0.0;
        _diskCacheSecond = 0.0;
        
        //检查子类是否遵循MDMAPIManagerProtocol协议
        if ([self conformsToProtocol:@protocol(MDMAPIManagerProtocol)] &&
            [self respondsToSelector:@selector(apiType)] &&
            [self respondsToSelector:@selector(requestURL)] &&
            [self respondsToSelector:@selector(analyzeResponse:responseObject:)]) {
            self.child = (id<MDMAPIManagerProtocol>)self;
            self.cacheKey = [self.child requestURL];
        } else {
            NSException *exception = [[NSException alloc] initWithName:@"MDMAPIBaseManager子类初始化失败"
                                                                reason:@"MDMAPIBaseManager子类没有遵循MDMAPIManagerProtocol协议或没有实现对应方法"
                                                              userInfo:nil];
            @throw exception;
        }
    }
    return self;
}

- (void)dealloc
{
    [self cancelAllRequest];
}


#pragma mark - public method

///发起请求
- (NSInteger)doRequestWithParams:(NSDictionary *)params
{
    return [self startRequestWithWithParams:params bulidFormDataBlock:nil];
}

///发起请求
- (NSInteger)doRequestWithParams:(NSDictionary *)params bulidFormDataBlock:(void(^)(MDMAPIFormData *formData))block
{
    return [self startRequestWithWithParams:params bulidFormDataBlock:block];
}

///取消请求
- (void)cancelRequestWithRequestID:(NSInteger)requestID
{
    if ([self.requestIDList containsObject:@(requestID)]) {
        [self.requestIDList removeObject:@(requestID)];
        [MDMAPIRequestManager cancelRequestWithRequestID:@(requestID)];
    }
}

///取消所发起的所有请求
- (void)cancelAllRequest
{
    [MDMAPIRequestManager cancelRequestWithRequestIDList:self.requestIDList];
    [self.requestIDList removeAllObjects];
}


#pragma mark - private method

///根据传入的参数开启一个请求
- (NSInteger)startRequestWithWithParams:(NSDictionary *)params bulidFormDataBlock:(void(^)(MDMAPIFormData *formData))block
{
    //处理在有缓存情况下不进行网络请求的设置
    if (self.shouldCheckCacheBeginRequest == YES) {
        id cacheObject = [self handleCacheObject];
        
        if (cacheObject) {
            [self requestSuccessWithResponseObject:cacheObject];
            return 0;
        }
    }
    
    //处理多表单数据
    MDMAPIFormData *formData = nil;
    if (block) {
        formData = [[MDMAPIFormData alloc] init];
        block(formData);
    }
    
    //构建request对象
    NSURLRequest *request = [MDMAPIRequestGenerator requestWithAPIType:[self.child apiType]
                                                                   url:[self.child requestURL]
                                                                params:params
                                                              formData:formData];
    
    //插件处理request对象
    if (!self.shouldIgnoreRequestPlugin) {
        request = [self reformRequestByPlugin:request];
    }
    
    //自定义处理request对象
    if ([self.child respondsToSelector:@selector(reformRequest:)]) {
        request = [self.child reformRequest:request];
    }
    
    //发起请求
    __block NSNumber *requestID = [NSNumber numberWithInteger:0];
    requestID = [MDMAPIRequestManager sendRequest:request success:^(NSURLResponse * _Nonnull response, id  _Nonnull responseObject) {
        [self removeRequestID:requestID];
        [self handleSuccessResponse:response responseObject:responseObject];
    } fail:^(NSURLResponse * _Nonnull response, NSError * _Nonnull error) {
        [self removeRequestID:requestID];
        [self handleFailResponse:response error:error];
    }];
    
    return [requestID integerValue];
}

///插件化处理request对象
- (NSURLRequest *)reformRequestByPlugin:(NSURLRequest *)request
{
    NSURLRequest *tmpRequest = request;
    for (id<MDMAPIRequestReformProtocol> plugin in [MDMAPIRequestPluginManager getAllRequestPlugin]) {
        if ([plugin conformsToProtocol:@protocol(MDMAPIRequestReformProtocol)] &&
            [plugin respondsToSelector:@selector(requestPlugin:reformRequest:apiManager:)]) {
            tmpRequest = [plugin requestPlugin:plugin reformRequest:tmpRequest apiManager:self.child];
        }
    }
    return [tmpRequest copy];
}


#pragma mark 请求成功

///处理接口返回的数据
- (void)handleSuccessResponse:(NSURLResponse *)response responseObject:(id)responseObject
{
    MDMAPIResultType resultType = MDMAPIResultTypeSuccess;
    NSMutableDictionary *reformInfo = [NSMutableDictionary dictionary];
    
    id needReformResponseObject = responseObject;
    
    needReformResponseObject = [self handleResponse:response
                                     responseObject:needReformResponseObject
                                         resultType:&resultType
                                               info:&reformInfo];
    
    if (resultType != MDMAPIResultTypeSuccess) {
        [self requestFailWithResultType:resultType info:[reformInfo copy]];
        return;
    }
    
    //缓存responseObject
    if (self.cachePolicy != MDMAPICachePolicyNoCache) {
        [[MDMAPICache sharedInstance] saveResponse:response
                                    responseObject:responseObject
                                               key:self.cacheKey
                                   memoryCacheTime:self.memoryCacheSecond
                                     diskCacheTime:self.diskCacheSecond
                                       cachePolicy:self.cachePolicy];
    }
    
    [self requestSuccessWithResponseObject:needReformResponseObject];
}

///处理response和responseObject对象
- (id)handleResponse:(NSURLResponse *)response responseObject:(id)responseObject resultType:(MDMAPIResultType *)resultType info:(NSMutableDictionary **)info
{
    id resultResponseObject = responseObject;
    
    //插件处理responseObject对象
    if (!self.shouldIgnoreResponsePlugin) {
        resultResponseObject = [self reformResponseObjectByPlugin:resultResponseObject response:response resultType:resultType info:info];
        
        if (*resultType != MDMAPIResultTypeSuccess) {
            return resultResponseObject;
        }
    }
    
    //自定义处理responseObject对象
    if ([self.child respondsToSelector:@selector(reformResponseObject:response:resultType:info:)]) {
        id tmpResponseObject = resultResponseObject;
        tmpResponseObject = [self.child reformResponseObject:tmpResponseObject response:response resultType:resultType info:info];
        if (*resultType == MDMAPIResultTypeSuccess) {
            resultResponseObject = tmpResponseObject;
        } else {
            return resultResponseObject;
        }
    }
    
    //解析数据
    resultResponseObject = [self.child analyzeResponse:response responseObject:resultResponseObject];
    
    return resultResponseObject;
}

///插件化处理responseObject对象
- (id)reformResponseObjectByPlugin:(id)responseObject response:(NSURLResponse *)response resultType:(MDMAPIResultType *)resultType info:(NSMutableDictionary **)info
{
    id tmpResponseObject = responseObject;
    for (id<MDMAPIResponseReformProtocol> plugin in [MDMAPIResponsePluginManager getAllResponsePlugin]) {
        if ([plugin conformsToProtocol:@protocol(MDMAPIResponseReformProtocol)] &&
            [plugin respondsToSelector:@selector(responsePlugin:reformResponseObject:response:apiManager:resultType:info:)]) {
            id reformResponseObject = [plugin responsePlugin:plugin
                                        reformResponseObject:tmpResponseObject
                                                    response:response
                                                  apiManager:self.child
                                                  resultType:resultType
                                                        info:info];
            if (*resultType == MDMAPIResultTypeSuccess) {
                tmpResponseObject = reformResponseObject;
            } else {
                break;
            }
        }
    }
    return tmpResponseObject;
}

///发起request成功
- (void)requestSuccessWithResponseObject:(id)responseObject
{
    if ([self.delegate conformsToProtocol:@protocol(MDMAPIManagerCallBackDelegate)] &&
        [self.delegate respondsToSelector:@selector(callAPISuccessWithAPIManager:responseObject:)]) {
        [self.delegate callAPISuccessWithAPIManager:self.child responseObject:responseObject];
    }
}


#pragma mark 请求失败

///处理请求失败情况
- (void)handleFailResponse:(NSURLResponse *)response error:(NSError *)error
{
    MDMAPIResultType type = MDMAPIResultTypeServerBad;
    //网络检测
    [self requestFailWithResultType:type info:nil];
}

///发起request失败
- (void)requestFailWithResultType:(MDMAPIResultType)resultType info:(NSDictionary *)info
{
    if ([self.delegate conformsToProtocol:@protocol(MDMAPIManagerCallBackDelegate)] &&
        [self.delegate respondsToSelector:@selector(callAPIFailWithAPIManager:cacheObject:resultType:info:)]) {
        
        //获取缓存数据
        id resultCacheObject = [self handleCacheObject];
        
        [self.delegate callAPIFailWithAPIManager:self.child cacheObject:resultCacheObject resultType:resultType info:info];
    }
}


#pragma mark 工具方法

///获取缓存的数据并进行处理
- (id)handleCacheObject
{
    id handleCacheObject = nil;
    MDMAPICacheObject *cacheObject = [[MDMAPICache sharedInstance] getCacheObjectWithKey:self.cacheKey cachePolicy:self.cachePolicy];
    if (cacheObject) {
        MDMAPIResultType nouseResultType = MDMAPIResultTypeSuccess;
        NSMutableDictionary *nouseInfo = [NSMutableDictionary dictionary];
        handleCacheObject = [self handleResponse:cacheObject.response responseObject:cacheObject.responseObject resultType:&nouseResultType info:&nouseInfo];
    }
    
    return handleCacheObject;
}

///移除请求
- (void)removeRequestID:(NSNumber *)requestID
{
    if ([self.requestIDList containsObject:requestID]) {
        [self.requestIDList removeObject:requestID];
    }
}


#pragma mark - lazy load

- (NSMutableArray<NSNumber *> *)requestIDList
{
    if (!_requestIDList) {
        _requestIDList = [NSMutableArray array];
    }
    return _requestIDList;
}

@end
