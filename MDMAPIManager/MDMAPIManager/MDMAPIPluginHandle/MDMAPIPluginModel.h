//
//  MDMAPIPluginModel.h
//  MDMAPIManager
//
//  Created by mademao on 2018/11/30.
//  Copyright © 2018 mademao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 所有API插件封装模型
 */

@interface MDMAPIPluginModel : NSObject

///插件对应的类名
@property (nonatomic, copy) NSString *pluginClassName;

///插件对应的优先级别
@property (nonatomic, assign) NSInteger pluginPriority;

@end

NS_ASSUME_NONNULL_END
