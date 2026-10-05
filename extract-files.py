#!/usr/bin/env -S PYTHONPATH=../../../tools/extract-utils python3
#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

import os
from functools import partial
from pathlib import Path

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
from extract_utils.source import DiskSource

# Regeneration must select exactly one device's firmware cohort.
active_device = os.environ.get('LENOVO_ACTIVE_DEVICE')
if active_device not in ('baldur', 'wuji'):
    raise ValueError('LENOVO_ACTIVE_DEVICE must be baldur or wuji')

from extract_utils.utils import import_module

helpers = import_module(
    'lenovo_extract_helpers',
    str((Path(__file__).resolve().parent) / 'extract_helpers.py'),
)
write_elf_data_modules = helpers.write_elf_data_modules

namespace_imports = [
    f'vendor/lenovo/{active_device}',
    'device/lenovo/sm8850-common',
    'hardware/qcom-caf/sm8850',
    'hardware/qcom-caf/wlan',
    'hardware/qcom-caf/wlan/qcwcn',
    'vendor/qcom/opensource/commonsys/display',
    'vendor/qcom/opensource/commonsys-intf/display',
    'vendor/qcom/opensource/dataservices',
]


lib_fixups: lib_fixups_user_type = {
    **lib_fixups,
    'vendor.qti.hardware.wifidisplaysession_aidl-V1-ndk':
        lambda lib, partition: f'{lib}-system' if partition == 'system_ext' else lib,
}

blob_fixups: blob_fixups_user_type = {
    'system_ext/lib64/libwfdcommonutils.so': blob_fixup()
        .remove_needed('libheif.so'),
    'system_ext/priv-app/WfdService/WfdService.apk': blob_fixup()
        .apktool_patch('blob-patches/WfdService'),
    'system_ext/lib64/libwfdmmsrc_system.so': blob_fixup()
        .add_needed('libaudioclient_shim.so')
        .add_needed('libgui_shim.so'),
    'system_ext/lib64/libwfdnative.so': blob_fixup()
        .add_needed('libinput_shim.so'),
    'system_ext/lib64/libwfdservice.so': blob_fixup()
        .add_needed('libaudioclient_shim.so')
        .replace_needed('android.media.audio.common.types-V4-cpp.so', 'android.media.audio.common.types-V5-cpp.so'),
    'vendor/etc/seccomp_policy/qsap_qapeservice.policy': blob_fixup()
        .add_line_if_missing('lseek: 1'),
    (
        'vendor/bin/hw/vendor.qti.media.c2audio@1.0-service',
        'vendor/bin/hw/vendor.qti.media.c2@1.0-service',
    ): blob_fixup()
        .replace_needed('android.hardware.media.c2-V1-ndk.so', 'android.hardware.media.c2-V2-ndk.so'),
    (
        'vendor/bin/poweropt-service',
        'vendor/bin/qsap_mpamsvc',
        'vendor/lib64/libaodoptfeature.so',
        'vendor/lib64/libgamepoweroptfeature.so',
        'vendor/lib64/liblearningmodule.so',
        'vendor/lib64/liboffscreenpoweroptfeature.so',
        'vendor/lib64/libpowercallback.so',
        'vendor/lib64/libpsmoptfeature.so',
        'vendor/lib64/libstandbyfeature.so',
    ): blob_fixup()
        .replace_needed('libtinyxml2.so', 'libtinyxml2-v36.so'),
    'vendor/lib64/libaudioserviceexampleimpl.so': blob_fixup()
        .add_needed('libaudioutils_shim.so')
        .add_needed('libbluetooth_audio_session_aidl_shim.so'),
    'vendor/bin/hw/vendor.qti.hardware.vibrator.service-lenovo': blob_fixup()
        .replace_needed('vendor.qti.hardware.vibrator.impl.so', 'vendor.qti.hardware.vibrator.impl-lenovo.so'),
    'vendor/etc/init/vendor.qti.hardware.vibrator.service-lenovo.rc': blob_fixup()
        .regex_replace('/vendor/bin/hw/vendor\\.qti\\.hardware\\.vibrator\\.service(?![\\w-])', '/vendor/bin/hw/vendor.qti.hardware.vibrator.service-lenovo'),
    'vendor/lib64/vendor.qti.hardware.vibrator.impl-lenovo.so': blob_fixup()
        .replace_needed('libqtivibratoreffect.so', 'libqtivibratoreffect-lenovo.so')
        .replace_needed('vendor.qti.hardware.vibratorOL.impl.so', 'vendor.qti.hardware.vibratorOL.impl-lenovo.so')
        .replace_needed('vendor.qti.hardware.vibratorCL.impl.so', 'vendor.qti.hardware.vibratorCL.impl-lenovo.so')
        .replace_needed('vendor.qti.hardware.vibratorSel.impl.so', 'vendor.qti.hardware.vibratorSel.impl-lenovo.so'),
    'vendor/lib64/vendor.qti.hardware.vibratorOL.impl-lenovo.so': blob_fixup()
        .replace_needed('libqtivibratoreffect.so', 'libqtivibratoreffect-lenovo.so')
        .replace_needed('libqtivibratoreffectoffload.so', 'libqtivibratoreffectoffload-lenovo.so'),
    'vendor/etc/seccomp_policy/syshealthmon.policy': blob_fixup()
        .add_line_if_missing('lseek: 1'),
}  # fmt: skip

if not helpers.source_audio_builds()['effects']:
    blob_fixups['vendor/lib64/hw/libaudioeffecthal.qti.so'] = blob_fixup() \
        .replace_needed('libtinyxml2.so', 'libtinyxml2-v36.so')

if helpers.source_audio_builds()['wfd_aac']:
    blob_fixups['vendor/lib64/libwfdmmsrc_proprietary.so'] = blob_fixup() \
        .replace_needed('libwfdaac_vendor.so', 'libwfdaac.lenovo.so')


class LenovoCommonModule(ExtractUtilsModule):
    def process_file(self, file, source, backup_source, vendor_path,
                     is_firmware, kang, allow_prohibited_files=False):
        # Common extraction normally reads TB324ZC; the source display HAL's
        # private C++ interfaces require the matching TB323FU color libraries.
        if file.src in helpers.PRC088_DISPLAY_BLOBS:
            source = DiskSource(str(helpers.common_blob_source(file.src, '.')))
        return super().process_file(
            file, source, backup_source, vendor_path, is_firmware, kang,
            allow_prohibited_files,
        )


module = LenovoCommonModule(
    'sm8850-common',
    'lenovo',
    blob_fixups=blob_fixups,
    lib_fixups=lib_fixups,
    namespace_imports=namespace_imports,
)


# ELF data modules
for proprietary_file in module.proprietary_files:
    proprietary_file.add_pre_makefile_generation_fn(
        partial(
            write_elf_data_modules, proprietary_file,
            device=module.device, owner=module.vendor,
        )
    )


if __name__ == '__main__':
    utils = ExtractUtils.device(module)
    utils.run()
