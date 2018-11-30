//
//  MDMAPIManagerCallBackDelegate.h
//  MDMAPIManager
//
//  Created by mademao on 2018/11/30.
//  Copyright © 2018 mademao. All rights reserved.
//

#ifndef MDMAPIManagerCallBackDelegate_h
#define MDMAPIManagerCallBackDelegate_h

#import "MDMAPIManagerDefines.h"
#import "MDMAPIManagerProtocol.h"

@class MDMAPIBaseManager;

/**
 MDMAPIManager请求完成回调代理
 */
@protocol MDMAPIManagerCallBackDelegate <NSObject>

@optional

/**
 请求成功回调
 
 @param apiManager 对应发起请求的manager
 @param responseObject 对应处理之后的返回结果
 */
- (void)callAPISuccessWithAPIManager:(MDMAPIBaseManager<MDMAPIManagerProtocol> *)apiManager
                      responseObject:(id)responseObject;

/**
 请求失败回调
 
 @param apiManager 对应发起请求的manager
 @param cacheObject 请求失败时返回缓存的数据
 @param resultType 对应失败类型
 @param info 附加信息
 */
- (void)callAPIFailWithAPIManager:(MDMAPIBaseManager<MDMAPIManagerProtocol> *)apiManager
                      cacheObject:(id)cacheObject
                       resultType:(MDMAPIResultType)resultType
                             info:(NSDictionary *)info;

@end

#endif /* MDMAPIManagerCallBackDelegate_h */
