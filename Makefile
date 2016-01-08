### Setup

artsy: certs
	git submodule init
	git submodule update
	config/spacecommander/setup-repo.sh

oss:
	bundle -v >/dev/null 2>&1 || { echo "Energy requires bundler, but it's not installed.  You can install it via '[sudo] gem install bundler'. If you are new to ruby, we *strongly* recommend using a sudo-less installation: https://guides.cocoapods.org/using/getting-started.html#sudo-less-installation" >&2; exit 1; }
	xcode-select -p >/dev/null 2>&1 || { echo "Energy requires that Apple's command line Xcode tools are installed.  You can install them by running: 'xcode-select --install'. " >&2; exit 1; }
	bundle install
	$(MAKE) ci_keys
	find . -type f -name 'ArtsyPartner-Prefix.pch' -exec sed -i '' 's/ARIsOSSBuild = NO;/ARIsOSSBuild = YES;/g'  {} +
	bundle exec pod install

### Xcode tooling

WORKSPACE = "Artsy Folio.xcworkspace"
SCHEME = ArtsyFolio
CONFIGURATION = Debug
DEVICE_HOST = platform='iOS Simulator',OS='8.4',name='iPad Retina'

build:
	set -o pipefail && xcodebuild -workspace $(WORKSPACE) -scheme $(SCHEME) -configuration '$(CONFIGURATION)' -sdk iphonesimulator build | tee $(CIRCLE_ARTIFACTS)/xcode_build_raw.log | bundle exec xcpretty -c

test:
	set -o pipefail && xcodebuild -workspace $(WORKSPACE) -scheme $(SCHEME) -configuration Debug build test -sdk iphonesimulator -destination $(DEVICE_HOST) | bundle exec second_curtain | tee $(CIRCLE_ARTIFACTS)/xcode_test_raw.log  | bundle exec xcpretty -c --test --report junit --output $(CIRCLE_TEST_REPORTS)/xcode/results.xml

### Useful commands

mogenerate:
	@printf 'What is the new Core Data version? '; \
		read CORE_DATA_VERSION; \
		mogenerator -m "Resources/CoreData/ArtsyPartner.xcdatamodeld/ArtsyFolio v$$CORE_DATA_VERSION.xcdatamodel/" --base-class ARManagedObject --template-path config/mogenerator/artsy --machine-dir Classes/Models/Generated/ --human-dir /tmp/ --template-var arc=true

storyboard_ids:
	bundle exec sbconstants Classes/Util/App/ARStoryboardIdentifiers.h

certs:
	bundle exec match appstore --readonly

### Git Faffing

deploy_if_beta_branch:
	if [ "$(LOCAL_BRANCH)" == "beta" ]; then make certs; bundle exec fastlane beta; fi

deploy:
	git push origin "$(LOCAL_BRANCH):beta"

LOCAL_BRANCH := $(shell git rev-parse --abbrev-ref HEAD)
BRANCH = $(shell echo $(shell whoami)-$(shell git rev-parse --abbrev-ref HEAD))

pr:
	if [ "$(LOCAL_BRANCH)" == "master" ]; then echo "In master, not PRing"; else git push origin "$(LOCAL_BRANCH):$(BRANCH)"; open "https://github.com/artsy/energy/pull/new/artsy:master...$(BRANCH)"; fi

push:
	if [ "$(LOCAL_BRANCH)" == "master" ]; then echo "In master, not pushing"; else git push origin $(LOCAL_BRANCH):$(BRANCH); fi

fpush:
	if [ "$(LOCAL_BRANCH)" == "master" ]; then echo "In master, not pushing"; else git push origin $(LOCAL_BRANCH):$(BRANCH) --force; fi
