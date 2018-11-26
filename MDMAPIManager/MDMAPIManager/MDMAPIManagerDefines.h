//
//  MDMAPIManagerDefines.h
//  MDMAPIManager
//
//  Created by mademao on 2018/11/26.
//  Copyright © 2018 mademao. All rights reserved.
//

#ifndef MDMAPIManagerDefines_h
#define MDMAPIManagerDefines_h

///请求类型
typedef NS_ENUM(NSUInteger, MDMAPIType) {
    MDMAPITypeGET,
    MDMAPITypePOST
};

///请求结果类型
typedef NS_ENUM(NSUInteger, MDMAPIResultType) {
    MDMAPIResultTypeSuccess,
    MDMAPIResultTypeAPIException,
    MDMAPIResultTypeServerBad,
    MDMAPIResultTypeNoInternet
};

///请求结果的缓存策略
typedef NS_OPTIONS(NSUInteger, MDMAPICachePolicy) {
    MDMAPICachePolicyNoCache = 0,
    MDMAPICachePolicyMemory = 1 << 0,
    MDMAPICachePolicyDisk = 1 << 1,
    MDMAPICachePolicyAll = 3
};

#endif /* MDMAPIManagerDefines_h */
