platform:ios,’15.0’
use_frameworks!
target “CarOilMaintain" do

pod 'Charts'
#pod 'RealmSwift', '~> 2.0.4'
pod 'AEXML'
pod 'SwiftyDropbox’

post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['SWIFT_VERSION'] = '5.0'
      end
    end
  end

end
