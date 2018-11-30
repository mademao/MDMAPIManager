//
//  MDMAPIPluginHandle.m
//  MDMAPIManager
//
//  Created by mademao on 2018/11/30.
//  Copyright © 2018 mademao. All rights reserved.
//

#import "MDMAPIPluginHandle.h"
#include <mach-o/getsect.h>
#include <mach-o/loader.h>
#include <mach-o/dyld.h>
#include <dlfcn.h>
#include <mach-o/ldsyms.h>
#import "MDMAPIPluginModel.h"
#import "MDMAPIRequestPluginManager.h"
#import "MDMAPIResponsePluginManager.h"

NSArray<MDMAPIPluginModel *>* MDMReadPlugin(char *sectionName, const struct mach_header *mhp);

///处理API插件
static void dyld_callback(const struct mach_header *mhp, intptr_t vmaddr_slide)
{
    NSArray<MDMAPIPluginModel *> *requestPluginArray = MDMReadPlugin(MDMAPIRequestPluginSectName, mhp);
    for (MDMAPIPluginModel *model in requestPluginArray) {
        Class class = NSClassFromString(model.pluginClassName);
        [MDMAPIRequestPluginManager addRequestPlugin:[[class alloc] init]];
    }
    
    NSArray<MDMAPIPluginModel *> *responsePluginArray = MDMReadPlugin(MDMAPIResponsePluginSectName, mhp);
    for (MDMAPIPluginModel *model in responsePluginArray) {
        Class class = NSClassFromString(model.pluginClassName);
        [MDMAPIResponsePluginManager addResponsePlugin:[[class alloc] init]];
    }
}

///设置回调，__attribute__((constructor))标识的函数会在main函数执行之前被调用
__attribute__((constructor))
void initProphet() {
    _dyld_register_func_for_add_image(dyld_callback);
}

///读取注解的API插件
///对于注解插件的类及优先级设置是否正确的检测放入MDMAPIPluginModel中
///对于注解插件的优先级是否冲突的检测放入该方法中
NSArray<MDMAPIPluginModel *>* MDMReadPlugin(char *sectionName, const struct mach_header *mhp)
{
    NSMutableArray *plugins = [NSMutableArray array];
    unsigned long size = 0;
#ifndef __LP64__
    uintptr_t *memory = (uintptr_t *)getsectiondata(mhp, SEG_DATA, sectionName, &size);
#else
    const struct mach_header_64 *mhp64 = (const struct mach_header_64 *)mhp;
    uintptr_t *memory = (uintptr_t *)getsectiondata(mhp64, SEG_DATA, sectionName, &size);
#endif
    
    unsigned long counter = size / sizeof(void*);
    for(int idx = 0; idx < counter; ++idx) {
        char *string = (char*)memory[idx];
        NSString *str = [NSString stringWithUTF8String:string];
        NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        if (json && [json isKindOfClass:[NSDictionary class]]) {
            ///以下生成model步骤会检测被注解为API插件的类是否存在，同时会检测优先级设置格式是否正确
            MDMAPIPluginModel *model = [[MDMAPIPluginModel alloc] init];
            [model setValuesForKeysWithDictionary:json];
            
            ///以下会检测API插件的优先级设置是否存在冲突
            if ([plugins containsObject:model]) {
                MDMAPIPluginModel *existModel = [plugins objectAtIndex:[plugins indexOfObject:model]];
                
                //由于只使用了优先级来判定插件是否相同，所以要根据插件名来决定是否是同一个插件
                if ([existModel.pluginClassName isEqualToString:model.pluginClassName]) {
                    //此时对应的插件已经被添加至数组中，跳过即可
                    continue;
                } else {
                    //此时对应插件的优先级已经重复，抛错提示
                    NSString *reason = [NSString stringWithFormat:@"%@对应的插件与%@对应的插件指定了同样的优先级", existModel.pluginClassName, model.pluginClassName];
                    NSException *exception = [[NSException alloc] initWithName:@"MDMAPI加载插件出错"
                                                                        reason:reason
                                                                      userInfo:nil];
                    @throw exception;
                }
            }
            
            [plugins addObject:model];
        }
    }
    
    [plugins sortUsingComparator:^NSComparisonResult(MDMAPIPluginModel *obj1, MDMAPIPluginModel *obj2) {
        return obj1.pluginPriority > obj2.pluginPriority;
    }];
    
    return plugins;
}

@implementation MDMAPIPluginHandle

@end
