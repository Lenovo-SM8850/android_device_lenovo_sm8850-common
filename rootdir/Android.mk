# SPDX-License-Identifier: Apache-2.0

LOCAL_PATH := $(call my-dir)

ifneq ($(strip $(LENOVO_RECOVERY_EXTRA_RC)),)
include $(CLEAR_VARS)
LOCAL_MODULE := init.recovery.lenovo.rc
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_PATH := $(TARGET_RECOVERY_ROOT_OUT)
LOCAL_MODULE_STEM := init.recovery.qcom.rc
include $(BUILD_SYSTEM)/base_rules.mk

$(LOCAL_BUILT_MODULE): PRIVATE_EXTRA_RC := $(notdir $(LENOVO_RECOVERY_EXTRA_RC))
$(LOCAL_BUILT_MODULE): $(LOCAL_PATH)/etc/init.recovery.qcom.rc $(LENOVO_RECOVERY_EXTRA_RC)
	$(hide) mkdir -p $(dir $@)
	$(hide) cat $< > $@
	$(hide) echo 'import /$(PRIVATE_EXTRA_RC)' >> $@
endif
