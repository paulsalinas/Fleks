# Uncomment this line to define a global platform for your project
platform :ios, '9.0'
# Uncomment this line if you're using Swift
use_frameworks!

def shared_pods
  pod 'Firebase'
  pod 'Firebase/Database'
  pod 'Firebase/Auth'
  pod 'Bolts'
  pod 'FBSDKCoreKit'
  pod 'FBSDKShareKit'
  pod 'FBSDKLoginKit'
  pod 'ReactiveCocoa', '~> 4.2.1'
end

def testing_pods
    pod 'Quick', '~> 0.9.0'
    pod 'Nimble', '~> 3.2.0'
end

target 'Fleks' do
  shared_pods
  
  target 'FleksTests' do
      inherit! :search_paths
      testing_pods
  end
  
  target 'FleksUITests' do
      inherit! :search_paths
      testing_pods
  end
end






