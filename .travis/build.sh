#!/usr/bin/env bash

set -eo pipefail

BUILD_CMD="xcodebuild -project $TRAVIS_XCODE_PROJECT -scheme $TRAVIS_XCODE_SCHEME -configuration Release" 

#if [ -e $TRAVIS_TAG ]; then
#  $BUILD_CMD build analyze test | xcpretty
#else
  openssl aes-256-cbc -K $TRAVIS_ENC_KEY -iv $TRAVIS_ENC_IV \
    -in .travis/Codesign.p12.enc -out .travis/Codesign.p12 -d
  KEYCHAIN=build.keychain
  KEYCHAIN_PASS=travis
  
  security create-keychain -p $KEYCHAIN_PASS $KEYCHAIN
  security default-keychain -s $KEYCHAIN
  security import .travis/Codesign.p12 -k $KEYCHAIN -P "$C12PASSWORD" -A
  security set-key-partition-list -S apple-tool:,apple:,codesign: -s -k $KEYCHAIN_PASS $KEYCHAIN

  $BUILD_CMD CODE_SIGN_IDENTITY="$IDENTITY" build analyze test | xcpretty

  security delete-keychain $KEYCHAIN
#fi
