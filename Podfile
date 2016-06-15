# Uncomment this line to define a global platform for your project
platform :ios, '9.0'
# Uncomment this line if you're using Swift
use_frameworks!

target 'Fleks' do
  pod 'Firebase'
  pod 'Firebase/Database'
  pod 'Firebase/Auth'
  pod 'Bolts'
  pod 'FBSDKCoreKit'
  pod 'FBSDKShareKit'
  pod 'FBSDKLoginKit'
end

def testing_pods
    pod 'Quick', '~> 0.9.0'
    pod 'Nimble', '~> 3.2.0'
end

target 'FleksTests' do
  testing_pods
end

target 'FleksUITests' do
  testing_pods
end
