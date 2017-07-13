//
//  ZYImagePicker.m
//  ZYImagePickerDemo
//
//  Created by WeiLuezh on 2017/7/13.
//  Copyright © 2017年 Daniel. All rights reserved.
//

#import "ZYImagePicker.h"
#import <Photos/Photos.h>
#import "ZYCropImageController.h"

typedef void(^FormDataBlock)(UIImage *image, ZYFormData *formData);

@interface ZYImagePicker ()
@property (nonatomic, assign)CGFloat compressWidth;     //default 500;
@property(nonatomic, strong)UIImagePickerController *ipc;
@property (nonatomic, copy)FormDataBlock formDataBlock;
@property (nonatomic, weak)UIViewController *visibleVC;

@property (nonatomic, assign)CGSize cropSize;
@property (nonatomic, assign)CGFloat imageScale;
@property (nonatomic, assign)BOOL isCircular;
@end

@implementation ZYImagePicker

- (void)libraryPhotoWithController:(UIViewController *)controller compressWidth:(CGFloat)width FormDataBlock:(void (^)(UIImage *, ZYFormData *))block {
    _formDataBlock = block;
    _compressWidth = width;
    _visibleVC = controller;
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        return;
    }
    
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied) {
        NSLog(@"无权限访问相册");
        return;
    }
    
    self.ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [controller presentViewController:self.ipc animated:YES completion:^{
        self.ipc.delegate = self;
    }];
}

- (void)cameraPhotoWithController:(UIViewController *)controller compressWidth:(CGFloat)width FormDataBlock:(void (^)(UIImage *, ZYFormData *))block {
    _formDataBlock = block;
    _compressWidth = width;
    _visibleVC = controller;
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        self.ipc.sourceType = sourceType;
        [controller presentViewController:self.ipc animated:YES completion:^{
            self.ipc.delegate = self;
        }];
        self.ipc.delegate = self;
    } else {
        NSLog(@"模拟其中无法打开照相机,请在真机中使用");
    }
}

// 裁剪图片
- (void)libraryPhotoWithController:(UIViewController *)controller cropSize:(CGSize)size imageScale:(CGFloat)scale isCircular:(BOOL)circular FormDataBlock:(void (^)(UIImage *, ZYFormData *))block{
    _cropSize = size;
    _isCircular = circular;
    _imageScale = scale;
    [self libraryPhotoWithController:controller compressWidth:0.0 FormDataBlock:block];
}
- (void)cameraPhotoWithController:(UIViewController *)controller cropSize:(CGSize)size imageScale:(CGFloat)scale isCircular:(BOOL)circular FormDataBlock:(void (^)(UIImage *, ZYFormData *))block {
    _cropSize = size;
    _isCircular = circular;
    _imageScale = scale;
    [self cameraPhotoWithController:controller compressWidth:0.0 FormDataBlock:block];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        // 如果是拍照, 旋转90度
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            image = [self fixOrientation:image];
        }
        
        // 如果不裁剪, 限制大小
        if (!_cropSize.width) {
            if (!_compressWidth) {
                _compressWidth = 500;
            }
            //设置image的尺寸
            CGSize imageSize = CGSizeMake(_compressWidth, image.size.height * _compressWidth/image.size.width);
            //对图片大小进行压缩--
            image = [self imageWithImage:image scaledToSize:imageSize];
        }
        
        NSData *data;
        if (UIImagePNGRepresentation(image) == nil) {
            data = UIImageJPEGRepresentation(image, 1);
        } else {
            data = UIImagePNGRepresentation(image);
        }
        
        //图片命名用时间戳表示
        NSString * imageNameStr = [self imageNameWithDate];
        
        ZYFormData *formData = [[ZYFormData alloc] init];
        formData.data = data;
        formData.name = @"simg";
        formData.filename = imageNameStr;
        formData.mimeType = @"image/jpeg";
        
        if (_cropSize.width) {
            __weak typeof(self) weakSelf = self;
            ZYCropImageController *cropVC = [ZYCropImageController new];
            cropVC.cropSize = _cropSize;
            cropVC.imageScale = _imageScale;
            cropVC.isCircular = _isCircular;
            cropVC.formData = formData;
            cropVC.selectBlock = ^(UIImage *image, ZYFormData *editFormData) {
                __strong typeof(self) strongSelf = weakSelf;
                strongSelf.formDataBlock(image, editFormData);
            };
            [picker pushViewController:cropVC animated:true];
        } else {
            _formDataBlock(image, formData);
            [picker dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

- (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation ==UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform =CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width,0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width,0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height,0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx =CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                            CGImageGetBitsPerComponent(aImage.CGImage),0,
                                            CGImageGetColorSpace(aImage.CGImage),
                                            CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx,CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx,CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg =CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

- (UIImagePickerController *)ipc {
    if (!_ipc) {
        _ipc = [[UIImagePickerController alloc] init];
        _ipc.allowsEditing = false;
    }
    return _ipc;
}

- (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (NSString *)imageNameWithDate {
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval aDate=[date timeIntervalSince1970]*1000;
    NSString *timeString = [NSString stringWithFormat:@"%.0f",aDate];
    NSString * imageNameStr = [NSString stringWithFormat:@"%@.jpg",timeString];
    return imageNameStr;
}

@end
