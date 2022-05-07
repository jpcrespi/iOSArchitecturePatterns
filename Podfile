source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '11.4'

def common
  pod 'Alamofire'
  pod 'SwiftExtension', git: 'https://gitlab.com/jpcrespi/swift-extension.git'
  pod 'SwiftExtension/Alamofire', git: 'https://gitlab.com/jpcrespi/swift-extension.git'
end

target 'iOSArchitectureMVC' do
  use_frameworks!
  common
end

target 'iOSArchitectureMVP' do
  use_frameworks!
  common
end

target 'iOSArchitectureMVVM' do
  use_frameworks!
  common

  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'SwiftLint'
end

target 'iOSArchitectureVIPER' do
  use_frameworks!
  common
end

target 'iOSArchitectureMVI' do
  use_frameworks!
  common
end
