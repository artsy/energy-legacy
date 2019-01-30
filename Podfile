source 'https://github.com/CocoaPods/Specs.git'
source 'https://github.com/artsy/Specs.git'

platform :ios, '8.0'

# Yep.
inhibit_all_warnings!

plugin 'cocoapods-keys', {
    :project => "Folio",
    :target => "ArtsyFolio",
    :keys => [
    "ArtsyAPIClientSecret",
    "ArtsyAPIClientKey",
    "IntercomAppID",
    "IntercomAPIKey",
    "SegmentProduction",
    "SegmentBeta",
    "SegmentDev",
    "SentryDSN"
]}

target 'ArtsyFolio' do
    # Artsy
    pod 'Artsy+UIColors'
    pod 'UIView+BooleanAnimations'
    pod 'ORStackView'
    pod 'Artsy+Authentication', :subspecs => ["email"]
    pod 'Artsy+UILabels'
    pod 'Artsy+UIFonts'

    # Nicities
    pod 'ObjectiveSugar', :git => 'https://github.com/supermarin/ObjectiveSugar.git'
    pod 'KVOController'

    # Networking
    pod 'Reachability', '~> 3.0'
    pod 'AFNetworking', :git => "https://github.com/orta/AFNetworking", :branch => "no_ifdefs"
    pod 'ISO8601DateFormatter', '~> 0.7'

    # Misc
    pod 'DRBOperationTree', '0.0.1'
    pod 'SFHFKeychainUtils', '~> 0.0.1'
    pod 'ZipArchive'
    pod 'WYPopoverController', :git => 'https://github.com/orta/WYPopoverController.git', :branch => 'artsy'
    pod 'JLRoutes'

    # Templating
    pod 'GHMarkdownParser'
    pod 'GRMustache', '~> 7.0'

    # Analytics
    pod 'ARAnalytics', :subspecs => ['Segmentio'], :git => 'https://github.com/orta/ARAnalytics.git'
    pod 'Intercom'

    # Logging
    pod 'CocoaLumberjack', '~> 1.0'
    pod 'SSDataSources'

    # @weakify / @strongify / @keypath
    pod 'libextobjc/EXTKeyPathCoding', '~> 0.3'
    pod 'libextobjc/EXTScope', '~> 0.3'
    pod 'SDWebImage', '~> 3.0'

    pod 'TPKeyboardAvoiding', :git => 'https://github.com/michaeltyson/TPKeyboardAvoiding.git'
    pod 'ARTiledImageView', :git => 'https://github.com/dblock/ARTiledImageView.git'
    pod 'ARCollectionViewMasonryLayout'
    pod 'FLKAutoLayout', '0.1.1'

    # This is not an Artsy project
    pod 'ARGenericTableViewController', :git => 'https://github.com/orta/ARGenericTableViewController.git'

    # For crash reporting
    pod 'Sentry', :git => 'https://github.com/getsentry/sentry-cocoa.git', :tag => '4.1.0'

    target 'ArtsyFolio Tests' do
        inherit! :search_paths

        pod 'Specta'
        pod 'Expecta'
        pod 'OHHTTPStubs', '~> 3.0'

        pod 'Expecta+Snapshots', "2.0.0"
        pod 'Expecta+ContainerClasses', '~> 1.0'
        pod 'Expecta+Comparison', '~> 0.1'

        pod 'XCTest+OHHTTPStubSuiteCleanUp'
        pod 'OCMock'
        pod 'Forgeries/Mocks', :git => "https://github.com/ashfurrow/Forgeries.git"
    end
end
