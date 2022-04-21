### Setup

artsy:
	git submodule init
	git submodule update
	brew install mogenerator
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
	bundle exec pod keys set "SentryDSN" "-"
	bundle exec pod keys set "SegmentProduction" "-"
	bundle exec pod keys set "SegmentDev" "-"
	bundle exec pod keys set "SegmentBeta" "-"
	bundle exec pod keys set "IntercomAppID" "-"
	bundle exec pod keys set "IntercomAPIKey" "-"

### Xcode tooling

WORKSPACE = "Artsy Folio.xcworkspace"
SCHEME = ArtsyFolio
CONFIGURATION = Debug
DEVICE_HOST = platform='iOS Simulator',OS='11.2',name='iPad Air 2'

ci: CONFIGURATION = Debug
ci: build

build:
	if [ "$(LOCAL_BRANCH)" != "beta" ]; then set -o pipefail && xcodebuild -workspace $(WORKSPACE) -scheme $(SCHEME) -configuration '$(CONFIGURATION)' -sdk iphonesimulator build | tee ./xcode_build_raw.log | bundle exec xcpretty -c; else echo "Skipping test run on beta deploy."; fi

test:
	if [ "$(LOCAL_BRANCH)" != "beta" ]; then set -o pipefail && xcodebuild -workspace $(WORKSPACE) -scheme $(SCHEME) -configuration Debug build test -sdk iphonesimulator -destination $(DEVICE_HOST) | bundle exec second_curtain | tee ./xcode_test_raw.log  | bundle exec xcpretty -c --test --report junit --output ./results.xml; else echo "Skipping test run on beta deploy."; fi


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
	if [ "$(LOCAL_BRANCH)" == "beta" ]; then make install_fastlane; bundle exec fastlane beta; bundle exec fastlane upload_symbols; fi

install_fastlane:
	bundle update fastlane
	bundle install --with deployment
	brew install getsentry/tools/sentry-cli
	bundle exec fastlane update_plugins

deploy:
	git push origin "$(LOCAL_BRANCH):beta" -f
	open "https://circleci.com/gh/artsy/energy/tree/beta"

LOCAL_BRANCH := $(shell git rev-parse --abbrev-ref HEAD)
BRANCH = $(shell echo $(shell whoami)-$(shell git rev-parse --abbrev-ref HEAD))

pr:
	if [ "$(LOCAL_BRANCH)" == "main" ]; then echo "In main, not PRing"; else git push origin "$(LOCAL_BRANCH):$(BRANCH)"; open "https://github.com/artsy/energy/pull/new/artsy:main...$(BRANCH)"; fi

push:
	if [ "$(LOCAL_BRANCH)" == "main" ]; then echo "In main, not pushing"; else git push origin $(LOCAL_BRANCH):$(BRANCH); fi

fpush:
	if [ "$(LOCAL_BRANCH)" == "main" ]; then echo "In main, not pushing"; else git push origin $(LOCAL_BRANCH):$(BRANCH) --force; fi
