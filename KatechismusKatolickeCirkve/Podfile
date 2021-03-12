platform :ios, '10.0'
inhibit_all_warnings!

target 'KatechismusKatolickeCirkve' do
	use_frameworks!

  pod 'BonMot'
  pod 'Firebase/Analytics'
  pod 'NewPopMenu', '~> 2.0'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES'] = 'NO'
        end
    end
end
