Pod::Spec.new do |s|
  s.name = "HidesNavigationBarWhenPushed"
  s.version = "1.0.1"
  s.summary = "A library, which adds the ability to hide navigation bar when view controller is pushed via hidesNavigationBarWhenPushed flag"
  s.homepage = "https://github.com/gontovnik/HidesNavigationBarWhenPushed"
  s.license = { :type => "MIT", :file => "LICENSE" }
  s.author = { "Danil Gontovnik" => "danil@gontovnik.com" }
  s.source = { :git => "https://github.com/gontovnik/HidesNavigationBarWhenPushed.git",
               :tag => "#{s.version}" }
  s.source_files = "HidesNavigationBarWhenPushed/*.swift"
  s.platform = :ios, '11.0'
  s.ios.deployment_target = '11.0'
  s.ios.frameworks = ['UIKit', 'Foundation']
  s.swift_version = '4.1'
end
