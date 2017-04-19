### Setup

artsy:
	git submodule init
	git submodule update
	config/spacecommander/setup-repo.sh
	git update-index --assume-unchanged Classes/ARAppDelegate+DevTools.m

oss:
	bundle -v >/dev/null 2>&1 || { echo "Energy requires bundler, but it's not installed.  You can install it via '[sudo] gem install bundler'. If you are new to ruby, we *strongly* recommend using a sudo-less installation: https://guides.cocoapods.org/using/getting-started.html#sudo-less-installation" >&2; exit 1; }
	xcode-select -p >/dev/null 2>&1 || { echo "Energy requires that Apple's command line Xcode tools are installed.  You can install them by running: 'xcode-select --install'. " >&2; exit 1; }
	bundle install
	$(MAKE) ci_keys
	find . -type f -name 'ArtsyPartner-Prefix.pch' -exec sed -i '' 's/ARIsOSSBuild = NO;/ARIsOSSBuild = YES;/g'  {} +
	bundle exec pod install

ci_keys:
	bundle exec pod keys set "ArtsyAPIClientSecret" "3a33d2085cbd1176153f99781bbce7c6" Folio
	bundle exec pod keys set "ArtsyAPIClientKey" "e750db60ac506978fc70"
	bundle exec pod keys set "HockeyAppBetaID" "-"
	bundle exec pod keys set "HockeyAppLiveID" "-"
	bundle exec pod keys set "SegmentProduction" "-"
	bundle exec pod keys set "SegmentDev" "-"
	bundle exec pod keys set "SegmentBeta" "-"
	bundle exec pod keys set "IntercomAppID" "-"
	bundle exec pod keys set "IntercomAPIKey" "-"


### Xcode tooling

WORKSPACE = "Artsy Folio.xcworkspace"
SCHEME = ArtsyFolio
CONFIGURATION = Debug
DEVICE_HOST = platform='iOS Simulator',OS='10.3',name='iPad Air 2'

build:
	set -o pipefail && xcodebuild -workspace $(WORKSPACE) -scheme $(SCHEME) -configuration '$(CONFIGURATION)' -sdk iphonesimulator build | tee $(CIRCLE_ARTIFACTS)/xcode_build_raw.log | bundle exec xcpretty -c

test:
	set -o pipefail && xcodebuild -workspace $(WORKSPACE) -scheme $(SCHEME) -configuration Debug build test -sdk iphonesimulator -destination $(DEVICE_HOST) | bundle exec second_curtain | tee $(CIRCLE_ARTIFACTS)/xcode_test_raw.log  | bundle exec xcpretty -c --test --report junit --output $(CIRCLE_TEST_REPORTS)/xcode/results.xml

### Useful commands

mogenerate:
	@printf 'What is the new Core Data version? '; \
		read CORE_DATA_VERSION; \
		mogenerator -m "Resources/CoreData/ArtsyPartner.xcdatamodeld/ArtsyFolio v$$CORE_DATA_VERSION.xcdatamodel" --base-class ARManagedObject --machine-dir Classes/Models/Generated --human-dir /tmp --template-var arc=true
		for file in Classes/Models/Generated/*; do  \
			./config/spacecommander/format-objc-file.sh $$file; \
		done

storyboard_ids:
	bundle exec sbconstants Classes/Util/App/ARStoryboardIdentifiers.h

### Git Faffing

deploy_if_beta_branch:
	if [ "$(LOCAL_BRANCH)" == "beta" ]; then make install_fastlane; bundle exec fastlane beta; fi

install_fastlane:
	bundle update fastlane
	bundle install --with deployment

deploy:
	git push origin "$(LOCAL_BRANCH):beta"
	open "https://circleci.com/gh/artsy/energy/tree/beta"

LOCAL_BRANCH := $(shell git rev-parse --abbrev-ref HEAD)
BRANCH = $(shell echo $(shell whoami)-$(shell git rev-parse --abbrev-ref HEAD))

pr:
	if [ "$(LOCAL_BRANCH)" == "master" ]; then echo "In master, not PRing"; else git push origin "$(LOCAL_BRANCH):$(BRANCH)"; open "https://github.com/artsy/energy/pull/new/artsy:master...$(BRANCH)"; fi

push:
	if [ "$(LOCAL_BRANCH)" == "master" ]; then echo "In master, not pushing"; else git push origin $(LOCAL_BRANCH):$(BRANCH); fi

fpush:
	if [ "$(LOCAL_BRANCH)" == "master" ]; then echo "In master, not pushing"; else git push origin $(LOCAL_BRANCH):$(BRANCH) --force; fi
