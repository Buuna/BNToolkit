Pod::Spec.new do |s|
  s.name         = "BNToolkit"
  s.version      = "0.0.2"
  s.summary      = "A set of commonly used classes and utility functions."
  s.author       = { "dan" => "dan@buuna.com" }
  s.homepage     = 'https://github.com/Buuna/BNToolkit'
  s.license      = { :type => 'COMMERCIAL', :text => <<-LICENSE 
				Copyright 2014 Buuna Pty Ltd
		        LICENSE
		   }
  s.platform     = :ios, '6.0'
  s.source       = { :git => "https://github.com/Buuna/BNToolkit.git", :tag => "0.0.2" }
  s.public_header_files = 'BNToolkit/*.h'
  s.source_files  = 'BNToolkit/*'
  s.requires_arc = true

  s.subspec 'Facebook' do |fb|
    fb.dependency 'Facebook-iOS-SDK', '~> 3.8.0'
    fb.source_files = 'BNToolkit/BNFacebookManager/*'
    fb.public_header_files = 'BNToolkit/BNFacebookManager/*.h'
  end

end

