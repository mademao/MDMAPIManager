//
//  MDMAPIRequestPluginManager.m
//  MDMAPIManager
//
//  Created by mademao on 2018/11/30.
//  Copyright © 2018 mademao. All rights reserved.
//

#import "MDMAPIRequestPluginManager.h"

@interface MDMAPIRequestPluginManager ()

///保存所有插件
@property (nonatomic, strong) NSMutableArray<id<MDMAPIRequestReformProtocol>> *pluginArray;

@end

@implementation MDMAPIRequestPluginManager

///获取所有插件
+ (NSArray<id<MDMAPIRequestReformProtocol>> *)getAllRequestPlugin
{
    return [[MDMAPIRequestPluginManager sharedInstance].pluginArray copy];
}

///新增插件
+ (void)addRequestPlugin:(id<MDMAPIRequestReformProtocol>)plugin
{
    if ([plugin conformsToProtocol:@protocol(MDMAPIRequestReformProtocol)] &&
        [plugin respondsToSelector:@selector(requestPlugin:reformRequest:apiManager:)]) {
        [[MDMAPIRequestPluginManager sharedInstance].pluginArray addObject:plugin];
    } else {
        NSException *exception = [[NSException alloc] initWithName:@"MDMAPIRequestPluginManager添加插件失败"
                                                            reason:@"所添加对象没有遵循MDMAPIRequestReformProtocol协议或没有实现对应方法"
                                                          userInfo:nil];
        @throw exception;
    }
}

///移除插件
+ (void)removeRequestPlugin:(id<MDMAPIRequestReformProtocol>)plugin
{
    if ([[MDMAPIRequestPluginManager sharedInstance].pluginArray containsObject:plugin]) {
        [[MDMAPIRequestPluginManager sharedInstance].pluginArray removeObject:plugin];
    }
}


#pragma mark - private method

+ (instancetype)sharedInstance
{
    static MDMAPIRequestPluginManager *pluginManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        pluginManager = [[MDMAPIRequestPluginManager alloc] init];
    });
    return pluginManager;
}


#pragma mark - lazy load

- (NSMutableArray<id<MDMAPIRequestReformProtocol>> *)pluginArray
{
    if (!_pluginArray) {
        _pluginArray = [NSMutableArray array];
    }
    return _pluginArray;
}

@end
