//
//  MDMAPIBaseManager.h
//  MDMAPIManager
//
//  Created by mademao on 2018/11/30.
//  Copyright © 2018 mademao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDMAPIManagerCallBackDelegate.h"
#import "MDMAPIManagerProtocol.h"
#import "MDMAPIManagerDefines.h"
#import "MDMAPIFormData.h"

NS_ASSUME_NONNULL_BEGIN

/**
 所有API请求的父类
 
 创建一个新的API请求时，需要继承该类，同时需要遵循 MDMAPIManagerProtocol 协议
 */
@interface MDMAPIBaseManager : NSObject

///请求结果回调代理
@property (nonatomic, weak) id<MDMAPIManagerCallBackDelegate> delegate;


///在正式请求之前，是否需要去检查缓存，若检查有缓存，则不开始请求。默认NO，不检查
@property (nonatomic, assign) BOOL shouldCheckCacheBeginRequest;
///是否需要忽略全局request插件，默认NO，不忽略
@property (nonatomic, assign) BOOL shouldIgnoreRequestPlugin;
///是否需要忽略全局response插件，默认NO，不忽略
@property (nonatomic, assign) BOOL shouldIgnoreResponsePlugin;


///请求结果的缓存策略，默认为MDMAPICachePolicyNoCache，不进行缓存
@property (nonatomic, assign) MDMAPICachePolicy cachePolicy;
///请求结果缓存时的key值，默认使用MDMAPIManagerProtocol协议中 `requestURL` 返回值
@property (nonatomic, copy) NSString *cacheKey;
///请求缓存在memory缓存中的有效时间，0表示永久缓存，默认为0
@property (nonatomic, assign) NSTimeInterval memoryCacheSecond;
///请求缓存在disk缓存中的有效时间，0表示永久缓存，默认为0
@property (nonatomic, assign) NSTimeInterval diskCacheSecond;

/**
 发起请求
 
 @param params 发起请求时的参数
 
 @return 该次请求对应的唯一标志
 */
- (NSInteger)doRequestWithParams:(nullable NSDictionary *)params;

/**
 发起请求
 
 @param params 发起请求时的参数
 @param block 用于拼接多表单参数的回调
 
 @return 该次请求对应的唯一标志
 */
- (NSInteger)doRequestWithParams:(nullable NSDictionary *)params bulidFormDataBlock:(nullable void(^)(MDMAPIFormData *formData))block;

/**
 取消请求
 
 @param requestID 需要取消的请求标志
 */
- (void)cancelRequestWithRequestID:(NSInteger)requestID;

/**
 取消所发起的所有请求
 */
- (void)cancelAllRequest;

@end

NS_ASSUME_NONNULL_END
