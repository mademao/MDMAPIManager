//
//  MDMAPIResponsePluginManager.h
//  MDMAPIManager
//
//  Created by mademao on 2018/11/30.
//  Copyright © 2018 mademao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDMAPIResponseReformProtocol.h"

NS_ASSUME_NONNULL_BEGIN

/**
 MDMAPI全局response插件管理
 */
@interface MDMAPIResponsePluginManager : NSObject

/**
 获取所有插件
 
 @return 插件数组
 */
+ (NSArray<id<MDMAPIResponseReformProtocol>> *)getAllResponsePlugin;

/**
 新增插件，后增插件的处理数据为先增插件处理后的结果
 
 @param plugin 需要添加的插件
 */
+ (void)addResponsePlugin:(id<MDMAPIResponseReformProtocol>)plugin;

/**
 移除插件
 
 @param plugin 需要移除的插件
 */
+ (void)removeResponsePlugin:(id<MDMAPIResponseReformProtocol>)plugin;

@end

NS_ASSUME_NONNULL_END
