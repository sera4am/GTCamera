
Pod::Spec.new do |spec|

  spec.name         = "GTCamera"
  spec.version      = "0.0.1"
  spec.summary      = "Simple image selection view controller with camera library and aws s3 bucket images"

  spec.description  = <<-DESC
                   DESC

  spec.homepage     = "https://github.com/sera4am/GTCamera"
  spec.license      = { :type => "MIT", :file => "LISENCE" }
  spec.author             = { "sera4am" => "sera@4am.jp" }
  spec.platform     = :ios, "13.0"

  spec.source       = { :git => "https://github.com/sera4am/GTCamera.git", :tag => "#{spec.version}" }


  spec.source_files  = "GTCamera", "GTCamera/**/*.{swift}"
  spec.requires_arc = true
  spec.swift_version = "5.0"
end

