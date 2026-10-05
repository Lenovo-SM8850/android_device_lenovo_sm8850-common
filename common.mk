#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

LOCAL_PATH := device/lenovo/sm8850-common

# Add common definitions for Qualcomm
$(call inherit-product, hardware/qcom-caf/common/common.mk)

# Characteristics
PRODUCT_CHARACTERISTICS := tablet

# Shipping API
PRODUCT_SHIPPING_API_LEVEL := 36

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(LOCAL_PATH) \
    hardware/lenovo \
    hardware/qcom-caf/bootctrl

# Inherit from the proprietary files makefile.
$(call inherit-product, vendor/lenovo/sm8850-common/sm8850-common-vendor.mk)
