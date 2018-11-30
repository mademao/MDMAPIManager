//
//  MDMAPIRequestPluginManager.h
//  MDMAPIManager
//
//  Created by mademao on 2018/11/30.
//  Copyright © 2018 mademao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDMAPIRequestReformProtocol.h"

NS_ASSUME_NONNULL_BEGIN

/**
 MDMAPI全局request插件管理
 */
@interface MDMAPIRequestPluginManager : NSObject

/**
 获取所有插件
 
 @return 插件数组
 */
+ (NSArray<id<MDMAPIRequestReformProtocol>> *)getAllRequestPlugin;

/**
 新增插件，后增插件的设置会覆盖先增插件的设置
 
 @param plugin 需要添加的插件
 */
+ (void)addRequestPlugin:(id<MDMAPIRequestReformProtocol>)plugin;

/**
 移除插件
 
 @param plugin 需要移除的插件
 */
+ (void)removeRequestPlugin:(id<MDMAPIRequestReformProtocol>)plugin;

@end

NS_ASSUME_NONNULL_END
