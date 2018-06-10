//
//  ZYImagePicker.m
//  ZYImagePickerDemo
//
//  Created by WeiLuezh on 2017/7/13.
//  Copyright © 2017年 Daniel. All rights reserved.
//

#import "ZYImagePicker.h"
#import <Photos/Photos.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "ZYCropImageController.h"

#import "ZYLocalizableManager.h"

typedef void(^FormDataBlock)(UIImage *image, ZYFormData *formData);

@interface ZYImagePicker ()
@property (nonatomic, assign)CGFloat compressWidth;     //default 500;
@property(nonatomic, strong)UIImagePickerController *ipc;
@property (nonatomic, copy)FormDataBlock formDataBlock;

@property (nonatomic, weak)UIViewController *visibleVC;

@property (nonatomic, assign)CGSize cropSize;
@property (nonatomic, assign)CGFloat imageScale;
@property (nonatomic, assign)BOOL isCircular;
@property (nonatomic, assign)NSTimeInterval maximun;    // 最大时长
@end

@implementation ZYImagePicker

- (void)setAccessibilityLanguage:(NSString *)accessibilityLanguage {
    _accessibilityLanguage = accessibilityLanguage;
    self.ipc.accessibilityLanguage = _accessibilityLanguage;
}

#pragma mark -- 获取指定大小图片
- (void)libraryPhotoWithController:(UIViewController *)controller compressWidth:(CGFloat)width formDataBlock:(void (^)(UIImage *, ZYFormData *))block {
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
    // picker中只显示图片
    self.ipc.mediaTypes = [NSArray arrayWithObjects: @"public.image", nil];
    [controller presentViewController:self.ipc animated:YES completion:^{
        self.ipc.delegate = self;
    }];
}

- (void)cameraPhotoWithController:(UIViewController *)controller compressWidth:(CGFloat)width formDataBlock:(void (^)(UIImage *, ZYFormData *))block {
    _formDataBlock = block;
    _compressWidth = width;
    _visibleVC = controller;
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        NSLog(@"无权限访问摄像头");
        return;
    }
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        self.ipc.sourceType = sourceType;
        [controller presentViewController:self.ipc animated:YES completion:^{
            self.ipc.delegate = self;
        }];
        self.ipc.delegate = self;
    } else {
        NSLog(@"模拟器中无法打开照相机,请在真机中使用");
    }
}

#pragma mark -- 裁剪图片
- (void)libraryPhotoWithController:(UIViewController *)controller cropSize:(CGSize)size imageScale:(CGFloat)scale isCircular:(BOOL)circular formDataBlock:(void (^)(UIImage *, ZYFormData *))block{
    _cropSize = size;
    _isCircular = circular;
    _imageScale = scale;
    [self libraryPhotoWithController:controller compressWidth:0.0 formDataBlock:block];
}
- (void)cameraPhotoWithController:(UIViewController *)controller cropSize:(CGSize)size imageScale:(CGFloat)scale isCircular:(BOOL)circular formDataBlock:(void (^)(UIImage *, ZYFormData *))block {
    _cropSize = size;
    _isCircular = circular;
    _imageScale = scale;
    [self cameraPhotoWithController:controller compressWidth:0.0 formDataBlock:block];
}

#pragma mark -- 获取视频
// 相册获取视频
- (void)libraryMoiveWithController:(UIViewController *)controller maximumDuration:(NSTimeInterval)duration formDataBlock:(void (^)(UIImage *image, ZYFormData *formData))block {
    _formDataBlock = block;
    _visibleVC = controller;
    _maximun = duration;
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        return;
    }
    
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied) {
        NSLog(@"无权限访问相册");
        return;
    }
    
    // 视频质量
    // self.ipc.videoQuality = UIImagePickerControllerQualityTypeMedium;
    if (duration) {
        self.ipc.videoMaximumDuration = duration;
    }
    
    self.ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    // picker中只显示视频
    self.ipc.mediaTypes = [NSArray arrayWithObjects:@"public.movie",  nil];
    [controller presentViewController:self.ipc animated:YES completion:^{
        self.ipc.delegate = self;
    }];
}
// 拍摄视频
- (void)cameraMoiveWithController:(UIViewController *)controller maximumDuration:(NSTimeInterval)duration formDataBlock:(void (^)(UIImage *image, ZYFormData *formData))block {
    _formDataBlock = block;
    _visibleVC = controller;
    _maximun = duration;
    
    //判断是否可以拍摄
    if ( [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        //判断是否拥有拍摄权限
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
            NSLog(@"无权限访问摄像头");
            return;
        }
        
        //拍摄
        self.ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        //录制的类型 下面为视频
        self.ipc.mediaTypes=@[(NSString*)kUTTypeMovie];
        
        //录制的时长
        if (duration) {
            self.ipc.videoMaximumDuration = duration;
        }
        
        //模态视图的弹出效果
        self.ipc.modalPresentationStyle=UIModalPresentationOverFullScreen;
        [controller presentViewController:self.ipc animated:YES completion:^{
            self.ipc.delegate = self;
        }];
    }
}


#pragma mark -- UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:UIImagePickerControllerOriginalImage];
        NSLog(@"imageSize: %lf, %lf", image.size.width, image.size.height);
        // 如果方向不对
        if (image.imageOrientation != UIImageOrientationUp) {
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
        data = UIImageJPEGRepresentation(image, 1);
        
        //图片命名用时间戳表示
        NSString *imageNameStr = [NSString stringWithFormat:@"%@.jpg",[self nameStringWithDate]];
        
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
                strongSelf.compressWidth = 0;
                strongSelf.cropSize = CGSizeZero;
            };
            [picker pushViewController:cropVC animated:true];
        } else {
            _formDataBlock(image, formData);
            [picker dismissViewControllerAnimated:YES completion:nil];
        }
    } else if ([type isEqualToString:@"public.movie"]){
        
        // 如果是视频
        NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
        
        NSDictionary *opts = [NSDictionary dictionaryWithObject:@(NO) forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
        AVURLAsset *asset = [AVURLAsset URLAssetWithURL:videoURL options:opts]; // 初始化视频媒体文件
        
        // 视频时长
        CGFloat second = asset.duration.value / (CGFloat)asset.duration.timescale;
        if (second > _maximun && _maximun) {
            
            __weak typeof(self) weakSelf = self;
            
            NSString *msg = [NSString stringWithFormat:@"%@%.2f%@",ZYLocalizedStringFromTable(@"视频不得超过", @"ZYLocalizedString", nil),_maximun,ZYLocalizedStringFromTable(@"秒", @"ZYLocalizedString", nil)];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:msg preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *editAction = [UIAlertAction actionWithTitle:ZYLocalizedStringFromTable(@"编辑视频", @"ZYLocalizedString", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                
                // 检查这个视频资源能不能被修改
                if ([UIVideoEditorController canEditVideoAtPath:videoURL.path]) {
                    UIVideoEditorController *editVC = [[UIVideoEditorController alloc] init];
                    if (strongSelf.accessibilityLanguage) {
                        editVC.accessibilityLanguage = strongSelf.accessibilityLanguage;
                    }
                    editVC.videoPath = videoURL.path;
                    editVC.videoMaximumDuration = strongSelf.maximun;
                    editVC.delegate = self;
                    
                    [strongSelf.visibleVC presentViewController:editVC animated:YES completion:nil];
                }
                
                // 不能编辑, 退出选择器
                else {
                    NSString *msg = ZYLocalizedStringFromTable(@"此视频不能编辑",@"ZYLocalizedString",nil);
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:msg preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *cancelAc = [UIAlertAction actionWithTitle:ZYLocalizedStringFromTable(@"确定", @"ZYLocalizedString", nil) style:UIAlertActionStyleCancel handler:nil];
                    [alert addAction:cancelAc];
                    
                    [picker dismissViewControllerAnimated:true completion:^{
                        [strongSelf.visibleVC presentViewController:alert animated:true completion:nil];
                    }];
                }
                
            }];
            
            // 取消编辑block
            UIAlertAction *cancelAc = [UIAlertAction actionWithTitle:ZYLocalizedStringFromTable(@"取消", @"ZYLocalizedString", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [picker dismissViewControllerAnimated:true completion:^{
                    __strong typeof(weakSelf) strongSelf = weakSelf;
                    [strongSelf.visibleVC presentViewController:alert animated:true completion:nil];
                }];
            }];
            [alert addAction:editAction];
            [alert addAction:cancelAc];
            
            [picker dismissViewControllerAnimated:true completion:^{
                __strong typeof(weakSelf) strongSelf = weakSelf;
                [strongSelf.visibleVC presentViewController:alert animated:true completion:nil];
            }];
         } else {
             [self endSelectVideoWithUrl:videoURL asset:asset];
         }
    }
}

- (void)endSelectVideoWithUrl:(NSURL *)videoUrl asset:(AVURLAsset *)asset {
    ZYFormData *videoFormData = [ZYFormData new];
    videoFormData.fileUrl = videoUrl;
    videoFormData.name = @"video";
    
    // 获取后缀
    NSString *suffix = [videoUrl.absoluteString componentsSeparatedByString:@"."].lastObject;
    
    videoFormData.filename = [NSString stringWithFormat:@"%@.%@",[self nameStringWithDate],suffix];
    videoFormData.mimeType = @"video/*";
    
    // 缩略图
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    
    // 视频时长
    
    if (_formDataBlock) {
        _formDataBlock(thumb,videoFormData);
    }
    
    [self.visibleVC dismissViewControllerAnimated:true completion:nil];
}
#pragma mark -- UIVideoEditorControllerDelegate
- (void)videoEditorController:(UIVideoEditorController *)editor didSaveEditedVideoToPath:(NSString *)editedVideoPath {
    if (![editedVideoPath rangeOfString:@"file"].length) {
        editedVideoPath = [NSString stringWithFormat:@"file://%@", editedVideoPath];
    }
    
    NSURL *videoURL = [NSURL URLWithString:editedVideoPath];
    NSDictionary *opts = [NSDictionary dictionaryWithObject:@(NO) forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:videoURL options:opts]; // 初始化视频媒体文件
    [self endSelectVideoWithUrl:videoURL asset:asset];
}

- (void)videoEditorController:(UIVideoEditorController *)editor didFailWithError:(NSError *)error {
    NSString *msg = [NSString stringWithFormat:@"%@%.2f%@",ZYLocalizedStringFromTable(@"视频编辑失败", @"ZYLocalizedString", nil),_maximun,ZYLocalizedStringFromTable(@"秒", @"ZYLocalizedString", nil)];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAc = [UIAlertAction actionWithTitle:ZYLocalizedStringFromTable(@"确定", @"ZYLocalizedString", nil) style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancelAc];
    
    __weak typeof(self) weakSelf = self;
    [self.visibleVC dismissViewControllerAnimated:true completion:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.visibleVC presentViewController:alert animated:true completion:nil];
    }];
}

- (void)videoEditorControllerDidCancel:(UIVideoEditorController *)editor {
    [self.visibleVC dismissViewControllerAnimated:true completion:nil];
}
#pragma mark -- 旋转图片
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

// 格式转换
- (NSURL *)convertToMp4:(NSURL *)movUrl {
    NSURL *mp4Url = nil;
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:movUrl options:nil];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    
    if ([compatiblePresets containsObject:AVAssetExportPresetHighestQuality]) {
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]initWithAsset:avAsset
                                                                              presetName:AVAssetExportPresetHighestQuality];
        NSString *mp4Path = [NSString stringWithFormat:@"%@/%d%d.mp4", [self dataPath], (int)[[NSDate date] timeIntervalSince1970], arc4random() % 100000];
        mp4Url = [NSURL fileURLWithPath:mp4Path];
        exportSession.outputURL = mp4Url;
        exportSession.shouldOptimizeForNetworkUse = YES;
        exportSession.outputFileType = AVFileTypeMPEG4;
        dispatch_semaphore_t wait = dispatch_semaphore_create(0l);
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            switch ([exportSession status]) {
                case AVAssetExportSessionStatusFailed: {
                    NSLog(@"failed, error:%@.", exportSession.error);
                } break;
                case AVAssetExportSessionStatusCancelled: {
                    NSLog(@"cancelled.");
                } break;
                case AVAssetExportSessionStatusCompleted: {
                    NSLog(@"completed.");
                } break;
                default: {
                    NSLog(@"others.");
                } break;
            }
            dispatch_semaphore_signal(wait);
        }];
        long timeout = dispatch_semaphore_wait(wait, DISPATCH_TIME_FOREVER);
        if (timeout) {
            NSLog(@"timeout.");
        }
        if (wait) {
            //dispatch_release(wait);
            wait = nil;
        }
    }
    return mp4Url;
}

- (UIImagePickerController *)ipc {
    if (!_ipc) {
        _ipc = [[UIImagePickerController alloc] init];
        _ipc.allowsEditing = false;
        if (_accessibilityLanguage.length) {
            _ipc.accessibilityLanguage = _accessibilityLanguage;
        }
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

- (NSString*)dataPath
{
    NSString *dataPath = [NSString stringWithFormat:@"%@/Library/appdata/chatbuffer", NSHomeDirectory()];
    NSFileManager *fm = [NSFileManager defaultManager];
    if(![fm fileExistsAtPath:dataPath]){
        [fm createDirectoryAtPath:dataPath
      withIntermediateDirectories:YES
                       attributes:nil
                            error:nil];
    }
    return dataPath;
}

- (NSString *)nameStringWithDate {
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval aDate=[date timeIntervalSince1970]*1000;
    NSString *timeString = [NSString stringWithFormat:@"%.0f",aDate];
    return timeString;
}

@end
