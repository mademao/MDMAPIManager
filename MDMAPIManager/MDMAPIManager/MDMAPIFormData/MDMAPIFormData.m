//
//  MDMAPIFormData.m
//  MDMAPIManager
//
//  Created by mademao on 2018/11/26.
//  Copyright © 2018 mademao. All rights reserved.
//

#import "MDMAPIFormData.h"

@implementation MDMAPIFormData

///添加普通参数
- (void)addParam:(NSString *)param key:(NSString *)key
{
    if (key == nil || param == nil) {
        return;
    }
    MDMAPIFormDataNormalItem *normalItem = [MDMAPIFormDataNormalItem normalItemWithKey:key value:param];
    [self.normalItemArray addObject:normalItem];
}

///添加文件参数
- (void)addFileData:(NSData *)fileData key:(NSString *)key fileName:(NSString *)fileName mimeType:(NSString *)mimeType
{
    if (fileData == nil || key == nil || fileName == nil || mimeType == nil) {
        return;
    }
    MDMAPIFormDataFileItem *fileItem = [MDMAPIFormDataFileItem fileItemWithKey:key fileData:fileData fileName:fileName mimeType:mimeType];
    [self.fileItemArray addObject:fileItem];
}


#pragma mark - lazy load

- (NSMutableArray<MDMAPIFormDataNormalItem *> *)normalItemArray
{
    if (!_normalItemArray) {
        _normalItemArray = [NSMutableArray array];
    }
    return _normalItemArray;
}

- (NSMutableArray<MDMAPIFormDataFileItem *> *)fileItemArray
{
    if (!_fileItemArray) {
        _fileItemArray = [NSMutableArray array];
    }
    return _fileItemArray;
}

@end
