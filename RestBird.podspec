Pod::Spec.new do |s|
  s.name                    = "RestBird"
  s.version                 = "0.5.1"
  s.homepage                = "https://github.com/halcyonmobile/RestBird"
  s.license                 = { :type => "MIT", :file => "LICENSE" }
  s.author                  = "Halcyon Mobile"
  s.summary                 = "Lightweight, stateless REST network manager over the Codable protocol."
  
  s.swift_version           = "5.0"
  
  s.ios.deployment_target   = '10.0'
  s.osx.deployment_target   = '10.10'
  
  s.source                  = { :git => "https://github.com/halcyonmobile/RestBird.git", :tag => "#{s.version}" }
  
  s.source_files          = "Sources/RestBird/**/*.swift"
  s.dependency            "Alamofire"
end
