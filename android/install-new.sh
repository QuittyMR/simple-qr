#!/usr/bin/env bash

set -e

DEBUG_PORT=${1:?"Must provide debug port"}

./gradlew app:assembleDebug

adb connect 192.168.0.9:${DEBUG_PORT}
pushd app/build/outputs/apk/debug/
	adb install app-debug.apk
popd
