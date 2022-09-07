#!/bin/bash
#
# Copyright (C) 2016 The CyanogenMod Project
# Copyright (C) 2017-2020 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

set -e

DEVICE=coral-common
VENDOR=google_devices

# Load extract_utils and do some sanity checks
MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "${MY_DIR}" ]]; then MY_DIR="${PWD}"; fi

HENTAI_ROOT="${MY_DIR}/../../../.."

HELPER="${HENTAI_ROOT}/vendor/hentai/build/tools/extract_utils.sh"
if [ ! -f "${HELPER}" ]; then
    echo "Unable to find helper script at ${HELPER}"
    exit 1
fi
source "${HELPER}"

# Default to sanitizing the vendor folder before extraction
CLEAN_VENDOR=true

KANG=
SECTION=

while [ "${#}" -gt 0 ]; do
    case "${1}" in
        -n | --no-cleanup )
                CLEAN_VENDOR=false
                ;;
        -k | --kang )
                KANG="--kang"
                ;;
        -s | --section )
                SECTION="${2}"; shift
                CLEAN_VENDOR=false
                ;;
        * )
                SRC="${1}"
                ;;
    esac
    shift
done

if [ -z "${SRC}" ]; then
    SRC="adb"
fi

# Initialize the helper
setup_vendor "${DEVICE}" "${VENDOR}" "${HENTAI_ROOT}" false "${CLEAN_VENDOR}"

extract "${MY_DIR}/proprietary-files-common.txt" "${SRC}" "${KANG}" --section "${SECTION}"

# Reinitialize the helper
DEVICE=coral
setup_vendor "${DEVICE}" "${VENDOR}" "${HENTAI_ROOT}" false "${CLEAN_VENDOR}"

extract "${MY_DIR}/proprietary-files-coral.txt" "${SRC}" "${KANG}" --section "${SECTION}"

# Reinitialize the helper again
DEVICE=flame
setup_vendor "${DEVICE}" "${VENDOR}" "${HENTAI_ROOT}" false "${CLEAN_VENDOR}"

extract "${MY_DIR}/proprietary-files-flame.txt" "${SRC}" "${KANG}" --section "${SECTION}"

"${MY_DIR}/setup-makefiles.sh"