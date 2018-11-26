//
//  MDMAPIFormDataFileItem.h
//  MDMAPIManager
//
//  Created by mademao on 2018/11/26.
//  Copyright © 2018 mademao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 表单数据中的文件参数
 */
@interface MDMAPIFormDataFileItem : NSObject

///参数名
@property (nonatomic, copy) NSString *key;
///文件数据
@property (nonatomic, copy) NSData *fileData;
///文件名
@property (nonatomic, copy) NSString *fileName;
///文件类型
@property (nonatomic, copy) NSString *mimeType;

- (instancetype)initWithKey:(NSString *)key fileData:(NSData *)fileData fileName:(NSString *)fileName mimeType:(NSString *)mimeType;
+ (instancetype)fileItemWithKey:(NSString *)key fileData:(NSData *)fileData fileName:(NSString *)fileName mimeType:(NSString *)mimeType;

@end

NS_ASSUME_NONNULL_END
