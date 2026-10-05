#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

LOCAL_PATH := device/lenovo/sm8850-common

# Add common definitions for Qualcomm
$(call inherit-product, hardware/qcom-caf/common/common.mk)

# A/B
AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_system=true \
    POSTINSTALL_PATH_system=system/bin/otapreopt_script \
    FILESYSTEM_TYPE_system=ext4 \
    POSTINSTALL_OPTIONAL_system=true

AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_vendor=true \
    POSTINSTALL_PATH_vendor=bin/checkpoint_gc \
    FILESYSTEM_TYPE_vendor=ext4 \
    POSTINSTALL_OPTIONAL_vendor=true

AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_odm=true \
    POSTINSTALL_PATH_odm=bin/xbl_config_arb_check \
    FILESYSTEM_TYPE_odm=ext4 \
    POSTINSTALL_OPTIONAL_odm=false

PRODUCT_PACKAGES += \
    otapreopt_script \
    update_engine \
    update_engine_sideload \
    update_verifier

PRODUCT_PACKAGES += \
    checkpoint_gc \
    xbl_config_arb_check

# AVF
PRODUCT_BUILD_PVMFW_IMAGE := true
$(call inherit-product, packages/modules/Virtualization/build/apex/product_packages.mk)

# Biometrics
PRODUCT_PACKAGES += android.hardware.authsecret@1.0.vendor

PRODUCT_PACKAGES += android.hardware.gatekeeper@1.0.vendor

PRODUCT_COPY_FILES += frameworks/native/data/etc/android.hardware.biometrics.face.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.biometrics.face.xml

# Boot control
PRODUCT_PACKAGES += \
    android.hardware.boot-service.qti.recovery

PRODUCT_PACKAGES += android.hardware.boot-service.qti

# Boot images
PRODUCT_BUILD_DEBUG_BOOT_IMAGE := false
PRODUCT_BUILD_DEBUG_VENDOR_BOOT_IMAGE := false

# Camera
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.camera.concurrent.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.concurrent.xml \
    frameworks/native/data/etc/android.hardware.camera.flash-autofocus.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.flash-autofocus.xml \
    frameworks/native/data/etc/android.hardware.camera.front.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.front.xml \
    frameworks/native/data/etc/android.hardware.camera.full.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.full.xml \
    frameworks/native/data/etc/android.hardware.camera.raw.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.raw.xml

PRODUCT_PACKAGES += vendor.qti.hardware.camera.aon-V1-ndk.vendor

PRODUCT_PACKAGES += vendor.qti.hardware.camera.aon-V2-ndk.vendor

PRODUCT_PACKAGES += vendor.qti.hardware.camera.offlinecamera-V1-ndk.vendor

# Characteristics
PRODUCT_CHARACTERISTICS := tablet

# CNE
PRODUCT_PACKAGES += libvndfwk_detect_jni.qti.vendor

PRODUCT_PACKAGES += libvndfwk_detect_jni.qti_vendor

# Compatibility libraries
PRODUCT_PACKAGES += \
    android.hardware.security.keymint-V4-ndk.vendor \
    android.hardware.security.sharedsecret-V2-ndk.vendor \
    libaudioutils_shim \
    libbluetooth_audio_session_aidl_shim \
    libcodec2_aidl_noisurface.vendor \
    libcodec2_shim \
    libkeymaster_messages.vendor \
    libtinyxml2-v36 \
    vendor.qti.hardware.camera.offlinecamera-V2-ndk.vendor

# DRM
PRODUCT_PACKAGES += android.hardware.drm-service.clearkey

# Dynamic partitions
PRODUCT_USE_DYNAMIC_PARTITIONS := true
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota/vabc_features.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota/launch_with_vendor_ramdisk.mk)
PRODUCT_VIRTUAL_AB_COMPRESSION_METHOD := lz4

# Generic ramdisk
$(call inherit-product, $(SRC_TARGET_DIR)/product/generic_ramdisk.mk)

PRODUCT_PACKAGES += \
    snapuserd.recovery

# GPS
PRODUCT_COPY_FILES += frameworks/native/data/etc/android.hardware.location.gps.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.location.gps.xml

PRODUCT_PACKAGES += libstagefright_bufferqueue_helper.vendor

# HIDL
PRODUCT_PACKAGES += \
    android.hidl.allocator@1.0-service \
    android.hidl.memory@1.0-impl \
    hwservicemanager

PRODUCT_PACKAGES += android.hidl.token@1.0-utils.vendor

PRODUCT_PACKAGES += android.hidl.token@1.0.vendor

# Init
PRODUCT_PACKAGES += \
    charger_fstab.qcom \
    fstab.qcom \
    fstab.qcom.vendor_ramdisk \
    init.kernel.post_boot-alor_5_1.sh \
    init.kernel.post_boot-alor_5_2.sh \
    init.kernel.post_boot-alor_6_1.sh \
    init.kernel.post_boot-alor_default_6_2.sh \
    init.kernel.post_boot-canoe_5_1.sh \
    init.kernel.post_boot-canoe_5_2.sh \
    init.kernel.post_boot-canoe_6_1.sh \
    init.kernel.post_boot-canoe_default_6_2.sh \
    init.kernel.post_boot-memory.sh \
    init.kernel.post_boot.sh \
    init.qcom.early_boot.sh \
    init.qcom.factory.rc \
    init.qcom.rc \
    init.qcom.sh \
    init.qti.kernel.rc \
    init.qti.kernel.target.rc \
    init.qti.ufs.rc \
    init.target.rc \
    ueventd.lenovo.rc \
    ueventd.qcom.rc

# Input
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.jazzhand.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.touchscreen.multitouch.jazzhand.xml

# Keymint
PRODUCT_PACKAGES += \
    android.hardware.hardware_keystore.xml

PRODUCT_PACKAGES += rkp_factory_extraction_tool

# Permissions
PRODUCT_COPY_FILES += frameworks/native/data/etc/android.software.ipsec_tunnels.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.ipsec_tunnels.xml

PRODUCT_COPY_FILES += frameworks/native/data/etc/android.software.midi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.midi.xml

PRODUCT_COPY_FILES += frameworks/native/data/etc/android.software.sip.voip.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.sip.voip.xml

PRODUCT_COPY_FILES += frameworks/native/data/etc/android.software.verified_boot.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.verified_boot.xml

PRODUCT_COPY_FILES += frameworks/native/data/etc/handheld_core_hardware.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/handheld_core_hardware.xml

# Recovery
$(call soong_config_set_bool,recovery,target_recovery_uses_qti_drm,true)

PRODUCT_PACKAGES += \
    android.hardware.fastboot-service.example_recovery

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/init/init.recovery.qcom.rc:$(TARGET_COPY_OUT_RECOVERY)/root/init.recovery.qcom.rc

# Shipping API
PRODUCT_SHIPPING_API_LEVEL := 36

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(LOCAL_PATH) \
    hardware/lenovo \
    hardware/qcom-caf/bootctrl

# Storage
$(call inherit-product, $(SRC_TARGET_DIR)/product/emulated_storage.mk)

# USB
PRODUCT_PACKAGES += \
    init.qcom.usb.rc \
    init.qcom.usb.sh \
    usb_compositions.conf

PRODUCT_SOONG_NAMESPACES += \
    vendor/qcom/opensource/usb/etc

# Vendor DLKM
PRODUCT_COPY_FILES += \
    kernel/platform/kernel-6.12/vendor/lenovo/sm8850/modules-lists/modules.systemdlkm_blocklist.msm.canoe:$(TARGET_COPY_OUT_VENDOR_DLKM)/lib/modules/system_dlkm.modules.blocklist

# Vendor mount points
PRODUCT_PACKAGES += \
    vendor_bt_firmware_mountpoint \
    vendor_dsp_mountpoint \
    vendor_firmware_mnt_mountpoint \
    vendor_soccp_firmware_mountpoint \
    vendor_vm-system_mountpoint

# Vendor service manager
PRODUCT_PACKAGES += \
    vndservicemanager

# Vendor tools
PRODUCT_PACKAGES += \
    hs20-osu-client

# VINTF
DEVICE_MANIFEST_FILE += device/lenovo/sm8850-common/vintf/manifest_canoe.xml

# Inherit from the proprietary files makefile.
$(call inherit-product, vendor/lenovo/sm8850-common/sm8850-common-vendor.mk)
