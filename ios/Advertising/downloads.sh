#!/bin/sh
set -e
test -e googlemobileadssdkios.zip || curl -o googlemobileadssdkios.zip http://dl.google.com/googleadmobadssdk/googlemobileadssdkios.zip
unzip googlemobileadssdkios.zip
rm -fr GoogleMobileAdsSdkiOS
mv GoogleMobileAdsSdkiOS-* GoogleMobileAdsSdkiOS
