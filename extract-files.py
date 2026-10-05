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
}

blob_fixups: blob_fixups_user_type = {
    'vendor/etc/seccomp_policy/qsap_qapeservice.policy': blob_fixup()
        .add_line_if_missing('lseek: 1'),
    (
        'vendor/bin/hw/vendor.qti.media.c2audio@1.0-service',
        'vendor/bin/hw/vendor.qti.media.c2@1.0-service',
    ): blob_fixup()
        .replace_needed('android.hardware.media.c2-V1-ndk.so', 'android.hardware.media.c2-V2-ndk.so'),
    (
        'vendor/lib64/hw/libaudioeffecthal.qti.so',
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
    (
        'vendor/etc/media_codecs_canoe_sku2_vendor.xml',
        'vendor/etc/media_codecs_canoe_v1_vendor.xml',
        'vendor/etc/media_codecs_performance_canoe_sku1.xml',
    ): blob_fixup()
        .regex_replace('\\s*<Include href="media_codecs_dolby_audio\\.xml"\\s*/>', '')
        .regex_replace('\\s*<MediaCodec\\b[^>]*(?:name="[^"]*(?:dolby|\\.dv\\.)[^"]*"|type="video/dolby-vision")[^>]*>[\\s\\S]*?</MediaCodec>', ''),
}  # fmt: skip


module = ExtractUtilsModule(
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
