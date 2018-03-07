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
@property (nonatomic, strong)ZYImagePicker *imagePicker;
```

```objc
_imagePicker = [ZYImagePicker new];
```

##### Gets the picture of the specified width.
```objc
[_imagePicker libraryPhotoWithController:self compressWidth:320 FormDataBlock:^(UIImage *image, ZYFormData *formData) {
      // you code
}];
```

##### Cut out rectangles or circles / ellipses.
```objc
[_imagePicker libraryPhotoWithController:self cropSize:CGSizeMake(200, 200) imageScale:1 isCircular:false FormDataBlock:^(UIImage *image, ZYFormData *formData) {
      // you code
}];
```

![image](https://github.com/Yanyinghenmei/ZYImagePicker/raw/master/gifs/image.gif)
![image](https://github.com/Yanyinghenmei/ZYImagePicker/raw/master/gifs/image2.gif)
![image](https://github.com/Yanyinghenmei/ZYImagePicker/raw/master/gifs/image3.gif)
