//
//  MDMAPIFormData.h
//  MDMAPIManager
//
//  Created by mademao on 2018/11/26.
//  Copyright © 2018 mademao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDMAPIFormDataNormalItem.h"
#import "MDMAPIFormDataFileItem.h"

NS_ASSUME_NONNULL_BEGIN

/**
 表单数据
 
 可用来添加表单中的普通键值对参数，也可用来添加表单中的文件参数
 */
@interface MDMAPIFormData : NSObject

///存储普通参数
@property (nonatomic, strong) NSMutableArray<MDMAPIFormDataNormalItem *> *normalItemArray;

///存储文件参数
@property (nonatomic, strong) NSMutableArray<MDMAPIFormDataFileItem *> *fileItemArray;

/**
 添加普通参数
 
 @param param 参数值
 @param key 参数名
 */
- (void)addParam:(NSString *)param key:(NSString *)key;

/**
 添加文件参数
 
 @param fileData 文件数据
 @param key 参数名
 @param fileName 文件名
 @param mimeType 文件类型
 */
- (void)addFileData:(NSData *)fileData key:(NSString *)key fileName:(NSString *)fileName mimeType:(NSString *)mimeType;

@end

NS_ASSUME_NONNULL_END
