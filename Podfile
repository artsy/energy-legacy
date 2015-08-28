source 'https://github.com/CocoaPods/Specs.git'
source 'https://github.com/artsy/Specs.git'

platform :ios, '7.0'

# Yep.
inhibit_all_warnings!

plugin 'cocoapods-keys', {
    :project => "Folio",
    :keys => [
    "ArtsyAPIClientSecret",
    "ArtsyAPIClientKey",
    "HockeyAppBetaID",
    "HockeyAppLiveID",
    "IntercomAppID",
    "IntercomAPIKey",
    "SegmentProduction",
    "SegmentBeta",
    "SegmentDev"
]}

# Artsy
pod 'Artsy+UILabels'
pod 'Artsy+UIColors'
pod 'UIView+BooleanAnimations'
pod 'ORStackView'

if %w(orta ash artsy laura eloy sarahscott).include?(ENV['USER']) || ENV['CI'] == 'true'
  pod 'Artsy+UIFonts', '1.0.0'
else
  pod 'Artsy+OSSUIFonts'
end


# Nicities
pod 'ObjectiveSugar', :git => 'https://github.com/supermarin/ObjectiveSugar.git'

# Networking
pod 'Reachability', '~> 3.0'
pod 'AFNetworking', '~> 1.0'
pod 'ISO8601DateFormatter', '~> 0.7'

# Misc
pod 'DRBOperationTree', '0.0.1'
pod 'SFHFKeychainUtils', '~> 0.0.1'
pod 'ZipArchive'
pod 'WYPopoverController', :git => 'https://github.com/orta/WYPopoverController.git', :branch => 'artsy'
pod 'JLRoutes'

# Templating
pod 'GHMarkdownParser', '0.0.1'
pod 'GRMustache', '~> 7.0'

# Analytics
pod 'ARAnalytics', :subspecs => ['Segmentio', 'HockeyApp', 'Intercom'], :git => 'https://github.com/orta/ARAnalytics.git'

# Logging
pod 'CocoaLumberjack', '~> 1.0'
pod 'SSDataSources'

# @weakify / @strongify / @keypath
pod 'libextobjc/EXTKeyPathCoding', '~> 0.3'
pod 'libextobjc/EXTScope', '~> 0.3'

pod 'TPKeyboardAvoiding', :git => 'https://github.com/michaeltyson/TPKeyboardAvoiding.git'
pod 'ARTiledImageView', :git => 'https://github.com/dblock/ARTiledImageView.git'
pod 'ARCollectionViewMasonryLayout'
pod 'FLKAutoLayout', '0.1.1'

# This is not an Artsy project
pod 'ARGenericTableViewController', :git => 'https://github.com/orta/ARGenericTableViewController.git'

target 'ArtsyFolio Tests', :exclusive => true do
    pod 'Specta'
    pod 'Expecta'
    pod 'OHHTTPStubs', '~> 3.0'

    pod 'Expecta+Snapshots', "2.0.0"
    pod 'Expecta+ContainerClasses', '~> 1.0'
    pod 'Expecta+Comparison', '~> 0.1'

    pod 'Expecta+OCMock'
    pod 'XCTest+OHHTTPStubSuiteCleanUp'

    pod 'Forgeries'
end
