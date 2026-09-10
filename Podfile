# Uncomment the next line to define a global platform for your project
platform :ios, '16.0'

target 'wattpad-translate' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  pod 'Alamofire'
  pod 'SwiftSoup'
  pod 'GoogleMLKit/Translate', '3.2.0'

end

post_install do |installer|
  installer.pods_project.targets.each do |t|
    t.build_configurations.each do |c|
      c.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '16.0'
    end
  end
end
