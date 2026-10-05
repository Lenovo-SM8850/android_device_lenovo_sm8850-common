#!/usr/bin/env -S PYTHONPATH=../../../tools/extract-utils python3
#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

from extract_utils.fixups_blob import (
    blob_fixup,
    blob_fixups_user_type,
)
from extract_utils.fixups_lib import (
    lib_fixups,
    lib_fixups_user_type,
)
from extract_utils.main import (
    ExtractUtils,
    ExtractUtilsModule,
)

namespace_imports = [
    'hardware/lenovo',
    'hardware/qcom-caf/sm8850',
    'hardware/qcom-caf/wlan',
    'vendor/qcom/opensource/commonsys/display',
    'vendor/qcom/opensource/commonsys-intf/display',
]


def lib_fixup_system_suffix(lib: str, partition: str) -> str:
    return f'{lib}-system' if partition == 'system_ext' else lib


lib_fixups: lib_fixups_user_type = {
    **lib_fixups,
    'vendor.qti.hardware.wifidisplaysession_aidl-V1-ndk':
        lib_fixup_system_suffix,
}

blob_fixups: blob_fixups_user_type = {
}  # fmt: skip


module = ExtractUtilsModule(
    'sm8850-common',
    'lenovo',
    blob_fixups=blob_fixups,
    lib_fixups=lib_fixups,
    namespace_imports=namespace_imports,
)


if __name__ == '__main__':
    utils = ExtractUtils.device(module)
    utils.run()
