Pod::Spec.new do |s|
  s.name          = "VPBottomBar"
  s.version       = "1.0.0"
  s.summary       = "VPBottomBar"
  s.description   = "VPBottomBar - Custom Bar to Expand/Collapse menu items with animation"
  s.homepage      = "https://github.com/VickyPrajapati24/VPBottomBar"
  s.license       = "MIT"
  s.author        = "Vicky Prajapati"
  s.platform      = :ios, "11.0"
  s.swift_version = "5.0"
  s.source        = {
    :git => "https://github.com/VickyPrajapati24/VPBottomBar.git",
    :tag => "#{s.version}"
  }
  s.source_files        = "VPBottomBar/**/*.{h,m,swift}"
  s.public_header_files = "VPBottomBar/**/*.h"
end
