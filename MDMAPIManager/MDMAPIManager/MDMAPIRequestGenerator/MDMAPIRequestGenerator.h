//
//  MDMAPIRequestGenerator.h
//  MDMAPIManager
//
//  Created by mademao on 2018/11/26.
//  Copyright © 2018 mademao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDMAPIManagerDefines.h"
#import "MDMAPIFormData.h"

NS_ASSUME_NONNULL_BEGIN

/**
 Request构造器
 */
@interface MDMAPIRequestGenerator : NSObject

/**
 构造一个request
 
 @param apiType 请求类型
 @param url 请求url
 @param params 普通参数
 @param formData 表单参数
 
 @return 构造好的request
 */
+ (NSURLRequest *)requestWithAPIType:(MDMAPIType)apiType
                                 url:(NSString *)url
                              params:(NSDictionary *)params
                            formData:(MDMAPIFormData *)formData;

@end

NS_ASSUME_NONNULL_END
