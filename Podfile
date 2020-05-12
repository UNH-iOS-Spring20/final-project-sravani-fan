# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

source 'https://github.com/CocoaPods/Specs.git'
target 'MyReseau' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for MyReseau
pod 'Alamofire'
pod 'Kingfisher'
pod 'LCNibBridge'
pod 'SnapKit'
pod 'PKHUD'
pod 'SwiftyJSON'
pod 'AnyCodable-FlightSchool'
pod 'IQKeyboardManagerSwift'
pod 'ApplyStyleKit'
pod 'TangramKit'
pod 'JXPopupView'
pod 'TZImagePickerControllerSwift'
pod 'MJRefresh'
pod 'KakaJSON', '~> 1.1.2'
pod 'Firebase/Analytics'
pod 'Firebase/Auth'
pod 'Firebase/Firestore'
pod 'Firebase/RemoteConfig'
pod 'FirebaseFirestoreSwift'
pod 'Firebase/Core'
pod 'Firebase/Storage'




post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['ARCHS'] = '$ARCHS_STANDARD_64_BIT'
    end
  end
end

end
