//
//  MDMAPIRequestManager.h
//  MDMAPIManager
//
//  Created by mademao on 2018/11/30.
//  Copyright © 2018 mademao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

///MDMAPIRequestManager请求成功回调
typedef void(^MDMAPIRequestSuccess)(NSURLResponse *response, id responseObject);
///MDMAPIRequestManager请求失败回调
typedef void(^MDMAPIRequestFail)(NSURLResponse *response, NSError *error);

/**
 用来发起请求并管理请求的类
 */
@interface MDMAPIRequestManager : NSObject

/**
 发起一个request请求
 
 @param request 需要发起的request请求
 @param success 请求成功回调
 @param fail 请求失败回调
 
 @return 发起请求对应的唯一标志
 */
+ (NSNumber *)sendRequest:(NSURLRequest *)request success:(MDMAPIRequestSuccess)success fail:(MDMAPIRequestFail)fail;

/**
 取消一个请求
 
 @param requestID 需要取消的请求对应的唯一标志
 */
+ (void)cancelRequestWithRequestID:(NSNumber *)requestID;

/**
 取消一组请求
 
 @param requestIDList 需要取消的一组请求对应的唯一标志
 */
+ (void)cancelRequestWithRequestIDList:(NSArray<NSNumber *> *)requestIDList;

@end

NS_ASSUME_NONNULL_END
