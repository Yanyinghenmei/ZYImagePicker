//
//  ZYCropImageController.m
//  XiPinHui
//
//  Created by WeiLuezh on 2017/7/11.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import "ZYCropImageController.h"

@interface ZYCropView :UIView
@property (nonatomic, strong)UIView *hitView;
@end
@implementation ZYCropView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    return _hitView?_hitView:[super hitTest:point withEvent:event];
}

@end

@interface ZYCropImageController ()<UIScrollViewDelegate>
@property (strong, nonatomic) UIScrollView *scrollView;
@property (nonatomic, strong)UIImageView *imageView;
@property (nonatomic, strong)ZYCropView *cropView;
@property (nonatomic, strong)UIImage *image;
@end

@implementation ZYCropImageController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:true animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:false animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.clipsToBounds = true;
    self.automaticallyAdjustsScrollViewInsets = false;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self setUI];
    
    // 设置截取大小
    if (!_cropSize.width) {
        _cropSize = CGSizeMake(ZYScreenWidth, ZYScreenHeight);
    } else if (_cropSize.width > ZYScreenWidth) {
        _cropSize = CGSizeMake(ZYScreenWidth, ZYScreenHeight);
    }
    
    // image
    _image = [UIImage imageWithData:_formData.data];
    
    // scrollView
    [self.view insertSubview:self.scrollView atIndex:0];
    
    // crop view
    [self.view insertSubview:self.cropView atIndex:1];
}

- (void)setUI {
    self.view.backgroundColor = [UIColor blackColor];
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, ZYScreenHeight-70, ZYScreenWidth, 70)];
    bottomView.backgroundColor = [UIColor colorWithRed:52/255.00 green:52/255.00 blue:52/255.00 alpha:.9f];
    [self.view addSubview:bottomView];
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 15, 60, 40)];
    [cancelBtn setTitle:NSLocalizedStringFromTable(@"取消", @"ZYLocalizedString", nil) forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:cancelBtn];
    
    UIButton *useBtn = [[UIButton alloc] initWithFrame:CGRectMake(ZYScreenWidth-10-60, 15, 60, 40)];
    [useBtn setTitle:NSLocalizedStringFromTable(@"使用", @"ZYLocalizedString", nil) forState:UIControlStateNormal];
    [useBtn addTarget:self action:@selector(select:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:useBtn];
    
    cancelBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    useBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
}

- (CGFloat)imageScale {
    if (!_imageScale) {
        _imageScale = 2.0;
    }
    return _imageScale;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        
        _imageView = [[UIImageView alloc] initWithImage:_image];
        
        [_imageView setContentMode:UIViewContentModeScaleAspectFit];
        
        // 设置_imageView的位置大小
        
        CGRect frame = CGRectZero;
        CGFloat imgWidth;
        CGFloat imgHeight;
        
        // 根据图片的宽高比确定显示大小
        if (_image.size.width/_image.size.height > _cropSize.width/_cropSize.height) {
            imgHeight = _cropSize.height;
            imgWidth = imgHeight * _image.size.width/_image.size.height;
        } else {
            imgWidth = _cropSize.width;
            imgHeight = imgWidth * _image.size.height/_image.size.width;
        }
        
        frame.size.width = imgWidth;
        
        frame.size.height = imgHeight;
        
        _imageView.frame = frame;
    }
    return _imageView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:
                       CGRectMake((ZYScreenWidth-_cropSize.width)/2,
                                  (ZYScreenHeight-_cropSize.height)/2,
                                  _cropSize.width,
                                  _cropSize.height)];
        
        _scrollView.clipsToBounds = false;
        [_scrollView addSubview:self.imageView];
        
        // 保证图片清晰的情况下, 能够达到的最大的缩放比例
        CGFloat maxZoomScale = _image.size.width/_cropSize.width/self.imageScale;
        if (maxZoomScale < 2.0) {
            maxZoomScale = 2.0;
        }
        _scrollView.maximumZoomScale = maxZoomScale;
        
        _scrollView.contentSize = self.imageView.frame.size;
        _scrollView.contentOffset = CGPointMake((self.imageView.frame.size.width-_scrollView.frame.size.width)/2,
                                                (self.imageView.frame.size.height-_scrollView.frame.size.height)/2);
        _imageView.center = CGPointMake(_scrollView.contentSize.width/2, _scrollView.contentSize.height/2);
        
        _scrollView.delegate = self;
        
        //隐藏滚动条
        
        _scrollView.showsVerticalScrollIndicator = NO;
        
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (ZYCropView *)cropView {
    if (!_cropView) {
        _cropView = [[ZYCropView alloc] initWithFrame:CGRectMake(0, 0, ZYScreenWidth, ZYScreenHeight)];
        _cropView.hitView = self.scrollView;
        
        //中间镂空的矩形框
        CGRect myRect = self.scrollView.frame;
        //背景
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:_cropView.bounds];
        //镂空
        UIBezierPath *circlePath = [UIBezierPath bezierPathWithRect:myRect];
        if (_isCircular) {
            circlePath = [UIBezierPath bezierPathWithOvalInRect:myRect];
        }
        [path appendPath:circlePath];
        [path setUsesEvenOddFillRule:YES];
        
        CAShapeLayer *fillLayer = [CAShapeLayer layer];
        fillLayer.path = path.CGPath;
        fillLayer.fillRule = kCAFillRuleEvenOdd;//中间镂空的关键点 填充规则
        fillLayer.fillColor = [UIColor blackColor].CGColor;
        fillLayer.opacity = 0.5;
        
        CAShapeLayer *borderLayer = [CAShapeLayer layer];
        UIBezierPath *borderPath = [UIBezierPath bezierPathWithRect:myRect];
        if (_isCircular) {
            borderPath = [UIBezierPath bezierPathWithOvalInRect:myRect];
        }
        borderLayer.path = borderPath.CGPath;
        borderLayer.fillColor = [UIColor clearColor].CGColor;
        borderLayer.strokeColor = [UIColor whiteColor].CGColor;
        borderLayer.lineWidth = 1.0f;
        [fillLayer addSublayer:borderLayer];
        
        [_cropView.layer addSublayer:fillLayer];
        
    }
    return _cropView;
}

- (void)setCropSize:(CGSize)cropSize {
    NSAssert(_cropSize.width<=ZYScreenWidth, @"截取大小不得超出屏幕");
    NSAssert(_cropSize.height<=ZYScreenHeight, @"截取大小不得超出屏幕");
    _cropSize = cropSize;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageView;
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    
    CGFloat xcenter = scrollView.contentSize.width/2;
    
    CGFloat ycenter = scrollView.contentSize.height/2;
    
    [_imageView setCenter:CGPointMake(xcenter, ycenter)];
}

- (void)dismiss:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
    // if pop to imagePickerController, the retake button and use photo button can't click; so ...
    // [self.navigationController popViewControllerAnimated:true];
}

- (void)select:(id)sender {
    
    // 足够大的画布, 才能保证足够的清晰度
    UIGraphicsBeginImageContextWithOptions(self.imageView.frame.size, NO, self.imageScale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.imageView.layer renderInContext:context];
    [_image drawInRect:CGRectMake(0, 0, self.imageView.frame.size.width, self.imageView.frame.size.height)];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGRect rect = CGRectMake(self.scrollView.contentOffset.x * self.imageScale,
                             self.scrollView.contentOffset.y * self.imageScale,
                             _cropSize.width * self.imageScale,
                             _cropSize.height * self.imageScale);
    CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, rect);
    UIImage *cropImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    // 圆形图片
    if (_isCircular) {
        UIGraphicsBeginImageContext(cropImage.size);
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGRect cirRect = CGRectMake(0, 0, cropImage.size.width, cropImage.size.height);
        CGContextAddEllipseInRect(ctx, cirRect);
        CGContextClip(ctx);
        [cropImage drawInRect:cirRect];
        cropImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    
    NSData * imageData = UIImageJPEGRepresentation(cropImage, 1);
    _formData.data = imageData;
    
    !_selectBlock?:_selectBlock(cropImage ,_formData);
    
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
