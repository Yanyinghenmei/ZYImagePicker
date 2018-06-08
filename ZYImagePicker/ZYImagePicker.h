//
//  ZYImagePicker.h
//  ZYImagePickerDemo
//
//  Created by WeiLuezh on 2017/7/13.
//  Copyright © 2017年 Daniel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYFormData.h"

@interface ZYImagePicker : NSObject<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIVideoEditorControllerDelegate>

// 语言 如 NSCalendarIdentifierChinese
@property (nonatomic, copy)NSString * accessibilityLanguage;


/**
 不裁剪图片

 @param controller      启动相册的Controller
 @param width           获取的图片的宽度                             默认 500
 @param block           选定图片的回调
 */
- (void)libraryPhotoWithController:(UIViewController *)controller
                     compressWidth:(CGFloat)width
                     formDataBlock:(void(^)(UIImage *image, ZYFormData *formData))block;

- (void)cameraPhotoWithController:(UIViewController *)controller
                    compressWidth:(CGFloat)width
                    formDataBlock:(void(^)(UIImage *image, ZYFormData *formData))block;


/**
 获取裁剪后的图片

 @param controller      启动相册的Controller
 @param size            裁剪框的大小                                   默认屏幕大小
 @param scale           裁剪得到的图片宽高是裁剪框的几倍(建议2倍或者三倍)     如果传入0, 则默认2倍
 @param circular        是否裁剪为圆形
 @param block           选定图片后回调
 */
- (void)libraryPhotoWithController:(UIViewController *)controller
                          cropSize:(CGSize)size
                        imageScale:(CGFloat)scale
                        isCircular:(BOOL)circular
                     formDataBlock:(void(^)(UIImage *image, ZYFormData *formData))block;

- (void)cameraPhotoWithController:(UIViewController *)controller
                         cropSize:(CGSize)size
                       imageScale:(CGFloat)scale
                       isCircular:(BOOL)circular
                    formDataBlock:(void(^)(UIImage *image, ZYFormData *formData))block;


// 视频
- (void)libraryMoiveWithController:(UIViewController *)controller
                   maximumDuration:(NSTimeInterval)duration
                     formDataBlock:(void (^)(UIImage *, ZYFormData *))block;

- (void)cameraMoiveWithController:(UIViewController *)controller
                  maximumDuration:(NSTimeInterval)duration
                    formDataBlock:(void (^)(UIImage *thumbnail, ZYFormData *))block;

// 格式转换 如果用过之后不需要保存, 记得删掉哦 [[NSFileManager defaultManager] removeItemAtURL:videoURL error:nil];
- (NSURL *)convertToMp4:(NSURL *)movUrl;

@end
