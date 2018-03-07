//
//  ViewController.m
//  ZYImagePickerDemo
//
//  Created by WeiLuezh on 2017/7/13.
//  Copyright © 2017年 Daniel. All rights reserved.
//

#import "ViewController.h"
#import "ZYImagePicker.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView1;
@property (weak, nonatomic) IBOutlet UIImageView *imgView2;
@property (weak, nonatomic) IBOutlet UIImageView *imgView3;
@property (weak, nonatomic) IBOutlet UIImageView *imgView4;
@property (weak, nonatomic) IBOutlet UIImageView *imgView5;
@property (weak, nonatomic) IBOutlet UIImageView *imgView6;
@property (weak, nonatomic) IBOutlet UIImageView *imgView7;
@property (weak, nonatomic) IBOutlet UILabel *lab1;
@property (weak, nonatomic) IBOutlet UILabel *lab2;
@property (weak, nonatomic) IBOutlet UILabel *lab3;
@property (weak, nonatomic) IBOutlet UILabel *lab4;
@property (weak, nonatomic) IBOutlet UILabel *lab5;
@property (weak, nonatomic) IBOutlet UILabel *lab6;
@property (weak, nonatomic) IBOutlet UILabel *lab7;

@property (nonatomic, strong)ZYImagePicker *imagePicker;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _imagePicker = [ZYImagePicker new];
    
    
    [_imgView1 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgView1Click:)]];
    [_imgView2 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgView2Click:)]];
    [_imgView3 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgView3Click:)]];
    [_imgView4 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgView4Click:)]];
    [_imgView5 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgView5Click:)]];
    [_imgView6 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgView6Click:)]];
    [_imgView7 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgView7Click:)]];
}

// default compressWidth 500
- (void)imgView1Click:(UIGestureRecognizer *)ges {
    __weak typeof(self) weakSelf = self;
    
    [self actionSheetWithLibrary:^{
        [_imagePicker libraryPhotoWithController:self compressWidth:0 formDataBlock:^(UIImage *image, ZYFormData *formData) {
            __strong typeof(self) strongSelf = weakSelf;
            [(UIImageView *)ges.view setImage:image];
            strongSelf.lab1.text = [NSString stringWithFormat:@"%.1lf x %.1lf",
                                    image.size.width,
                                    image.size.height];
        }];
    } cameraBlock:^{
        [_imagePicker cameraPhotoWithController:self compressWidth:0 formDataBlock:^(UIImage *image, ZYFormData *formData) {
            __strong typeof(self) strongSelf = weakSelf;
            [(UIImageView *)ges.view setImage:image];
            strongSelf.lab1.text = [NSString stringWithFormat:@"%.1lf x %.1lf",
                                    image.size.width,
                                    image.size.height];
        }];
    }];
    
}

// compressWidth = 320
- (void)imgView2Click:(UIGestureRecognizer *)ges {
    __weak typeof(self) weakSelf = self;
    
    [self actionSheetWithLibrary:^{
        [_imagePicker libraryPhotoWithController:self compressWidth:320 formDataBlock:^(UIImage *image, ZYFormData *formData) {
            __strong typeof(self) strongSelf = weakSelf;
            [(UIImageView *)ges.view setImage:image];
            strongSelf.lab2.text = [NSString stringWithFormat:@"%.1lf x %.1lf",
                                    image.size.width,
                                    image.size.height];
        }];
    } cameraBlock:^{
        [_imagePicker cameraPhotoWithController:self compressWidth:320 formDataBlock:^(UIImage *image, ZYFormData *formData) {
            __strong typeof(self) strongSelf = weakSelf;
            [(UIImageView *)ges.view setImage:image];
            strongSelf.lab2.text = [NSString stringWithFormat:@"%.1lf x %.1lf",
                                    image.size.width,
                                    image.size.height];
        }];
    }];
    
}

// cropSize = (200, 200), imageScale = 1
- (void)imgView3Click:(UIGestureRecognizer *)ges {
    __weak typeof(self) weakSelf = self;
    
    [self actionSheetWithLibrary:^{
        [_imagePicker libraryPhotoWithController:self cropSize:CGSizeMake(200, 200) imageScale:1 isCircular:false formDataBlock:^(UIImage *image, ZYFormData *formData) {
            __strong typeof(self) strongSelf = weakSelf;
            [(UIImageView *)ges.view setImage:image];
            strongSelf.lab3.text = [NSString stringWithFormat:@"%.1lf x %.1lf",
                                    image.size.width,
                                    image.size.height];
        }];
    } cameraBlock:^{
        [_imagePicker cameraPhotoWithController:self cropSize:CGSizeMake(200, 200) imageScale:1 isCircular:false formDataBlock:^(UIImage *image, ZYFormData *formData) {
            __strong typeof(self) strongSelf = weakSelf;
            [(UIImageView *)ges.view setImage:image];
            strongSelf.lab3.text = [NSString stringWithFormat:@"%.1lf x %.1lf",
                                    image.size.width,
                                    image.size.height];
        }];
    }];
}

// cropSize = (200, 200), imageScale = 2
- (void)imgView4Click:(UIGestureRecognizer *)ges {
    __weak typeof(self) weakSelf = self;
    
    [self actionSheetWithLibrary:^{
        [_imagePicker libraryPhotoWithController:self cropSize:CGSizeMake(200, 200) imageScale:2 isCircular:false formDataBlock:^(UIImage *image, ZYFormData *formData) {
            __strong typeof(self) strongSelf = weakSelf;
            [(UIImageView *)ges.view setImage:image];
            strongSelf.lab4.text = [NSString stringWithFormat:@"%.1lf x %.1lf",
                                    image.size.width,
                                    image.size.height];
        }];
    } cameraBlock:^{
        [_imagePicker cameraPhotoWithController:self cropSize:CGSizeMake(200, 200) imageScale:2 isCircular:false formDataBlock:^(UIImage *image, ZYFormData *formData) {
            __strong typeof(self) strongSelf = weakSelf;
            [(UIImageView *)ges.view setImage:image];
            strongSelf.lab4.text = [NSString stringWithFormat:@"%.1lf x %.1lf",
                                    image.size.width,
                                    image.size.height];
        }];
    }];
}

// cropSize = (200, 200), imageScale = 1, isCircular = true
- (void)imgView5Click:(UIGestureRecognizer *)ges {
    __weak typeof(self) weakSelf = self;
    
    [self actionSheetWithLibrary:^{
        [_imagePicker libraryPhotoWithController:self cropSize:CGSizeMake(200, 200) imageScale:2 isCircular:true formDataBlock:^(UIImage *image, ZYFormData *formData) {
            __strong typeof(self) strongSelf = weakSelf;
            [(UIImageView *)ges.view setImage:image];
            strongSelf.lab5.text = [NSString stringWithFormat:@"%.1lf x %.1lf",
                                    image.size.width,
                                    image.size.height];
        }];
    } cameraBlock:^{
        [_imagePicker cameraPhotoWithController:self cropSize:CGSizeMake(200, 200) imageScale:2 isCircular:true formDataBlock:^(UIImage *image, ZYFormData *formData) {
            __strong typeof(self) strongSelf = weakSelf;
            [(UIImageView *)ges.view setImage:image];
            strongSelf.lab5.text = [NSString stringWithFormat:@"%.1lf x %.1lf",
                                    image.size.width,
                                    image.size.height];
        }];
    }];
}

// cropSize = (200, 300), imageScale = 1, isCircular = true
- (void)imgView6Click:(UIGestureRecognizer *)ges {
    __weak typeof(self) weakSelf = self;
    
    [self actionSheetWithLibrary:^{
        [_imagePicker libraryPhotoWithController:self cropSize:CGSizeMake(200, 300) imageScale:0 isCircular:true formDataBlock:^(UIImage *image, ZYFormData *formData) {
            __strong typeof(self) strongSelf = weakSelf;
            [(UIImageView *)ges.view setImage:image];
            strongSelf.lab6.text = [NSString stringWithFormat:@"%.1lf x %.1lf",
                                    image.size.width,
                                    image.size.height];
        }];
    } cameraBlock:^{
        [_imagePicker cameraPhotoWithController:self cropSize:CGSizeMake(200, 300) imageScale:0 isCircular:true formDataBlock:^(UIImage *image, ZYFormData *formData) {
            __strong typeof(self) strongSelf = weakSelf;
            [(UIImageView *)ges.view setImage:image];
            strongSelf.lab6.text = [NSString stringWithFormat:@"%.1lf x %.1lf",
                                    image.size.width,
                                    image.size.height];
        }];
    }];
}

- (void)imgView7Click:(UIGestureRecognizer *)ges {
    __weak typeof(self) weakSelf = self;
    [self actionSheetWithLibrary:^{
        __strong typeof(self) strongSelf = weakSelf;
        [_imagePicker libraryMoiveWithController:self maximumDuration:11 formDataBlock:^(UIImage *thumbnail, ZYFormData *formData) {
            [(UIImageView *)ges.view setImage:thumbnail];
            strongSelf.lab7.text = formData.fileUrl.absoluteString;
        }];
    } cameraBlock:^{
        __strong typeof(self) strongSelf = weakSelf;
        [_imagePicker cameraMoiveWithController:self maximumDuration:3 formDataBlock:^(UIImage *thumbnail, ZYFormData *formData) {
            [(UIImageView *)ges.view setImage:thumbnail];
            strongSelf.lab7.text = formData.fileUrl.absoluteString;
        }];
    }];
}


- (void)actionSheetWithLibrary:(void(^)())block1 cameraBlock:(void(^)())block2 {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *libraryAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        !block1?:block1();
    }];
    
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"摄像头" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        !block2?:block2();
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:libraryAction];
    [alert addAction:cameraAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:true completion:nil];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
