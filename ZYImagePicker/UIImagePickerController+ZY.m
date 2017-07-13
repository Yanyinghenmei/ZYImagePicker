//
//  UIImagePickerController+ZY.m
//  JadeSource
//
//  Created by Daniel on 16/12/12.
//  Copyright © 2016年 Daniel. All rights reserved.
//

#import "UIImagePickerController+ZY.h"

@implementation UIImagePickerController (ZY)
- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.visibleViewController.preferredStatusBarStyle;
}

- (UIViewController *)childViewControllerForStatusBarStyle {
    UIViewController *viewController = self.visibleViewController;
    return viewController;
}

@end
