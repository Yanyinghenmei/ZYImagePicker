//
//  ZYFormData.m
//  ZYImagePickerDemo
//
//  Created by WeiLuezh on 2017/7/13.
//  Copyright © 2017年 Daniel. All rights reserved.
//

#import "ZYFormData.h"

@implementation ZYFormData
- (NSData *)data {
    if (!_data && _fileUrl) {
        _data = [NSData dataWithContentsOfURL:_fileUrl];
    } else {
        NSLog(@"error:No Media data!");
    }
    return _data;
}
@end
