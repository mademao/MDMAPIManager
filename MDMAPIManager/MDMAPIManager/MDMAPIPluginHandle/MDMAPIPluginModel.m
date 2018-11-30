//
//  MDMAPIPluginModel.m
//  MDMAPIManager
//
//  Created by mademao on 2018/11/30.
//  Copyright © 2018 mademao. All rights reserved.
//

#import "MDMAPIPluginModel.h"

@implementation MDMAPIPluginModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"name"]) {
        NSString *className = (NSString *)value;
        Class class = NSClassFromString(className);
        if (class) {
            self.pluginClassName = className;
        } else {
            NSException *exception = [[NSException alloc] initWithName:@"MDMAPI加载插件出错"
                                                                reason:[NSString stringWithFormat:@"%@对应的类不存在，无法加载为插件", className]
                                                              userInfo:nil];
            @throw exception;
        }
    } else if ([key isEqualToString:@"priority"]) {
        NSString *priorityString = (NSString *)value;
        NSInteger priority = [priorityString integerValue];
        if (priority > 0) {
            self.pluginPriority = priority;
        } else {
            NSException *exception = [[NSException alloc] initWithName:@"MDMAPI加载插件出错"
                                                                reason:[NSString stringWithFormat:@"%@对应的插件在指定优先级时需为大于0的整数", self.pluginClassName]
                                                              userInfo:nil];
            @throw exception;
        }
    }
}

- (BOOL)isEqual:(id)object
{
    if (object == self) {
        return YES;
    } else if ([object isKindOfClass:[MDMAPIPluginModel class]] == NO) {
        return NO;
    } else {
        MDMAPIPluginModel *model = (MDMAPIPluginModel *)object;
        return model.pluginPriority == self.pluginPriority;
    }
}

- (NSUInteger)hash
{
    return self.pluginPriority;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"name-->%@, priority-->%@", self.pluginClassName, @(self.pluginPriority)];
}

@end
