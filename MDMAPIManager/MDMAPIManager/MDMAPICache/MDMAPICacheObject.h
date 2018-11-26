//
//  MDMAPICacheObject.h
//  MDMAPIManager
//
//  Created by mademao on 2018/11/26.
//  Copyright © 2018 mademao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 缓存所保存的对象
 */
@interface MDMAPICacheObject : NSObject <NSCoding>

///保存的response
@property (nonatomic, strong) NSURLResponse *response;

///保存的responseObject
@property (nonatomic, strong) id responseObject;

///最后更新时间
@property (nonatomic, strong) NSDate *lastUpdateDate;

///有效时间
@property (nonatomic, assign) NSTimeInterval cacheTime;

@end

NS_ASSUME_NONNULL_END
