# SPDX-License-Identifier: Apache-2.0
LOCAL_PATH := $(call my-dir)

ifneq ($(filter baldur wuji,$(TARGET_DEVICE)),)
# Apply the device's load policy after Kleaf installs the shared GKI inventory.
LENOVO_SYSTEM_DLKM_LOAD_POLICY := $(call intermediates-dir-for,PACKAGING,lenovo_system_dlkm_load_policy)/policy.stamp
$(LENOVO_SYSTEM_DLKM_LOAD_POLICY): PRIVATE_LOAD_LIST := $(DEVICE_PATH)/modules.load.system_dlkm
$(LENOVO_SYSTEM_DLKM_LOAD_POLICY): PRIVATE_MODULES_DIR := $(TARGET_OUT_SYSTEM_DLKM)/lib/modules
$(LENOVO_SYSTEM_DLKM_LOAD_POLICY): $(PRODUCT_OUT)/obj/KERNEL_OBJ/Image $(DEVICE_PATH)/modules.load.system_dlkm
	$(hide) test -f $(PRIVATE_MODULES_DIR)/modules.load
	$(hide) sed '/^[[:space:]]*#/d;/^[[:space:]]*$$/d;s/\.ko$$//' $(PRIVATE_LOAD_LIST) > $(PRIVATE_MODULES_DIR)/modules.load
	$(hide) mkdir -p $(dir $@) && touch $@

$(PRODUCT_OUT)/system_dlkm.img: $(LENOVO_SYSTEM_DLKM_LOAD_POLICY)
endif
