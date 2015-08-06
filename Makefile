artsy:
	git submodule init
	git submodule update
	config/spacecommander/setup-repo.sh

oss: ci_keys
	find . -type f -name 'ArtsyPartner-Prefix.pch' -exec sed -i '' 's/ARIsOSSBuild = NO;/ARIsOSSBuild = YES;/g'  {} +

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

mogenerate:
	@printf 'What is the new Core Data version? '; \
		read CORE_DATA_VERSION; \
		mogenerator -m "Resources/CoreData/ArtsyPartner.xcdatamodeld/ArtsyFolio v$$CORE_DATA_VERSION.xcdatamodel/" --base-class ARManagedObject --template-path config/mogenerator/artsy --machine-dir Classes/Models/Generated/ --human-dir /tmp/ --template-var arc=true

LOCAL_BRANCH := $(shell git rev-parse --abbrev-ref HEAD)
BRANCH = $(shell echo $(shell whoami)-$(shell git rev-parse --abbrev-ref HEAD))

pr:
	if [ "$(LOCAL_BRANCH)" == "master" ]; then echo "In master, not PRing"; else git push upstream "$(LOCAL_BRANCH):$(BRANCH)"; open -a "Google Chrome" "https://github.com/artsy/energy/pull/new/artsy:master...$(BRANCH)"; fi

push:
	if [ "$(LOCAL_BRANCH)" == "master" ]; then echo "In master, not pushing"; else git push upstream $(LOCAL_BRANCH):$(BRANCH); fi

fpush:
	if [ "$(LOCAL_BRANCH)" == "master" ]; then echo "In master, not pushing"; else git push upstream $(LOCAL_BRANCH):$(BRANCH) --force; fi

test:
	set -o pipefail && xcodebuild -destination "OS=7.1,name=iPad Retina" -scheme "ArtsyFolio" -workspace "Artsy Folio.xcworkspace" test GCC_INSTRUMENT_PROGRAM_FLOW_ARCS=YES GCC_GENERATE_TEST_COVERAGE_FILES=YES | xcpretty --color --test