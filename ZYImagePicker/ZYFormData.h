//
//  ZYFormData.h
//  ZYImagePickerDemo
//
//  Created by WeiLuezh on 2017/7/13.
//  Copyright © 2017年 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZYFormData : NSObject
/**
 *  文件数据
 */
@property (nonatomic, strong) NSData *data;

/**
 *  参数名
 */
@property (nonatomic, copy) NSString *name;

/**
 *  文件名
 */
@property (nonatomic, copy) NSString *filename;

/**
 *  文件类型
 */
@property (nonatomic, copy) NSString *mimeType;
/*
 * 文件路径
 */
@property (nonatomic, copy) NSString *filePath;
@end
