
Pod::Spec.new do |spec|

  spec.name         = "GTCamera"
  spec.version      = "0.2.7"
  spec.summary      = "Simple image selection view controller with camera library and aws s3 bucket images for swift ios13"

  spec.description  = <<-DESC
			Simple image slecctor view controller with camera library and aws s3 bucket images for swift5 ios13
                   DESC

  spec.homepage     = "https://github.com/sera4am/GTCamera"
  spec.license      = { :type => "MIT", :file => "LISENCE" }
  spec.author             = { "sera4am" => "sera@4am.jp" }
  spec.platform     = :ios, "13.0"

  spec.source       = { :git => "https://github.com/sera4am/GTCamera.git", :tag => "#{spec.version}" }


  spec.source_files  = "GTCamera", "GTCamera/**/*.{swift,h}"

  spec.dependency 'AWSS3'
  spec.dependency 'TOCropViewController'
  spec.dependency 'Kingfisher'

  spec.requires_arc = true
  spec.swift_version = "5.0"
end

