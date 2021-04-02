#!/bin/bash

set -e


tartgetPlatform=android-arm,android-arm64
flutter build apk --release --target-platform $tartgetPlatform --obfuscate --split-debug-info=../