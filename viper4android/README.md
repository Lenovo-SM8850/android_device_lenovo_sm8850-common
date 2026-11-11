# ViPER4Android 2.1.1

The presigned app installs in system_ext; the arm64 AIDL effect installs in vendor.
The 2.1.x AIDL driver has no public source.

App: GPL-3.0 (LICENSE.app).
Source: https://github.com/likelikeslike/ViPER4Android
Revision: dfcbda7bceb01b7f3a77e092083311181768278c (2.1.1)
Original paths: release ViPER4Android-2.1.1.apk; LICENSE
Installed prebuilt: ViPER4Android.apk
SHA-256: b60a8e38c4abf00b5e3f0d4802732bf1dc8679047cc9471fb36bf74a9c572cba

Driver: GPL-2.0 module licence (LICENSE.driver), with ViPERDSP and PFFFT
notices in NOTICE.viperdsp and NOTICE.pffft, including use restrictions.
Source: https://github.com/likelikeslike/ViPERFX_RE
Revision: 32587b138eb915d6252ccbebd8a86d05af778957 (v2.1.1)
Original paths: release ViPER4Android-RE-AIDL-v2.1.1.zip,
common/files/libv4a_aidl_arm64-v8a.so; module/LICENSE
Installed prebuilt: libv4a_aidl.so
SHA-256: 8c258a3e28d37cc4ed198bb2f00b831b07704c99e0506dcb183c81aa7aa7dfbd

Integration references:
Source: https://github.com/rexprjkt/packages_apps_ViPER4AndroidFX
Revision: e3e3a2b7cbfe088dbbf0130b199a64f019b87944
Original paths: Android.bp; config.mk; sepolicy/vendor
Source: https://github.com/denson9874/Denson9874-Device-Central
Revision: 4e886bf3ea0286d3bc42287cd18afab17a0ec23c
Original paths: expressiveos-cheetah/viper4android/tree/NOTICE.viperdsp;
expressiveos-cheetah/viper4android/tree/NOTICE.pffft;
expressiveos-cheetah/viper4android/tree/Android.bp;
expressiveos-cheetah/viper4android/tree/hiddenapi-com.llsl.viper4android.xml;
expressiveos-cheetah/viper4android/tree/privapp-permissions-com.llsl.viper4android.xml;
expressiveos-cheetah/devices/husky/patches/device_google_zuma/0008-zuma-let-ViPER4Android-s-AIDL-driver-publish-viper.c.patch
