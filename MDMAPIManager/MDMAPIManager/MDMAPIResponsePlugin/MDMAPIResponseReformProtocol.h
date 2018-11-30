//
//  MDMAPIResponseReformProtocol.h
//  MDMAPIManager
//
//  Created by mademao on 2018/11/30.
//  Copyright © 2018 mademao. All rights reserved.
//

#ifndef MDMAPIResponseReformProtocol_h
#define MDMAPIResponseReformProtocol_h

#import "MDMAPIBaseManager.h"
#import "MDMAPIManagerProtocol.h"
#import "MDMAPIPluginHandle.h"

/**
 MDMAPIResponse插件所需遵循协议
 */
@protocol MDMAPIResponseReformProtocol <NSObject>

@required

/**
 对response进行处理
 
 @param responsePlugin 当前插件
 @param responseObject 原始返回数据
 @param response 返回的response
 @param apiManager 当前处理的apiManager
 @param resultType 处理结果，若处理失败，可直接修改该值
 @param info 处理结果附带信息，若处理失败，可直接将附带信息加入该值中
 
 @return 处理后的responseObject
 */
- (id)responsePlugin:(id<MDMAPIResponseReformProtocol>)responsePlugin
reformResponseObject:(id)responseObject
            response:(NSURLResponse *)response
          apiManager:(MDMAPIBaseManager<MDMAPIManagerProtocol> *)apiManager
          resultType:(MDMAPIResultType *)resultType
                info:(NSMutableDictionary **)info;

@end

#endif /* MDMAPIResponseReformProtocol_h */
