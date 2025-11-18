export JAVA_HOME=$(/usr/libexec/java_home -v 17)

mkdir -p clients/android
cat > clients/android/local.properties <<EOF
sdk.dir=${ANDROID_SDK_ROOT}
ndk.dir=${ANDROID_NDK_HOME}
KEYSTORE_PASS=<YOUR_KEYSTORE_PASS>
ALIAS_NAME=<YOUR_ALIAS_NAME>
ALIAS_PASS=<YOUR_ALIAS_PASS>
EOF

# 1) Build libbox (native library)
make lib_install

# 2) Place AAR into the Android app
mkdir -p clients/android/app/libs
cp libbox.aar clients/android/app/libs

# 3) (Optional) Update app version like CI
# For manual run:
# go run -v ./cmd/internal/update_android_version
# Or nightly-style:
# go run -v ./cmd/internal/update_android_version --ci --nightly


# 4) Build APKs
cd clients/android
./gradlew :app:assembleOtherRelease

echo clients/android/app/build/outputs/apk/other/release/