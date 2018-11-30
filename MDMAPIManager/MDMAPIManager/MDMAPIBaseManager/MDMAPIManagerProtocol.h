//
//  MDMAPIManagerProtocol.h
//  MDMAPIManager
//
//  Created by mademao on 2018/11/30.
//  Copyright © 2018 mademao. All rights reserved.
//

#ifndef MDMAPIManagerProtocol_h
#define MDMAPIManagerProtocol_h

#import "MDMAPIManagerDefines.h"

@class MDMAPIBaseManager;

/**
 MDMAPIBaseManager子类必须遵循的协议
 */
@protocol MDMAPIManagerProtocol <NSObject>

@required

/**
 提供请求类型
 
 @return 请求类型
 */
- (MDMAPIType)apiType;

/**
 提供请求url
 
 @return 请求url
 */
- (NSString *)requestURL;

/**
 解析数据
 
 @param response 该次请求的response
 @param responseObject 经response插件及自定义reform处理后的数据
 
 @return 返回解析后的数据
 */
- (id)analyzeResponse:(NSURLResponse *)response responseObject:(id)responseObject;


@optional

/**
 对request进行修改
 
 @param request 原始request
 
 @return 修改后的request
 */
- (NSURLRequest *)reformRequest:(NSURLRequest *)request;

/**
 对response进行处理
 
 @param responseObject 原始返回数据
 @param response 返回的response
 @param resultType 处理结果，若处理失败，可直接修改该值
 @param info 处理结果附带信息，若处理失败，可直接将附带信息加入改值中
 
 @return 处理后的responseObject
 */
- (id)reformResponseObject:(id)responseObject
                  response:(NSURLResponse *)response
                resultType:(MDMAPIResultType *)resultType
                      info:(NSMutableDictionary **)info;

@end

#endif /* MDMAPIManagerProtocol_h */
