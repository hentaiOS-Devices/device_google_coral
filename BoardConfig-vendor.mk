#
# Copyright (C) 2022 Raphielscape LLC.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

COMMON_PATH := device/google/coral

# CTS
BOARD_KERNEL_CMDLINE += androidboot.verifiedbootstate=green androidboot.vbmeta.device_state=locked androidboot.flash.locked=1

# Fingerprint override
TARGET_PRODUCT_PROP := $(COMMON_PATH)/fingerprint.prop

# vendor.img
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4

# Enable chain partition for vendor.
BOARD_AVB_VBMETA_VENDOR := vendor
ifeq ($(wildcard $(PROD_CERTS)/hentai_security.mk),)
BOARD_AVB_VBMETA_VENDOR_KEY_PATH := external/avb/test/data/testkey_rsa2048.pem
BOARD_AVB_VBMETA_VENDOR_ALGORITHM := SHA256_RSA2048
else
BOARD_AVB_VBMETA_VENDOR_KEY_PATH := $(PROD_CERTS)/hentai_rsa4096.pem
BOARD_AVB_VBMETA_VENDOR_ALGORITHM := SHA256_RSA4096
endif
BOARD_AVB_VBMETA_VENDOR_ROLLBACK_INDEX := $(PLATFORM_SECURITY_PATCH_TIMESTAMP)
BOARD_AVB_VBMETA_VENDOR_ROLLBACK_INDEX_LOCATION := 3

# AB OTA
AB_OTA_PARTITIONS += \
    vendor \
    vbmeta_vendor

# Inherit device vendor configuration
$(call inherit-product, device/google/coral/device-vendor.mk)

# Inherit proprietary vendor libraries
$(call inherit-product, vendor/google_devices/coral/coral-vendor.mk)