#
# SPDX-FileCopyrightText: 2026 The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

LOCAL_PATH := device/lenovo/sm8850-common

# Qualcomm common definitions
$(call inherit-product, hardware/qcom-caf/common/common.mk)

# Shipping API level
PRODUCT_SHIPPING_API_LEVEL := 36

# A/B
AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_system=true \
    POSTINSTALL_PATH_system=system/bin/otapreopt_script \
    FILESYSTEM_TYPE_system=ext4 \
    POSTINSTALL_OPTIONAL_system=true

AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_vendor=true \
    POSTINSTALL_PATH_vendor=bin/checkpoint_gc \
    FILESYSTEM_TYPE_vendor=erofs \
    POSTINSTALL_OPTIONAL_vendor=true

PRODUCT_PACKAGES += \
    otapreopt_script \
    update_engine \
    update_engine_sideload \
    update_verifier

PRODUCT_PACKAGES += \
    checkpoint_gc

# Shared display plugin selection
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/display/clstc_config_library.xml:$(TARGET_COPY_OUT_VENDOR)/etc/clstc_config_library.xml

# Shared board audio, sensor and camera defaults
PRODUCT_COPY_FILES += \
    device/lenovo/sm8850-common/configs/audio/audio_policy_volumes.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_volumes.xml \
    frameworks/native/data/etc/android.hardware.camera.concurrent.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.concurrent.xml \
    frameworks/native/data/etc/android.hardware.camera.flash-autofocus.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.flash-autofocus.xml \
    frameworks/native/data/etc/android.hardware.camera.front.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.front.xml \
    frameworks/native/data/etc/android.hardware.camera.full.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.full.xml \
    frameworks/native/data/etc/android.hardware.camera.raw.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.raw.xml \
    hardware/qcom-caf/sm8850/audio/pal/configs/qcom/mobile/canoe/Hapticsconfig.xml:$(TARGET_COPY_OUT_VENDOR)/etc/Hapticsconfig.xml \
    hardware/qcom-caf/sm8850/audio/pal/configs/qcom/mobile/canoe/card-defs.xml:$(TARGET_COPY_OUT_VENDOR)/etc/card-defs.xml \
    hardware/qcom-caf/sm8850/audio/pal/configs/qcom/mobile/canoe/mcs_defs_canoe_cdp_wsa885xi2s.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio/sku_canoe/mcs_defs_canoe_cdp_wsa885xi2s.xml \
    hardware/qcom-caf/sm8850/audio/pal/configs/qcom/mobile/canoe/mcs_defs_canoe_mtp.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio/sku_canoe/mcs_defs_canoe_mtp.xml \
    hardware/qcom-caf/sm8850/audio/pal/configs/qcom/mobile/canoe/mcs_defs_canoe_mtp_wsa884x.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio/sku_canoe/mcs_defs_canoe_mtp_wsa884x.xml \
    hardware/qcom-caf/sm8850/audio/pal/configs/qcom/mobile/canoe/mcs_defs_canoe_qrd.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio/sku_canoe/mcs_defs_canoe_qrd.xml \
    hardware/qcom-caf/sm8850/audio/pal/configs/qcom/mobile/canoe/mcs_defs_canoe_qrd_wsa884x.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio/sku_canoe/mcs_defs_canoe_qrd_wsa884x.xml \
    hardware/qcom-caf/sm8850/audio/pal/configs/qcom/mobile/canoe/mixer_paths_alor_cdp.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio/sku_alor/mixer_paths_alor_cdp.xml \
    hardware/qcom-caf/sm8850/audio/pal/configs/qcom/mobile/canoe/mixer_paths_alor_mtp_wcd9378.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio/sku_alor/mixer_paths_alor_mtp_wcd9378.xml \
    hardware/qcom-caf/sm8850/audio/pal/configs/qcom/mobile/canoe/mixer_paths_alor_mtp_wcd939x.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio/sku_alor/mixer_paths_alor_mtp_wcd939x.xml \
    hardware/qcom-caf/sm8850/audio/pal/configs/qcom/mobile/canoe/mixer_paths_alor_qrd.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio/sku_alor/mixer_paths_alor_qrd.xml \
    hardware/qcom-caf/sm8850/audio/pal/configs/qcom/mobile/canoe/mixer_paths_canoe_atp.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio/sku_canoe/mixer_paths_canoe_atp.xml \
    hardware/qcom-caf/sm8850/audio/pal/configs/qcom/mobile/canoe/plugin_manager.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio/sku_alor/plugin_manager.xml \
    hardware/qcom-caf/sm8850/audio/pal/configs/qcom/mobile/canoe/plugin_manager.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio/sku_canoe/plugin_manager.xml \
    hardware/qcom-caf/sm8850/audio/primary-hal/configs/canoe/audio_effects.conf:$(TARGET_COPY_OUT_VENDOR)/etc/audio/sku_alor/audio_effects.conf \
    hardware/qcom-caf/sm8850/audio/primary-hal/configs/canoe/audio_effects.conf:$(TARGET_COPY_OUT_VENDOR)/etc/audio/sku_canoe/audio_effects.conf \
    hardware/qcom-caf/sm8850/audio/primary-hal/configs/canoe/audio_effects.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio/sku_alor/audio_effects.xml \
    hardware/qcom-caf/sm8850/audio/primary-hal/configs/canoe/audio_effects.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio/sku_canoe/audio_effects.xml \
    hardware/qcom-caf/sm8850/audio/primary-hal/configs/canoe/audio_effects_config.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio/sku_alor/audio_effects_config.xml \
    hardware/qcom-caf/sm8850/audio/primary-hal/configs/canoe/audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio/sku_alor/audio_policy_configuration.xml \
    hardware/qcom-caf/sm8850/audio/primary-hal/configs/canoe/audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio/sku_alor_qssi/audio_policy_configuration.xml \
    hardware/qcom-caf/sm8850/audio/primary-hal/configs/canoe/audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio/sku_canoe/audio_policy_configuration.xml \
    hardware/qcom-caf/sm8850/audio/primary-hal/configs/canoe/audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio/sku_canoe_qssi/audio_policy_configuration.xml \
    hardware/qcom-caf/sm8850/audio/primary-hal/configs/canoe/mem_logger_config.xml:$(TARGET_COPY_OUT_VENDOR)/etc/mem_logger_config.xml \
    hardware/qcom-caf/sm8850/audio/primary-hal/configs/canoe/microphone_characteristics.xml:$(TARGET_COPY_OUT_VENDOR)/etc/microphone_characteristics.xml \
    hardware/qcom-caf/sm8850/audio/primary-hal/configs/canoe/quasar_config.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio/sku_alor/quasar_config.xml \
    hardware/qcom-caf/sm8850/audio/primary-hal/configs/canoe/quasar_config.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio/sku_canoe/quasar_config.xml \
    hardware/qcom-caf/sm8850/audio/primary-hal/configs/common/audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration.xml \
    hardware/qcom-caf/sm8850/audio/primary-hal/configs/common/bluetooth_qti_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/bluetooth_qti_audio_policy_configuration.xml \
    hardware/qcom-caf/sm8850/audio/primary-hal/configs/common/bluetooth_qti_hearing_aid_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/bluetooth_qti_hearing_aid_audio_policy_configuration.xml \
    hardware/qcom-caf/sm8850/audio/primary-hal/configs/common/codec2/media_codecs_c2_audio.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_c2_audio.xml \
    hardware/qcom-caf/sm8850/audio/primary-hal/configs/common/media_codecs_vendor_audio.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_vendor_audio.xml \
    vendor/qcom/opensource/vibrator/aidl/HapticsPolicy.xml:$(TARGET_COPY_OUT_VENDOR)/etc/HapticsPolicy.xml

# Board post-boot tuning
PRODUCT_PACKAGES += \
    init.kernel.post_boot-canoe_5_1.sh \
    init.kernel.post_boot-canoe_5_2.sh \
    init.kernel.post_boot-canoe_6_1.sh \
    init.kernel.post_boot-canoe_default_6_2.sh \
    init.kernel.post_boot-memory.sh

# Audio
include $(LOCAL_PATH)/configs/audio/source-builds.mk

ifeq ($(LENOVO_SOURCE_AUDIO_EFFECTS),true)
PRODUCT_PACKAGES += libaudioeffecthal.lenovo
LENOVO_AUDIO_INTERFACES := $(LOCAL_PATH)/configs/audio/vendor_audio_interfaces.xml
else
LENOVO_AUDIO_INTERFACES := hardware/qcom-caf/sm8850/audio/primary-hal/configs/canoe/vendor_audio_interfaces.xml
endif

ifeq ($(LENOVO_SOURCE_WFD_AAC),true)
PRODUCT_PACKAGES += libwfdaac.lenovo
endif

PRODUCT_PACKAGES += \
    android.hardware.audio.common-V1-ndk.vendor \
    android.hardware.audio.core-V3-ndk.vendor \
    android.hardware.audio.core.sounddose-V1-ndk.vendor \
    android.hardware.audio.core.sounddose-V3-ndk.vendor \
    audio.bluetooth.default \
    audio.r_submix.default \
    audio.usb.default \
    audioadsprpcd \
    audiohalservice.qti \
    customva_plugin \
    hotword_plugin \
    libagm_compress_plugin \
    libagm_mixer_plugin \
    libagm_pcm_plugin \
    libagmipcservice \
    libalsautilsv2.vendor \
    libaudiochargerlistener \
    libbatterylistener \
    libbundleaidl \
    libdev_display \
    libdev_dummy \
    libdev_ec_ref \
    libdev_ext_ec \
    libdev_fm \
    libdev_handset \
    libdev_handset_mic \
    libdev_handset_va \
    libdev_haptics \
    libdev_headphone \
    libdev_headset_mic \
    libdev_headset_va \
    libdev_proxy \
    libdev_speaker_mic \
    libdev_ultrasound \
    libdev_usb \
    libdownmixaidl \
    libdynamicsprocessingaidl \
    libfmpal \
    libhfp_pal \
    libloudnessenhanceraidl \
    libmediautils_vendor.vendor \
    libmemunreachable.vendor \
    libpal_sounddose \
    libpalipcservice \
    libqcompostprocbundle \
    libqcomvisualizer \
    libqcomvoiceprocessing \
    libreverbaidl \
    libsession_agm \
    libsoundtriggerhal.qti \
    libstream_acd \
    libstream_asr \
    libstream_calltranslation \
    libstream_common \
    libstream_commonproxy \
    libstream_contextproxy \
    libstream_dummy \
    libstream_haptics \
    libstream_incall \
    libstream_nontunnel \
    libstream_sensorpcmdata \
    libstream_sensorrenderer \
    libstream_soundtrigger \
    libstream_ultrasound \
    libtinyalsav2 \
    libtinycompress \
    libvisualizeraidl \
    qti-audio-types-aidl-V1-ndk.vendor \
    sva_plugin

$(call soong_config_set,qtiaudio,extra_device_virtuals,4)
$(call soong_config_set,qtiaudio,extra_out_devices,1)
$(call soong_config_set,qtiaudio,extra_in_devices,1)
$(call soong_config_set_bool,qtiaudio,nonvirtual_stream_isinitialized,true)
$(call soong_config_set_bool,qtiaudio,no_stream_mixer_event_callback,true)

# Audio and media configuration
PRODUCT_COPY_FILES += \
    frameworks/av/services/audiopolicy/config/a2dp_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/a2dp_audio_policy_configuration.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_audio.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_audio.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_c2.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_c2.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_telephony.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_telephony.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_video.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_video.xml \
    frameworks/av/services/audiopolicy/config/r_submix_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/r_submix_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/stub_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/stub_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/usb_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/usb_audio_policy_configuration.xml

# Shared audio HAL interface contract
PRODUCT_COPY_FILES += \
    $(LENOVO_AUDIO_INTERFACES):$(TARGET_COPY_OUT_VENDOR)/etc/audio/vendor_audio_interfaces.xml \
    $(LENOVO_AUDIO_INTERFACES):$(TARGET_COPY_OUT_VENDOR)/etc/vendor_audio_interfaces.xml

# Audio HAL extension
PRODUCT_PACKAGES += \
    qtiaudiohalvendorextn

# AVF
PRODUCT_BUILD_PVMFW_IMAGE := true
$(call inherit-product, packages/modules/Virtualization/build/apex/product_packages.mk)

# Bluetooth audio HAL
PRODUCT_PACKAGES += \
    android.hardware.bluetooth.audio-impl \
    lib_bt_aptx \
    lib_bt_ble \
    lib_bt_bundle

# Boot control
PRODUCT_PACKAGES += \
    android.hardware.boot-service.qti.recovery

# Boot images
PRODUCT_BUILD_DEBUG_BOOT_IMAGE := false
PRODUCT_BUILD_DEBUG_VENDOR_BOOT_IMAGE := false

# Characteristics
PRODUCT_CHARACTERISTICS := tablet

# Charging control
PRODUCT_PACKAGES += \
    vendor.lineage.health-service.default

$(call soong_config_set,lineage_health,charging_control_charging_path,/sys/class/power_supply/battery/charging_enabled)

# Codec2 audio seccomp policies
PRODUCT_COPY_FILES += \
    hardware/qcom-caf/sm8850/audio/primary-hal/configs/common/codec2/service/1.0/c2audio.vendor.base-arm.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/c2audio.vendor.base-arm.policy \
    hardware/qcom-caf/sm8850/audio/primary-hal/configs/common/codec2/service/1.0/c2audio.vendor.base-arm64.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/c2audio.vendor.base-arm64.policy \
    hardware/qcom-caf/sm8850/audio/primary-hal/configs/common/codec2/service/1.0/c2audio.vendor.ext-arm.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/c2audio.vendor.ext-arm.policy \
    hardware/qcom-caf/sm8850/audio/primary-hal/configs/common/codec2/service/1.0/c2audio.vendor.ext-arm64.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/c2audio.vendor.ext-arm64.policy

# Compatibility libraries
PRODUCT_PACKAGES += \
    libaudioutils_shim \
    libbluetooth_audio_session_aidl_shim \
    libcodec2_shim \
    libtinyxml2-v36

# Compatibility libraries
PRODUCT_PACKAGES += \
    android.hardware.graphics.allocator-V1-ndk.vendor \
    android.hardware.graphics.common-V5-ndk.vendor \
    android.hardware.security.keymint-V4-ndk.vendor \
    android.hardware.security.sharedsecret-V2-ndk.vendor \
    libcodec2_aidl_noisurface.vendor \
    libkeymaster_messages.vendor \
    vendor.qti.hardware.camera.offlinecamera-V2-ndk.vendor

# HWUI
TARGET_USES_VULKAN := true

# Display
PRODUCT_AAPT_CONFIG := normal large xlarge

# Display
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

# Display configuration
PRODUCT_COPY_FILES += \
    hardware/qcom-caf/sm8850/display/hal/config/smomo_setting.xml:$(TARGET_COPY_OUT_VENDOR)/etc/smomo_setting.xml \
    hardware/qcom-caf/sm8850/display/core/config/backlight_calib_nt37801_amoled_cmd_mode_dsi_csot_panel_with_DSC_CPHY.xml:$(TARGET_COPY_OUT_VENDOR)/etc/display/backlight_calib_nt37801_amoled_cmd_mode_dsi_csot_panel_with_DSC_CPHY.xml \
    hardware/qcom-caf/sm8850/display/hal/config/backlight_calib_r66451_amoled_cmd_mode_dsi_visionox_panel_with_DSC.xml:$(TARGET_COPY_OUT_VENDOR)/etc/display/backlight_calib_r66451_amoled_cmd_mode_dsi_visionox_panel_with_DSC.xml \
    hardware/qcom-caf/sm8850/display/core/config/qdcm_calib_data_RaonTech_Non-FSC_mode_video_1440x1440@60_mode_dsi_panel.json:$(TARGET_COPY_OUT_VENDOR)/etc/display/qdcm_calib_data_RaonTech_Non-FSC_mode_video_1440x1440@60_mode_dsi_panel.json \
    hardware/qcom-caf/sm8850/display/hal/config/qdcm_calib_data_Sharp_2k_cmd_mode_qsync_dsi_panel.json:$(TARGET_COPY_OUT_VENDOR)/etc/display/qdcm_calib_data_Sharp_2k_cmd_mode_qsync_dsi_panel.json \
    hardware/qcom-caf/sm8850/display/hal/config/qdcm_calib_data_Sharp_2k_video_mode_qsync_dsi_panel.json:$(TARGET_COPY_OUT_VENDOR)/etc/display/qdcm_calib_data_Sharp_2k_video_mode_qsync_dsi_panel.json \
    hardware/qcom-caf/sm8850/display/hal/config/qdcm_calib_data_Sharp_4k_cmd_mode_dsc_dsi_panel.json:$(TARGET_COPY_OUT_VENDOR)/etc/display/qdcm_calib_data_Sharp_4k_cmd_mode_dsc_dsi_panel.json \
    hardware/qcom-caf/sm8850/display/hal/config/qdcm_calib_data_Sharp_4k_video_mode_dsc_dsi_panel.json:$(TARGET_COPY_OUT_VENDOR)/etc/display/qdcm_calib_data_Sharp_4k_video_mode_dsc_dsi_panel.json \
    hardware/qcom-caf/sm8850/display/core/config/qdcm_calib_data_Sharp_qhd_cmd_mode_dsi_panel.json:$(TARGET_COPY_OUT_VENDOR)/etc/display/qdcm_calib_data_Sharp_qhd_cmd_mode_dsi_panel.json \
    hardware/qcom-caf/sm8850/display/core/config/qdcm_calib_data_Sharp_qhd_video_mode_dsi_panel.json:$(TARGET_COPY_OUT_VENDOR)/etc/display/qdcm_calib_data_Sharp_qhd_video_mode_dsi_panel.json \
    hardware/qcom-caf/sm8850/display/hal/config/qdcm_calib_data_nt36672e_lcd_video_mode_dsi_novatek_panel_with_DSC.json:$(TARGET_COPY_OUT_VENDOR)/etc/display/qdcm_calib_data_nt36672e_lcd_video_mode_dsi_novatek_panel_with_DSC.json \
    hardware/qcom-caf/sm8850/display/hal/config/qdcm_calib_data_nt36672e_lcd_video_mode_dsi_novatek_panel_without_DSC.json:$(TARGET_COPY_OUT_VENDOR)/etc/display/qdcm_calib_data_nt36672e_lcd_video_mode_dsi_novatek_panel_without_DSC.json \
    hardware/qcom-caf/sm8850/display/core/config/qdcm_calib_data_nt37801_amoled_video_mode_dsi_csot_panel_with_DSC.json:$(TARGET_COPY_OUT_VENDOR)/etc/display/qdcm_calib_data_nt37801_amoled_video_mode_dsi_csot_panel_with_DSC.json \
    hardware/qcom-caf/sm8850/display/core/config/qdcm_calib_data_nt37801_amoled_video_mode_dsi_csot_panel_with_DSC_CPHY.json:$(TARGET_COPY_OUT_VENDOR)/etc/display/qdcm_calib_data_nt37801_amoled_video_mode_dsi_csot_panel_with_DSC_CPHY.json \
    hardware/qcom-caf/sm8850/display/core/config/qdcm_calib_data_nt37802_video_PSR_amoled_VHM_120hz_dsi_panel_with_DSC.json:$(TARGET_COPY_OUT_VENDOR)/etc/display/qdcm_calib_data_nt37802_video_PSR_amoled_VHM_120hz_dsi_panel_with_DSC.json \
    hardware/qcom-caf/sm8850/display/hal/config/qdcm_calib_data_r66451_amoled_cmd_mode_dsi_visionox_panel_with_DSC.json:$(TARGET_COPY_OUT_VENDOR)/etc/display/qdcm_calib_data_r66451_amoled_cmd_mode_dsi_visionox_panel_with_DSC.json \
    hardware/qcom-caf/sm8850/display/hal/config/qdcm_calib_data_r66451_amoled_cmd_mode_dsi_visionox_panel_without_DSC.json:$(TARGET_COPY_OUT_VENDOR)/etc/display/qdcm_calib_data_r66451_amoled_cmd_mode_dsi_visionox_panel_without_DSC.json \
    hardware/qcom-caf/sm8850/display/hal/config/qdcm_calib_data_r66451_amoled_video_mode_dsi_visionox_panel_with_DSC.json:$(TARGET_COPY_OUT_VENDOR)/etc/display/qdcm_calib_data_r66451_amoled_video_mode_dsi_visionox_panel_with_DSC.json \
    hardware/qcom-caf/sm8850/display/hal/config/qdcm_calib_data_r66451_amoled_video_mode_dsi_visionox_panel_without_DSC.json:$(TARGET_COPY_OUT_VENDOR)/etc/display/qdcm_calib_data_r66451_amoled_video_mode_dsi_visionox_panel_without_DSC.json \
    hardware/qcom-caf/sm8850/display/hal/config/qdcm_calib_data_sharp_1080p_cmd_mode_dsi_panel.json:$(TARGET_COPY_OUT_VENDOR)/etc/display/qdcm_calib_data_sharp_1080p_cmd_mode_dsi_panel.json \
    hardware/qcom-caf/sm8850/display/core/config/qdcm_calib_data_vtdr6130_amoled_cmd_mode_dsi_visionox_panel_with_DSC.json:$(TARGET_COPY_OUT_VENDOR)/etc/display/qdcm_calib_data_vtdr6130_amoled_cmd_mode_dsi_visionox_panel_with_DSC.json \
    hardware/qcom-caf/sm8850/display/core/config/qdcm_calib_data_vtdr6130_amoled_qsync_cmd_mode_dsi_visionox_panel_with_DSC.json:$(TARGET_COPY_OUT_VENDOR)/etc/display/qdcm_calib_data_vtdr6130_amoled_qsync_cmd_mode_dsi_visionox_panel_with_DSC.json \
    hardware/qcom-caf/sm8850/display/core/config/qdcm_calib_data_vtdr6130_amoled_qsync_video_mode_dsi_visionox_panel_with_DSC.json:$(TARGET_COPY_OUT_VENDOR)/etc/display/qdcm_calib_data_vtdr6130_amoled_qsync_video_mode_dsi_visionox_panel_with_DSC.json \
    hardware/qcom-caf/sm8850/display/core/config/qdcm_calib_data_vtdr6130_amoled_video_mode_dsi_visionox_panel_with_DSC.json:$(TARGET_COPY_OUT_VENDOR)/etc/display/qdcm_calib_data_vtdr6130_amoled_video_mode_dsi_visionox_panel_with_DSC.json

# Display snapalloc resources
PRODUCT_COPY_FILES += \
    hardware/qcom-caf/sm8850/display/core/snapalloc/resources/camera_alignments.json:$(TARGET_COPY_OUT_VENDOR)/etc/display/camera_alignments.json \
    hardware/qcom-caf/sm8850/display/core/snapalloc/resources/cpu_alignments.json:$(TARGET_COPY_OUT_VENDOR)/etc/display/cpu_alignments.json \
    hardware/qcom-caf/sm8850/display/core/snapalloc/resources/default_alignments.json:$(TARGET_COPY_OUT_VENDOR)/etc/display/default_alignments.json \
    hardware/qcom-caf/sm8850/display/core/snapalloc/resources/display_alignments.json:$(TARGET_COPY_OUT_VENDOR)/etc/display/display_alignments.json \
    hardware/qcom-caf/sm8850/display/core/snapalloc/resources/formats.json:$(TARGET_COPY_OUT_VENDOR)/etc/display/formats.json \
    hardware/qcom-caf/sm8850/display/core/snapalloc/resources/graphics_alignments.json:$(TARGET_COPY_OUT_VENDOR)/etc/display/graphics_alignments.json \
    hardware/qcom-caf/sm8850/display/core/snapalloc/resources/ubwc_alignments.json:$(TARGET_COPY_OUT_VENDOR)/etc/display/ubwc_alignments.json \
    hardware/qcom-caf/sm8850/display/core/snapalloc/resources/video_alignments.json:$(TARGET_COPY_OUT_VENDOR)/etc/display/video_alignments.json

# Dynamic partitions
PRODUCT_USE_DYNAMIC_PARTITIONS := true
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota/vabc_features.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota/launch_with_vendor_ramdisk.mk)
PRODUCT_VIRTUAL_AB_COMPRESSION_METHOD := lz4

# Generic ramdisk
$(call inherit-product, $(SRC_TARGET_DIR)/product/generic_ramdisk.mk)

PRODUCT_PACKAGES += \
    snapuserd.recovery

# Hardware configuration
PRODUCT_COPY_FILES += \
    device/lenovo/sm8850-common/configs/display/snapdragon_color_libs_config.xml:$(TARGET_COPY_OUT_VENDOR)/etc/snapdragon_color_libs_config.xml \
    device/lenovo/sm8850-common/configs/media/media_codecs_google_c2_video.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_c2_video.xml \
    device/lenovo/sm8850-common/configs/media/media_codecs_google_video_le.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_video_le.xml \
    hardware/qcom-caf/sm8850/display/hal/config/backlight_calib_vtdr6130_amoled_cmd_mode_dsi_visionox_panel_with_DSC.xml:$(TARGET_COPY_OUT_VENDOR)/etc/display/backlight_calib_vtdr6130_amoled_cmd_mode_dsi_visionox_panel_with_DSC.xml \
    device/lenovo/sm8850-common/configs/input/excluded-input-devices.xml:$(TARGET_COPY_OUT_VENDOR)/etc/excluded-input-devices.xml

# HIDL
PRODUCT_PACKAGES += \
    android.hidl.allocator@1.0-service \
    android.hidl.memory@1.0-impl \
    hwservicemanager

# IPACM, keystore features, QSPA
PRODUCT_PACKAGES += \
    IPACM_Filter_cfg.xml \
    IPACM_cfg.xml \
    android.hardware.hardware_keystore.xml \
    qspa_application_packages.xml

# Keylayout
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/keylayout/Vendor_17ef_Product_619e.kl:$(TARGET_COPY_OUT_VENDOR)/usr/keylayout/Vendor_17ef_Product_619e.kl

# LiveDisplay
PRODUCT_PACKAGES += \
    vendor.lineage.livedisplay-service.sdm

$(call soong_config_set_bool,livedisplay_sdm,enable_dm,false)

# Lights
ifeq ($(LENOVO_HAS_LIGHTRING),true)
PRODUCT_PACKAGES += \
    android.hardware.light-service.lenovo \
    LenovoLegionHalo
endif

# Overlays
PRODUCT_PACKAGES += \
    FrameworksResOverlayCanoe \
    SettingsOverlayCanoe

PRODUCT_PACKAGES += \
    FrameworksResTargetCanoe \
    SettingsProviderOverlayCanoe \
    TetheringOverlayCanoe \
    WifiResOverlayCanoe \
    WifiResTargetCanoe

# Overlays
PRODUCT_ENFORCE_RRO_TARGETS := *

# Permissions
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.biometrics.face.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.biometrics.face.xml \
    frameworks/native/data/etc/android.hardware.audio.low_latency.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.audio.low_latency.xml \
    frameworks/native/data/etc/android.hardware.audio.pro.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.audio.pro.xml \
    frameworks/native/data/etc/android.hardware.bluetooth.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth.xml \
    frameworks/native/data/etc/android.hardware.bluetooth_le.channel_sounding.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth_le.channel_sounding.xml \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth_le.xml \
    frameworks/native/data/etc/android.hardware.location.gps.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.location.gps.xml \
    frameworks/native/data/etc/android.hardware.opengles.aep.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.opengles.aep.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.jazzhand.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.touchscreen.multitouch.jazzhand.xml \
    frameworks/native/data/etc/android.hardware.usb.accessory.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.accessory.xml \
    frameworks/native/data/etc/android.hardware.usb.host.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.host.xml \
    frameworks/native/data/etc/android.hardware.vulkan.compute-0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.compute-0.xml \
    frameworks/native/data/etc/android.hardware.vulkan.level-1.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.level-1.xml \
    frameworks/native/data/etc/android.hardware.vulkan.version-1_1.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.version-1_1.xml \
    frameworks/native/data/etc/android.hardware.vulkan.version-1_4.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.version-1_4.xml \
    frameworks/native/data/etc/android.hardware.wifi.direct.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.direct.xml \
    frameworks/native/data/etc/android.hardware.wifi.passpoint.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.passpoint.xml \
    frameworks/native/data/etc/android.hardware.wifi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.xml \
    frameworks/native/data/etc/android.software.ipsec_tunnels.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.ipsec_tunnels.xml \
    frameworks/native/data/etc/android.software.midi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.midi.xml \
    frameworks/native/data/etc/android.software.opengles.deqp.level-2025-03-01.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.opengles.deqp.level.xml \
    frameworks/native/data/etc/android.software.sip.voip.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.sip.voip.xml \
    frameworks/native/data/etc/android.software.verified_boot.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.verified_boot.xml \
    frameworks/native/data/etc/handheld_core_hardware.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/handheld_core_hardware.xml \
    frameworks/native/data/etc/android.hardware.sensor.accelerometer.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/sku_alor/android.hardware.sensor.accelerometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.compass.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/sku_alor/android.hardware.sensor.compass.xml \
    frameworks/native/data/etc/android.hardware.sensor.dynamic.head_tracker.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/sku_alor/android.hardware.sensor.dynamic.head_tracker.xml \
    frameworks/native/data/etc/android.hardware.sensor.gyroscope.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/sku_alor/android.hardware.sensor.gyroscope.xml \
    frameworks/native/data/etc/android.hardware.sensor.light.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/sku_alor/android.hardware.sensor.light.xml \
    frameworks/native/data/etc/android.hardware.sensor.proximity.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/sku_alor/android.hardware.sensor.proximity.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepcounter.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/sku_alor/android.hardware.sensor.stepcounter.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepdetector.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/sku_alor/android.hardware.sensor.stepdetector.xml \
    frameworks/native/data/etc/android.hardware.sensor.accelerometer.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/sku_canoe/android.hardware.sensor.accelerometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.compass.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/sku_canoe/android.hardware.sensor.compass.xml \
    frameworks/native/data/etc/android.hardware.sensor.dynamic.head_tracker.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/sku_canoe/android.hardware.sensor.dynamic.head_tracker.xml \
    frameworks/native/data/etc/android.hardware.sensor.gyroscope.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/sku_canoe/android.hardware.sensor.gyroscope.xml \
    frameworks/native/data/etc/android.hardware.sensor.light.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/sku_canoe/android.hardware.sensor.light.xml \
    frameworks/native/data/etc/android.hardware.sensor.proximity.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/sku_canoe/android.hardware.sensor.proximity.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepcounter.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/sku_canoe/android.hardware.sensor.stepcounter.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepdetector.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/sku_canoe/android.hardware.sensor.stepdetector.xml

# Pen and touch
PRODUCT_PACKAGES += \
    LenovoPen \
    LenovoTouchscreenRotation \
    LineageParts \
    init.lenovo.touch.rc \
    vendor.lineage.touch-service.lenovo

# Cover
PRODUCT_PACKAGES += lenovo-cover

# Platform init
PRODUCT_PACKAGES += \
    charger_fstab.qcom \
    fstab.qcom \
    fstab.qcom.vendor_ramdisk \
    init.class_main.sh \
    init.crda.sh \
    init.kernel.post_boot-alor.sh \
    init.kernel.post_boot-alor_5_1.sh \
    init.kernel.post_boot-alor_5_2.sh \
    init.kernel.post_boot-alor_6_1.sh \
    init.kernel.post_boot-alor_default_6_2.sh \
    init.kernel.post_boot-canoe.sh \
    init.kernel.post_boot.sh \
    init.mdm.sh \
    init.qcom.cabl.off.sh \
    init.qcom.cabl.sh \
    init.qcom.class_core.sh \
    init.qcom.coex.sh \
    init.qcom.early_boot.sh \
    init.qcom.efs.sync.sh \
    init.qcom.factory.rc \
    init.qcom.post_boot.sh \
    init.qcom.rc \
    init.qcom.sdio.sh \
    init.qcom.sensors.sh \
    init.qcom.sh \
    init.qcom.svi.off.sh \
    init.qcom.svi.sh \
    init.qti.kernel.debug-alor.sh \
    init.qti.kernel.debug-canoe.sh \
    init.qti.kernel.debug.sh \
    init.qti.kernel.early_debug-canoe.sh \
    init.qti.kernel.early_debug.sh \
    init.qti.kernel.rc \
    init.qti.kernel.sh \
    init.qti.kernel.target.rc \
    init.qti.ufs.rc \
    init.qti.write.sh \
    init.target.rc \
    system_dlkm_modprobe.sh \
    ueventd.lenovo.rc \
    ueventd.qcom.rc \
    vendor_modprobe.sh

# QTVM
PRODUCT_PACKAGES += \
    vendor.qti.qtvm.proxyclient-service

# Qualcomm HALs
PRODUCT_PACKAGES += \
    android.hardware.boot-service.qti \
    android.hardware.drm-service.clearkey \
    $(if $(LENOVO_HEALTH_SERVICE),$(LENOVO_HEALTH_SERVICE),android.hardware.health-service.qti) \
    android.hardware.health-service.qti_recovery \
    android.hardware.power-service-qti \
    android.hardware.sensors-service.multihal \
    android.hardware.thermal-service.qti \
    android.hardware.usb-service.lenovo \
    android.hardware.usb.gadget-service.qti \
    ipacm \
    qspa_vendor.rc \
    vendor.qti.hardware.memtrack-service \
    vendor.qti.qspa-service

# Recovery
PRODUCT_PACKAGES += \
    android.hardware.fastboot-service.example_recovery

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/rootdir/etc/init.recovery.qcom.rc:$(TARGET_COPY_OUT_RECOVERY)/root/init.recovery.qcom.rc

# Runtime libraries
PRODUCT_PACKAGES += \
    android.hardware.authsecret@1.0.vendor \
    android.hardware.bluetooth.audio@2.0-impl \
    android.hardware.gatekeeper@1.0.vendor \
    android.hardware.graphics.composer3-V2-ndk.vendor \
    android.hardware.graphics.composer3-V3-ndk.vendor \
    android.hardware.graphics.composer@2.1.vendor \
    android.hardware.graphics.composer@2.2.vendor \
    android.hardware.graphics.composer@2.3.vendor \
    android.hardware.health-V4-ndk.vendor \
    android.hardware.health@1.0.vendor \
    android.hardware.health@2.0.vendor \
    android.hardware.health@2.1.vendor \
    android.hardware.usb-V1-ndk.vendor \
    android.hardware.wifi-V3-ndk.vendor \
    android.hardware.wifi.supplicant-V4-ndk.vendor \
    android.hidl.token@1.0-utils.vendor \
    android.hidl.token@1.0.vendor \
    libhidparser \
    libpaleventnotifier \
    libstagefright_bufferqueue_helper.vendor \
    libvndfwk_detect_jni.qti.vendor \
    libvndfwk_detect_jni.qti_vendor \
    libvolumelistener \
    rkp_factory_extraction_tool \
    sensors.dynamic_sensor_hal \
    vendor.display.config@1.1.vendor \
    vendor.display.config@1.10.vendor \
    vendor.display.config@1.11.vendor \
    vendor.display.config@1.2.vendor \
    vendor.display.config@1.3.vendor \
    vendor.display.config@1.4.vendor \
    vendor.display.config@1.5.vendor \
    vendor.display.config@1.6.vendor \
    vendor.display.config@1.7.vendor \
    vendor.display.config@1.8.vendor \
    vendor.display.config@1.9.vendor \
    vendor.qti.hardware.camera.aon-V1-ndk.vendor \
    vendor.qti.hardware.camera.aon-V2-ndk.vendor \
    vendor.qti.hardware.camera.offlinecamera-V1-ndk.vendor \
    vendor.qti.hardware.display.allocator@1.0.vendor \
    vendor.qti.hardware.display.allocator@3.0.vendor \
    vendor.qti.hardware.display.composer3-V1-ndk.vendor \
    vendor.qti.hardware.display.composer3-V2-ndk.vendor \
    vendor.qti.hardware.display.composer3-V3-ndk.vendor \
    vendor.qti.hardware.display.composer@1.0.vendor \
    vendor.qti.hardware.display.composer@2.0.vendor \
    vendor.qti.hardware.display.config-V1-ndk.vendor \
    vendor.qti.hardware.display.config-V10-ndk.vendor \
    vendor.qti.hardware.display.config-V11-ndk.vendor \
    vendor.qti.hardware.display.config-V14-ndk.vendor \
    vendor.qti.hardware.display.config-V3-ndk.vendor \
    vendor.qti.hardware.display.config-V4-ndk.vendor \
    vendor.qti.hardware.display.config-V6-ndk.vendor \
    vendor.qti.hardware.display.config-V8-ndk.vendor \
    vendor.qti.hardware.display.config-V9-ndk.vendor \
    vendor.qti.hardware.display.mapper@1.0.vendor \
    vendor.qti.hardware.display.mapper@1.1.vendor \
    vendor.qti.hardware.paleventnotifier-V2-ndk.vendor \
    vendor.qti.hardware.perf@2.0.vendor \
    vendor.qti.hardware.perf@2.1.vendor \
    vendor.qti.hardware.perf@2.2.vendor \
    vendor.qti.hardware.wifi.supplicant-V1-ndk.vendor

# Sensors
PRODUCT_COPY_FILES += \
    device/lenovo/sm8850-common/configs/sensors/hals.conf:$(TARGET_COPY_OUT_VENDOR)/etc/sensors/hals.conf

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
    $(LOCAL_PATH)/modules.blocklist.system_dlkm:$(TARGET_COPY_OUT_VENDOR_DLKM)/lib/modules/system_dlkm.modules.blocklist

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

ifeq ($(LENOVO_HAS_TELEPHONY),true)
# Telephony
PRODUCT_PACKAGES += \
    extphonelib \
    extphonelib-product \
    extphonelib.xml \
    extphonelib_product.xml \
    ims-ext-common \
    ims_ext_common.xml \
    qti-telephony-hidl-wrapper \
    qti-telephony-hidl-wrapper-prd \
    qti-telephony-utils \
    qti-telephony-utils-prd \
    qti_telephony_hidl_wrapper.xml \
    qti_telephony_hidl_wrapper_prd.xml \
    qti_telephony_utils.xml \
    qti_telephony_utils_prd.xml \
    telephony-ext

PRODUCT_BOOT_JARS += telephony-ext

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.telephony.gsm.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.telephony.gsm.xml \
    frameworks/native/data/etc/android.hardware.telephony.ims.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.telephony.ims.xml \
    frameworks/native/data/etc/android.hardware.telephony.mbms.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.telephony.mbms.xml

endif

# Vendor tools
PRODUCT_PACKAGES += \
    cplay \
    hs20-osu-client \
    sg_write_buffer

# WiFi
PRODUCT_PACKAGES += \
    android.hardware.wifi-service \
    hostapd \
    hostapd_cli \
    libwifi-hal-ctrl \
    libwifi-hal-qcom \
    wpa_cli \
    wpa_supplicant \
    wpa_supplicant.conf

# WLAN firmware links
PRODUCT_PACKAGES += \
    firmware_wlan_kiwi_v2_WCNSS_qcom_cfg.ini_symlink \
    firmware_wlan_kiwi_v2_mac.bin_symlink \
    firmware_wlan_peach_v2_WCNSS_qcom_cfg.ini_symlink \
    firmware_wlan_peach_v2_mac.bin_symlink \
    firmware_wlan_wcn7750_WCNSS_qcom_cfg.ini_symlink \
    firmware_wlan_wcn7750_mac.bin_symlink \
    firmware_wlanmdsp.otaupdate_symlink

# Include the proprietary files makefile.
$(call inherit-product, vendor/lenovo/sm8850-common/sm8850-common-vendor.mk)
