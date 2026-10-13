# SPDX-License-Identifier: Apache-2.0

PRODUCT_COPY_FILES += \
    $(LENOVO_DEVICE_CONFIG_PATH)/configs/audio/audio_module_config_primary.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio/audio_module_config_primary.xml \
    $(LENOVO_DEVICE_CONFIG_PATH)/configs/audio/default_volume_tables.xml:$(TARGET_COPY_OUT_VENDOR)/etc/default_volume_tables.xml \
    $(LENOVO_DEVICE_CONFIG_PATH)/configs/audio/sku_canoe/audio_effects_config.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio/sku_canoe/audio_effects_config.xml \
    $(LENOVO_DEVICE_CONFIG_PATH)/configs/audio/sku_canoe/mixer_paths_canoe_qrd.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio/sku_canoe/mixer_paths_canoe_qrd.xml \
    $(LENOVO_DEVICE_CONFIG_PATH)/configs/audio/sku_canoe/resourcemanager_canoe_mtp.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio/sku_canoe/resourcemanager_canoe_mtp.xml \
    $(LENOVO_DEVICE_CONFIG_PATH)/configs/audio/sku_canoe/resourcemanager_canoe_mtp_qmp.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio/sku_canoe/resourcemanager_canoe_mtp_qmp.xml \
    $(LENOVO_DEVICE_CONFIG_PATH)/configs/audio/sku_canoe/resourcemanager_canoe_mtp_wsa884x.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio/sku_canoe/resourcemanager_canoe_mtp_wsa884x.xml \
    $(LENOVO_DEVICE_CONFIG_PATH)/configs/audio/sku_canoe/resourcemanager_canoe_qrd.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio/sku_canoe/resourcemanager_canoe_qrd.xml \
    $(LENOVO_DEVICE_CONFIG_PATH)/configs/audio/sku_canoe/resourcemanager_canoe_qrd_wsa884x.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio/sku_canoe/resourcemanager_canoe_qrd_wsa884x.xml \
    $(LENOVO_DEVICE_CONFIG_PATH)/configs/audio/usecaseKvManager.xml:$(TARGET_COPY_OUT_VENDOR)/etc/usecaseKvManager.xml \
    $(LENOVO_DEVICE_CONFIG_PATH)/configs/display/sdm_display_resolution_extn.xml:$(TARGET_COPY_OUT_VENDOR)/etc/display/sdm_display_resolution_extn.xml \
    $(LENOVO_DEVICE_CONFIG_PATH)/configs/perf/perfconfigstore.xml:$(TARGET_COPY_OUT_VENDOR)/etc/perf/perfconfigstore.xml \
    $(LENOVO_DEVICE_CONFIG_PATH)/configs/perf/qapeconfigstore.xml:$(TARGET_COPY_OUT_VENDOR)/etc/perf/qapeconfigstore.xml \
    $(LENOVO_DEVICE_CONFIG_PATH)/configs/power/powerhint.xml:$(TARGET_COPY_OUT_VENDOR)/etc/powerhint.xml
