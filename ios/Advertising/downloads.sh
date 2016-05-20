#!/bin/sh
set -e

cd "`dirname $0`"

#
# Downloading GoogleMobileAdsSdkiOS.framework
#
test -e googlemobileadssdkios.zip || curl -o googlemobileadssdkios.zip http://dl.google.com/googleadmobadssdk/googlemobileadssdkios.zip
unzip googlemobileadssdkios.zip
rm -fr GoogleMobileAdsSdkiOS
mv GoogleMobileAdsSdkiOS-* GoogleMobileAdsSdkiOS

#while test ! -e mm-ad-sdk-ios-*.zip; do
#    echo
#    echo "MMedia SDK not found."
#    echo
#    echo "Please download mmedia SDK from here: http://mmedia.com/resources/sdk-api/"
#    echo "Copy it to this directory (`pwd`/`dirname $0`)"
#    echo "Then press ENTER"
#    echo
#    read X
#done
#unzip -o mm-ad-sdk-ios-*.zip
#rm -fr MMAdSDK.framework
#mv mm-ad-sdk-ios-*/MMAdSDK.framework .

#
# Downloading MillennialMedia.framework
#
mkdir -p MillennialMedia.framework/Headers
test -e MillennialMedia.framework/Headers/MMSDK.h || \
    curl https://raw.githubusercontent.com/floatinghotpot/cordova-plugin-mmedia/master/src/ios/MillennialMedia.framework/Headers/MMSDK.h >> MillennialMedia.framework/Headers/MMSDK.h
test -e MillennialMedia.framework/Headers/MMAdView.h || \
    curl https://raw.githubusercontent.com/floatinghotpot/cordova-plugin-mmedia/master/src/ios/MillennialMedia.framework/Headers/MMAdView.h >> MillennialMedia.framework/Headers/MMAdView.h
test -e MillennialMedia.framework/Headers/MMInterstitial.h || \
    curl https://raw.githubusercontent.com/floatinghotpot/cordova-plugin-mmedia/master/src/ios/MillennialMedia.framework/Headers/MMInterstitial.h >> MillennialMedia.framework/Headers/MMInterstitial.h
test -e MillennialMedia.framework/Headers/MMRequest.h || \
    curl https://raw.githubusercontent.com/floatinghotpot/cordova-plugin-mmedia/master/src/ios/MillennialMedia.framework/Headers/MMRequest.h >> MillennialMedia.framework/Headers/MMRequest.h
test -e MillennialMedia.framework/MillennialMedia || \
    curl https://raw.githubusercontent.com/floatinghotpot/cordova-plugin-mmedia/master/src/ios/MillennialMedia.framework/MillennialMedia >> MillennialMedia.framework/MillennialMedia
