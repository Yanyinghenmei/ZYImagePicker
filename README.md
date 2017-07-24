# ZYImagePicker

1. Gets the picture of the specified width.
2. Cut out rectangles or circles / ellipses.

## How to use
Download ZYImagePicker and try out the included you iPhone project or use [CocoaPods](http://cocoapods.org).

#### Podfile

To integrate ZYImagePicker into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'

target 'TargetName' do
pod 'ZYImagePicker', '~> 0.0.5'
end
```

Then, run the following command:

```bash
$ pod install
```

## Simple code

##### _imagePicker must be a strong reference
```objc
_imagePicker = [ZYImagePicker new];
```

##### Gets the picture of the specified width.
```objc
[_imagePicker libraryPhotoWithController:self compressWidth:320 FormDataBlock:^(UIImage *image, ZYFormData *formData) {
            __strong typeof(self) strongSelf = weakSelf;
            [(UIImageView *)ges.view setImage:image];
            strongSelf.lab2.text = [NSString stringWithFormat:@"%.1lf x %.1lf",
                                    image.size.width,
                                    image.size.height];
        }];
```

##### Cut out rectangles or circles / ellipses.
```objc
[_imagePicker libraryPhotoWithController:self cropSize:CGSizeMake(200, 200) imageScale:1 isCircular:false FormDataBlock:^(UIImage *image, ZYFormData *formData) {
            __strong typeof(self) strongSelf = weakSelf;
            [(UIImageView *)ges.view setImage:image];
            strongSelf.lab3.text = [NSString stringWithFormat:@"%.1lf x %.1lf",
                                    image.size.width,
                                    image.size.height];
        }];
```

![image](https://github.com/Yanyinghenmei/ZYImagePicker/raw/master/gifs/image.gif)
![image](https://github.com/Yanyinghenmei/ZYImagePicker/raw/master/gifs/image2.gif)
![image](https://github.com/Yanyinghenmei/ZYImagePicker/raw/master/gifs/image3.gif)
