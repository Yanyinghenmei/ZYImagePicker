//
//  ZYCropImageController.h
//  XiPinHui
//
//  Created by WeiLuezh on 2017/7/11.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYFormData.h"

#define ZYScreenWidth [UIScreen mainScreen].bounds.size.width
#define ZYScreenHeight [UIScreen mainScreen].bounds.size.height

#define CropBottomViewHeight 70
#define MaxCropViewWidth ZYScreenWidth
#define MaxCropViewHeight ZYScreenHeight-CropBottomViewHeight

@interface ZYCropImageController : UIViewController
@property (nonatomic, copy)void(^selectBlock)(UIImage *image, ZYFormData *formData);

@property (nonatomic, strong)ZYFormData *formData;
@property (nonatomic, assign)CGSize cropSize;
@property (nonatomic, assign)CGFloat imageScale;
@property (nonatomic, assign)BOOL isCircular;
@end
