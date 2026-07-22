SHELL := /bin/bash

.PHONY: setup format format-check analyze test coverage docs example generate goldens publish-dry-run pana check clean

setup:
	test -f pubspec_overrides.yaml || cp pubspec_overrides.yaml.example pubspec_overrides.yaml
	test -f example/pubspec_overrides.yaml || cp example/pubspec_overrides.yaml.example example/pubspec_overrides.yaml
	fvm flutter pub get
	cd example && fvm flutter pub get

format:
	fvm dart format lib test example/lib/main.dart

format-check:
	fvm dart format --output none --set-exit-if-changed lib test example/lib/main.dart

analyze:
	fvm flutter analyze --fatal-infos

test:
	@if [ "$$CI" = "true" ]; then \
		fvm flutter test; \
	else \
		fvm flutter test --exclude-tags golden; \
	fi

coverage:
	fvm flutter test --coverage

docs:
	rm -rf doc/api
	fvm dart doc --validate-links

example:
	cd example && fvm flutter analyze --fatal-infos

generate:
	fvm dart run build_runner build
	fvm dart format lib

goldens:
	CI=true fvm flutter test --update-goldens

publish-dry-run:
	fvm flutter pub publish --dry-run

pana:
	fvm dart pub global activate pana
	fvm dart pub global run pana .

check: format-check analyze test docs example

clean:
	fvm flutter clean
	cd example && fvm flutter clean
