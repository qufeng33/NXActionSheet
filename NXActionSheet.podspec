Pod::Spec.new do |s|

s.name          = "NXActionSheet"
s.version       = "0.1.0"
s.summary       = "A custom ActionSheet used in iOS."
s.homepage      = "https://github.com/qufeng33/NXActionSheet"
s.license       = "MIT"
s.author        = { "nightx" => "qufeng33@hotmail.com" }
s.source        = { :git => "https://github.com/qufeng33/NXActionSheet.git", :tag => s.version.to_s }
s.source_files  = "NXActionSheet/*.{h,m}"
s.platform      = :ios, '7.0'
s.requires_arc  = true

end