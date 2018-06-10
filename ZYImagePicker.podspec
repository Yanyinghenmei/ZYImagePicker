#

Pod::Spec.new do |s|

  s.name         = "ZYImagePicker"
  s.version      = "0.1.1"
  s.summary      = "A picture picker that specifies size and clipping"

  s.description  = <<-DESC
	You can specifies image width or clipping the image with any size.
                   DESC

  s.homepage     = "https://github.com/Yanyinghenmei/ZYImagePicker"
  
	s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author       = { "Yanyinghenmei" => "1113135372@qq.om" }
	s.platform		 = :ios, "8.0"
  s.source       = { :git => "https://github.com/Yanyinghenmei/ZYImagePicker.git", :tag => "#{s.version}" }

	s.source_files = "ZYImagePicker", "ZYImagePicker/**/*.{h,m}"
  s.resources    = "ZYImagePicker/ZYBundle.bundle"  

	s.requires_arc = true

end
