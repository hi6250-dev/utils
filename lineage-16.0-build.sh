#!/usr/bin/env bash

#
# LineageOS 16.0 build script
#

ORG_URL="https://github.com/LineageOS"
MANIFEST_URL="git://github.com/LineageOS/android.git"
BRANCH="lineage-16.0"

repo init -u $MANIFEST_URL -b $BRANCH
repo sync --force-sync -c -q --no-tag --no-clone-bundle --optimized-fetch --current-branch -f -j16 || exit 0

git clone $ORG_URL/android_device_huawei_anne -b $BRANCH device/huawei/anne
git clone $ORG_URL/android_device_huawei_figo -b $BRANCH device/huawei/figo
git clone $ORG_URL/android_device_huawei_hi6250-common -b $BRANCH device/huawei/hi6250-common
git clone $ORG_URL/android_kernel_huawei_hi6250 -b $BRANCH kernel/huawei/hi6250
git clone https://github.com/TheMuppets/proprietary_vendor_huawei -b $BRANCH vendor/huawei

# Missing webview fix
cd external/chromium-webview
git fetch https://github.com/hi6250-dev/android_external_chromium-webview
git cherry-pick 84b050d060209eb692a341d3cf12059cc8d221ca # Revert "Move webview to /product" 
cd ../..

. build/envsetup.sh
lunch lineage_anne-userdebug
mka bacon -j32

sleep 5

lunch lineage_figo-userdebug
mka bacon -j32
