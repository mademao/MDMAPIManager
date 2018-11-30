//
//  MDMAPIResponsePluginManager.m
//  MDMAPIManager
//
//  Created by mademao on 2018/11/30.
//  Copyright © 2018 mademao. All rights reserved.
//

#import "MDMAPIResponsePluginManager.h"

@interface MDMAPIResponsePluginManager ()

///保存所有插件
@property (nonatomic, strong) NSMutableArray<id<MDMAPIResponseReformProtocol>> *pluginArray;

@end

@implementation MDMAPIResponsePluginManager

///获取所有插件
+ (NSArray<id<MDMAPIResponseReformProtocol>> *)getAllResponsePlugin
{
    return [[MDMAPIResponsePluginManager sharedInstance].pluginArray copy];
}

///新增插件
+ (void)addResponsePlugin:(id<MDMAPIResponseReformProtocol>)plugin
{
    if ([plugin conformsToProtocol:@protocol(MDMAPIResponseReformProtocol)] &&
        [plugin respondsToSelector:@selector(responsePlugin:reformResponseObject:response:apiManager:resultType:info:)]) {
        [[MDMAPIResponsePluginManager sharedInstance].pluginArray addObject:plugin];
    } else {
        NSException *exception = [[NSException alloc] initWithName:@"MDMAPIResponsePluginManager添加插件失败"
                                                            reason:@"所添加对象没有遵循MDMAPIResponseReformProtocol协议或没有实现对应方法"
                                                          userInfo:nil];
        @throw exception;
    }
}

///移除插件
+ (void)removeResponsePlugin:(id<MDMAPIResponseReformProtocol>)plugin
{
    if ([[MDMAPIResponsePluginManager sharedInstance].pluginArray containsObject:plugin]) {
        [[MDMAPIResponsePluginManager sharedInstance].pluginArray removeObject:plugin];
    }
}


#pragma mark - private method

+ (instancetype)sharedInstance
{
    static MDMAPIResponsePluginManager *pluginManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        pluginManager = [[MDMAPIResponsePluginManager alloc] init];
    });
    return pluginManager;
}


#pragma mark - lazy load

- (NSMutableArray<id<MDMAPIResponseReformProtocol>> *)pluginArray
{
    if (!_pluginArray) {
        _pluginArray = [NSMutableArray array];
    }
    return _pluginArray;
}

@end
