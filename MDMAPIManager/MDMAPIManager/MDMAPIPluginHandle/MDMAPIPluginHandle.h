//
//  MDMAPIPluginHandle.h
//  MDMAPIManager
//
//  Created by mademao on 2018/11/30.
//  Copyright © 2018 mademao. All rights reserved.
//

#import <Foundation/Foundation.h>

///Request插件section字段名
#ifndef MDMAPIRequestPluginSectName
#define MDMAPIRequestPluginSectName "MDMReqPlugin"
#endif

///Response插件section字段名
#ifndef MDMAPIResponsePluginSectName
#define MDMAPIResponsePluginSectName "MDMRespPlugin"
#endif

///section字段插入
#define MDMAPIDATA(sectname) __attribute((used, section("__DATA,"#sectname" ")))

///Request插件注解，优先级的设置应为大于0的整数，且不能设置冲突
#define MDMAPIRequestPlugin(pluginname,priority) \
class MDMAPIPluginHandle; \
static char * k##pluginname##_request_plugin MDMAPIDATA(MDMReqPlugin) = "{ \"name\" : \""#pluginname"\" , \"priority\" : \""#priority"\"}";

///Response插件注解，优先级的设置应为大于0的整数，且不能设置冲突
#define MDMAPIResponsePlugin(pluginname,priority) \
class MDMAPIPluginHandle; \
static char * k##pluginname##_response_plugin MDMAPIDATA(MDMRespPlugin) = "{ \"name\" : \""#pluginname"\" , \"priority\" : \""#priority"\"}";


NS_ASSUME_NONNULL_BEGIN

@interface MDMAPIPluginHandle : NSObject

@end

NS_ASSUME_NONNULL_END
