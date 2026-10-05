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

# Boot control
PRODUCT_PACKAGES += \
    android.hardware.boot-service.qti.recovery

PRODUCT_PACKAGES += android.hardware.boot-service.qti

# Boot images
PRODUCT_BUILD_DEBUG_BOOT_IMAGE := false
PRODUCT_BUILD_DEBUG_VENDOR_BOOT_IMAGE := false

# Characteristics
PRODUCT_CHARACTERISTICS := tablet

# Dynamic partitions
PRODUCT_USE_DYNAMIC_PARTITIONS := true
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota/vabc_features.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota/launch_with_vendor_ramdisk.mk)
PRODUCT_VIRTUAL_AB_COMPRESSION_METHOD := lz4

# Generic ramdisk
$(call inherit-product, $(SRC_TARGET_DIR)/product/generic_ramdisk.mk)

PRODUCT_PACKAGES += \
    snapuserd.recovery

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

# VINTF
DEVICE_MANIFEST_FILE += device/lenovo/sm8850-common/vintf/manifest_canoe.xml

# Inherit from the proprietary files makefile.
$(call inherit-product, vendor/lenovo/sm8850-common/sm8850-common-vendor.mk)
