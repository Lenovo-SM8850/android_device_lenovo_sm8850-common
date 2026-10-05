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

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/audio/audio_policy_volumes.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_volumes.xml

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
    android.hardware.graphics.allocator-V1-ndk.vendor \
    android.hardware.graphics.common-V5-ndk.vendor \
    android.hardware.security.keymint-V4-ndk.vendor \
    android.hardware.security.sharedsecret-V2-ndk.vendor \
    libaudioutils_shim \
    libbluetooth_audio_session_aidl_shim \
    libcodec2_aidl_noisurface.vendor \
    libcodec2_shim \
    libkeymaster_messages.vendor \
    libtinyxml2-v36 \
    vendor.qti.hardware.camera.offlinecamera-V2-ndk.vendor

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/display/clstc_config_library.xml:$(TARGET_COPY_OUT_VENDOR)/etc/clstc_config_library.xml \
    $(LOCAL_PATH)/configs/display/snapdragon_color_libs_config.xml:$(TARGET_COPY_OUT_VENDOR)/etc/snapdragon_color_libs_config.xml \
    frameworks/native/data/etc/android.hardware.opengles.aep.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.opengles.aep.xml \
    frameworks/native/data/etc/android.hardware.vulkan.compute-0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.compute-0.xml \
    frameworks/native/data/etc/android.hardware.vulkan.level-1.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.level-1.xml \
    frameworks/native/data/etc/android.hardware.vulkan.version-1_1.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.version-1_1.xml \
    frameworks/native/data/etc/android.hardware.vulkan.version-1_4.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.version-1_4.xml \
    hardware/qcom-caf/sm8850/display/hal/config/backlight_calib_vtdr6130_amoled_cmd_mode_dsi_visionox_panel_with_DSC.xml:$(TARGET_COPY_OUT_VENDOR)/etc/display/backlight_calib_vtdr6130_amoled_cmd_mode_dsi_visionox_panel_with_DSC.xml

PRODUCT_AAPT_CONFIG := normal large xlarge

PRODUCT_PACKAGES += \
    android.hardware.graphics.mapper@4.0-impl-qti-display \
    init.qti.display_boot.rc \
    init.qti.display_boot.sh \
    libfilefinder \
    mapper.qti \
    vendor.qti.hardware.display.allocator-service \
    vendor.qti.hardware.display.composer-service \
    vendor.qti.hardware.display.demura-service \
    vendor.qti.hardware.display.snapalloc-impl

PRODUCT_COPY_FILES += \
    hardware/qcom-caf/sm8850/display/core/config/backlight_calib_nt37801_amoled_cmd_mode_dsi_csot_panel_with_DSC_CPHY.xml:$(TARGET_COPY_OUT_VENDOR)/etc/display/backlight_calib_nt37801_amoled_cmd_mode_dsi_csot_panel_with_DSC_CPHY.xml \
    hardware/qcom-caf/sm8850/display/core/config/qdcm_calib_data_RaonTech_Non-FSC_mode_video_1440x1440@60_mode_dsi_panel.json:$(TARGET_COPY_OUT_VENDOR)/etc/display/qdcm_calib_data_RaonTech_Non-FSC_mode_video_1440x1440@60_mode_dsi_panel.json \
    hardware/qcom-caf/sm8850/display/core/config/qdcm_calib_data_Sharp_qhd_cmd_mode_dsi_panel.json:$(TARGET_COPY_OUT_VENDOR)/etc/display/qdcm_calib_data_Sharp_qhd_cmd_mode_dsi_panel.json \
    hardware/qcom-caf/sm8850/display/core/config/qdcm_calib_data_Sharp_qhd_video_mode_dsi_panel.json:$(TARGET_COPY_OUT_VENDOR)/etc/display/qdcm_calib_data_Sharp_qhd_video_mode_dsi_panel.json \
    hardware/qcom-caf/sm8850/display/core/config/qdcm_calib_data_nt37801_amoled_video_mode_dsi_csot_panel_with_DSC.json:$(TARGET_COPY_OUT_VENDOR)/etc/display/qdcm_calib_data_nt37801_amoled_video_mode_dsi_csot_panel_with_DSC.json \
    hardware/qcom-caf/sm8850/display/core/config/qdcm_calib_data_nt37801_amoled_video_mode_dsi_csot_panel_with_DSC_CPHY.json:$(TARGET_COPY_OUT_VENDOR)/etc/display/qdcm_calib_data_nt37801_amoled_video_mode_dsi_csot_panel_with_DSC_CPHY.json \
    hardware/qcom-caf/sm8850/display/core/config/qdcm_calib_data_nt37802_video_PSR_amoled_VHM_120hz_dsi_panel_with_DSC.json:$(TARGET_COPY_OUT_VENDOR)/etc/display/qdcm_calib_data_nt37802_video_PSR_amoled_VHM_120hz_dsi_panel_with_DSC.json \
    hardware/qcom-caf/sm8850/display/core/config/qdcm_calib_data_vtdr6130_amoled_cmd_mode_dsi_visionox_panel_with_DSC.json:$(TARGET_COPY_OUT_VENDOR)/etc/display/qdcm_calib_data_vtdr6130_amoled_cmd_mode_dsi_visionox_panel_with_DSC.json \
    hardware/qcom-caf/sm8850/display/core/config/qdcm_calib_data_vtdr6130_amoled_qsync_cmd_mode_dsi_visionox_panel_with_DSC.json:$(TARGET_COPY_OUT_VENDOR)/etc/display/qdcm_calib_data_vtdr6130_amoled_qsync_cmd_mode_dsi_visionox_panel_with_DSC.json \
    hardware/qcom-caf/sm8850/display/core/config/qdcm_calib_data_vtdr6130_amoled_qsync_video_mode_dsi_visionox_panel_with_DSC.json:$(TARGET_COPY_OUT_VENDOR)/etc/display/qdcm_calib_data_vtdr6130_amoled_qsync_video_mode_dsi_visionox_panel_with_DSC.json \
    hardware/qcom-caf/sm8850/display/core/config/qdcm_calib_data_vtdr6130_amoled_video_mode_dsi_visionox_panel_with_DSC.json:$(TARGET_COPY_OUT_VENDOR)/etc/display/qdcm_calib_data_vtdr6130_amoled_video_mode_dsi_visionox_panel_with_DSC.json \
    hardware/qcom-caf/sm8850/display/hal/config/backlight_calib_r66451_amoled_cmd_mode_dsi_visionox_panel_with_DSC.xml:$(TARGET_COPY_OUT_VENDOR)/etc/display/backlight_calib_r66451_amoled_cmd_mode_dsi_visionox_panel_with_DSC.xml \
    hardware/qcom-caf/sm8850/display/hal/config/qdcm_calib_data_Sharp_2k_cmd_mode_qsync_dsi_panel.json:$(TARGET_COPY_OUT_VENDOR)/etc/display/qdcm_calib_data_Sharp_2k_cmd_mode_qsync_dsi_panel.json \
    hardware/qcom-caf/sm8850/display/hal/config/qdcm_calib_data_Sharp_2k_video_mode_qsync_dsi_panel.json:$(TARGET_COPY_OUT_VENDOR)/etc/display/qdcm_calib_data_Sharp_2k_video_mode_qsync_dsi_panel.json \
    hardware/qcom-caf/sm8850/display/hal/config/qdcm_calib_data_Sharp_4k_cmd_mode_dsc_dsi_panel.json:$(TARGET_COPY_OUT_VENDOR)/etc/display/qdcm_calib_data_Sharp_4k_cmd_mode_dsc_dsi_panel.json \
    hardware/qcom-caf/sm8850/display/hal/config/qdcm_calib_data_Sharp_4k_video_mode_dsc_dsi_panel.json:$(TARGET_COPY_OUT_VENDOR)/etc/display/qdcm_calib_data_Sharp_4k_video_mode_dsc_dsi_panel.json \
    hardware/qcom-caf/sm8850/display/hal/config/qdcm_calib_data_nt36672e_lcd_video_mode_dsi_novatek_panel_with_DSC.json:$(TARGET_COPY_OUT_VENDOR)/etc/display/qdcm_calib_data_nt36672e_lcd_video_mode_dsi_novatek_panel_with_DSC.json \
    hardware/qcom-caf/sm8850/display/hal/config/qdcm_calib_data_nt36672e_lcd_video_mode_dsi_novatek_panel_without_DSC.json:$(TARGET_COPY_OUT_VENDOR)/etc/display/qdcm_calib_data_nt36672e_lcd_video_mode_dsi_novatek_panel_without_DSC.json \
    hardware/qcom-caf/sm8850/display/hal/config/qdcm_calib_data_r66451_amoled_cmd_mode_dsi_visionox_panel_with_DSC.json:$(TARGET_COPY_OUT_VENDOR)/etc/display/qdcm_calib_data_r66451_amoled_cmd_mode_dsi_visionox_panel_with_DSC.json \
    hardware/qcom-caf/sm8850/display/hal/config/qdcm_calib_data_r66451_amoled_cmd_mode_dsi_visionox_panel_without_DSC.json:$(TARGET_COPY_OUT_VENDOR)/etc/display/qdcm_calib_data_r66451_amoled_cmd_mode_dsi_visionox_panel_without_DSC.json \
    hardware/qcom-caf/sm8850/display/hal/config/qdcm_calib_data_r66451_amoled_video_mode_dsi_visionox_panel_with_DSC.json:$(TARGET_COPY_OUT_VENDOR)/etc/display/qdcm_calib_data_r66451_amoled_video_mode_dsi_visionox_panel_with_DSC.json \
    hardware/qcom-caf/sm8850/display/hal/config/qdcm_calib_data_r66451_amoled_video_mode_dsi_visionox_panel_without_DSC.json:$(TARGET_COPY_OUT_VENDOR)/etc/display/qdcm_calib_data_r66451_amoled_video_mode_dsi_visionox_panel_without_DSC.json \
    hardware/qcom-caf/sm8850/display/hal/config/qdcm_calib_data_sharp_1080p_cmd_mode_dsi_panel.json:$(TARGET_COPY_OUT_VENDOR)/etc/display/qdcm_calib_data_sharp_1080p_cmd_mode_dsi_panel.json \
    hardware/qcom-caf/sm8850/display/hal/config/smomo_setting.xml:$(TARGET_COPY_OUT_VENDOR)/etc/smomo_setting.xml

PRODUCT_COPY_FILES += \
    hardware/qcom-caf/sm8850/display/core/snapalloc/resources/camera_alignments.json:$(TARGET_COPY_OUT_VENDOR)/etc/display/camera_alignments.json \
    hardware/qcom-caf/sm8850/display/core/snapalloc/resources/cpu_alignments.json:$(TARGET_COPY_OUT_VENDOR)/etc/display/cpu_alignments.json \
    hardware/qcom-caf/sm8850/display/core/snapalloc/resources/default_alignments.json:$(TARGET_COPY_OUT_VENDOR)/etc/display/default_alignments.json \
    hardware/qcom-caf/sm8850/display/core/snapalloc/resources/display_alignments.json:$(TARGET_COPY_OUT_VENDOR)/etc/display/display_alignments.json \
    hardware/qcom-caf/sm8850/display/core/snapalloc/resources/formats.json:$(TARGET_COPY_OUT_VENDOR)/etc/display/formats.json \
    hardware/qcom-caf/sm8850/display/core/snapalloc/resources/graphics_alignments.json:$(TARGET_COPY_OUT_VENDOR)/etc/display/graphics_alignments.json \
    hardware/qcom-caf/sm8850/display/core/snapalloc/resources/ubwc_alignments.json:$(TARGET_COPY_OUT_VENDOR)/etc/display/ubwc_alignments.json \
    hardware/qcom-caf/sm8850/display/core/snapalloc/resources/video_alignments.json:$(TARGET_COPY_OUT_VENDOR)/etc/display/video_alignments.json

# Device hardware configuration
PRODUCT_COPY_FILES += \
    $(LENOVO_DEVICE_CONFIG_PATH)/configs/display/sdm_display_resolution_extn.xml:$(TARGET_COPY_OUT_VENDOR)/etc/display/sdm_display_resolution_extn.xml

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

PRODUCT_PACKAGES += android.hardware.graphics.composer3-V2-ndk.vendor

PRODUCT_PACKAGES += android.hardware.graphics.composer3-V3-ndk.vendor

PRODUCT_PACKAGES += android.hardware.graphics.composer@2.1.vendor

PRODUCT_PACKAGES += android.hardware.graphics.composer@2.2.vendor

PRODUCT_PACKAGES += android.hardware.graphics.composer@2.3.vendor

PRODUCT_PACKAGES += vendor.display.config@1.1.vendor

PRODUCT_PACKAGES += vendor.display.config@1.10.vendor

PRODUCT_PACKAGES += vendor.display.config@1.11.vendor

PRODUCT_PACKAGES += vendor.display.config@1.2.vendor

PRODUCT_PACKAGES += vendor.display.config@1.3.vendor

PRODUCT_PACKAGES += vendor.display.config@1.4.vendor

PRODUCT_PACKAGES += vendor.display.config@1.5.vendor

PRODUCT_PACKAGES += vendor.display.config@1.6.vendor

PRODUCT_PACKAGES += vendor.display.config@1.7.vendor

PRODUCT_PACKAGES += vendor.display.config@1.8.vendor

PRODUCT_PACKAGES += vendor.display.config@1.9.vendor

PRODUCT_PACKAGES += vendor.qti.hardware.display.allocator@1.0.vendor

PRODUCT_PACKAGES += vendor.qti.hardware.display.allocator@3.0.vendor

PRODUCT_PACKAGES += vendor.qti.hardware.display.composer3-V1-ndk.vendor

PRODUCT_PACKAGES += vendor.qti.hardware.display.composer3-V2-ndk.vendor

PRODUCT_PACKAGES += vendor.qti.hardware.display.composer3-V3-ndk.vendor

PRODUCT_PACKAGES += vendor.qti.hardware.display.composer@1.0.vendor

PRODUCT_PACKAGES += vendor.qti.hardware.display.composer@2.0.vendor

PRODUCT_PACKAGES += vendor.qti.hardware.display.config-V1-ndk.vendor

PRODUCT_PACKAGES += vendor.qti.hardware.display.config-V10-ndk.vendor

PRODUCT_PACKAGES += vendor.qti.hardware.display.config-V11-ndk.vendor

PRODUCT_PACKAGES += vendor.qti.hardware.display.config-V14-ndk.vendor

PRODUCT_PACKAGES += vendor.qti.hardware.display.config-V3-ndk.vendor

PRODUCT_PACKAGES += vendor.qti.hardware.display.config-V4-ndk.vendor

PRODUCT_PACKAGES += vendor.qti.hardware.display.config-V6-ndk.vendor

PRODUCT_PACKAGES += vendor.qti.hardware.display.config-V8-ndk.vendor

PRODUCT_PACKAGES += vendor.qti.hardware.display.config-V9-ndk.vendor

PRODUCT_PACKAGES += vendor.qti.hardware.display.mapper@1.0.vendor

PRODUCT_PACKAGES += vendor.qti.hardware.display.mapper@1.1.vendor

PRODUCT_COPY_FILES += frameworks/native/data/etc/android.software.opengles.deqp.level-2025-03-01.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.opengles.deqp.level.xml

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

# LiveDisplay
PRODUCT_PACKAGES += \
    vendor.lineage.livedisplay-service.sdm

$(call soong_config_set_bool,livedisplay_sdm,enable_dm,false)

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
