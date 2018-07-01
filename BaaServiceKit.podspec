Pod::Spec.new do |s|
  s.name         = "BaaServiceKit"
  s.version      = "0.1.0"
  s.summary      = "Fast and easy data submission to the Bitcoin blockchain "

  s.homepage     = "https://github.com/dirtydanee/BaaServiceKit"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "Daniel Metzing" => "daniel.metzing@gmail.com" }

  s.ios.deployment_target = "10.0"
  s.source       = { :path => './' }
  s.source_files  = "Source/**/*.swift"
  s.resources = 'Source/PersistencyService/CoreData/Models/*.xcdatamodeld'
  s.swift_version = '4.1'
  
  s.dependency 'Alamofire', '~> 4.7'
  s.dependency 'CryptoSwift', '~> 0.9'

end
