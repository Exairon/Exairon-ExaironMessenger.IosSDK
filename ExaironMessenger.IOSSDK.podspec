Pod::Spec.new do |spec|

  spec.name         = "ExaironMessenger.IOSSDK"
  spec.version      = "1.0.0"
  spec.summary      = "This is ExaironMessenger.IOSSDK."
  spec.description  = "This is ExaironMessenger.IOSSDK framework."

  spec.homepage     = "https://exairon.com"
  spec.license      = "MIT"
  spec.author       = { "Engin Ocal" => "engin.ocal@exairon.com" }
  spec.platform     = :ios, "15.0"
  spec.source       = { :git => "https://github.com/Exairon/Exairon-ExaironMessenger.IosSDK.git", :tag => spec.version.to_s }


  spec.source_files  = "Framework/**/*.{swift}"
  spec.swift_versions = "5.0"
  
  spec.dependency 'Socket.IO-Client-Swift', '~> 16.0.1'
  spec.dependency 'WrappingHStack', '~> 2.2.9'

end
