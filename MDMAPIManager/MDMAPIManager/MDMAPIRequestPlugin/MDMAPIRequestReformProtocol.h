//
//  MDMAPIRequestReformProtocol.h
//  MDMAPIManager
//
//  Created by mademao on 2018/11/30.
//  Copyright © 2018 mademao. All rights reserved.
//

#ifndef MDMAPIRequestReformProtocol_h
#define MDMAPIRequestReformProtocol_h

#import "MDMAPIBaseManager.h"
#import "MDMAPIManagerProtocol.h"
#import "MDMAPIPluginHandle.h"

/**
 MDMAPIRequest插件所需遵循协议
 */
@protocol MDMAPIRequestReformProtocol <NSObject>

@required

/**
 对request进行修改
 
 @param requestPlugin 当前插件
 @param request 原始request
 @param apiManager 当前处理的apiManager
 
 @return 修改后的request
 */
- (NSURLRequest *)requestPlugin:(id<MDMAPIRequestReformProtocol>)requestPlugin
                  reformRequest:(NSURLRequest *)request
                     apiManager:(MDMAPIBaseManager<MDMAPIManagerProtocol> *)apiManager;

@end

#endif /* MDMAPIRequestReformProtocol_h */
