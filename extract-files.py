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
    'vendor/qcom/opensource/dataservices',
]


def lib_fixup_system_suffix(lib: str, partition: str) -> str:
    return f'{lib}-system' if partition == 'system_ext' else lib


lib_fixups: lib_fixups_user_type = {
    **lib_fixups,
    'vendor.qti.hardware.wifidisplaysession_aidl-V1-ndk':
        lib_fixup_system_suffix,
}

blob_fixups: blob_fixups_user_type = {
    'vendor/bin/init.qti.kernel.debug-alor.sh': blob_fixup()
        .regex_replace(r'echo 4 > \$DCC_PATH/curr_list', 'echo 6 > $DCC_PATH/curr_list'),
    'vendor/etc/media_codecs_canoe_sku1_vendor.xml': blob_fixup()
        .regex_replace('\\s*<Include href="media_codecs_dolby_audio\\.xml"\\s*/>', '')
        .regex_replace('\\s*<MediaCodec\\b[^>]*(?:name="[^"]*(?:dolby|\\.dv\\.)[^"]*"|type="video/dolby-vision")[^>]*>[\\s\\S]*?</MediaCodec>', ''),
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
        'vendor/lib64/libpowercallback.so',
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
    'vendor/lib64/vendor.qti.hardware.camera.offlinecamera-service-impl.so': blob_fixup()
        .replace_needed('android.hardware.graphics.allocator-V1-ndk.so', 'android.hardware.graphics.allocator-V2-ndk.so'),
    'vendor/lib64/vendor.qti.hardware.vibrator.impl-lenovo.so': blob_fixup()
        .replace_needed('libqtivibratoreffect.so', 'libqtivibratoreffect-lenovo.so')
        .replace_needed('vendor.qti.hardware.vibratorOL.impl.so', 'vendor.qti.hardware.vibratorOL.impl-lenovo.so')
        .replace_needed('vendor.qti.hardware.vibratorCL.impl.so', 'vendor.qti.hardware.vibratorCL.impl-lenovo.so')
        .replace_needed('vendor.qti.hardware.vibratorSel.impl.so', 'vendor.qti.hardware.vibratorSel.impl-lenovo.so'),
    'vendor/lib64/vendor.qti.hardware.vibratorOL.impl-lenovo.so': blob_fixup()
        .replace_needed('libqtivibratoreffect.so', 'libqtivibratoreffect-lenovo.so')
        .replace_needed('libqtivibratoreffectoffload.so', 'libqtivibratoreffectoffload-lenovo.so'),
    'vendor/lib64/libqcodec2_core.so': blob_fixup()
        .replace_needed('android.hardware.graphics.common-V5-ndk.so', 'android.hardware.graphics.common-V7-ndk.so'),
    'vendor/lib64/libpowercore.so': blob_fixup()
        .replace_needed('libtinyxml2.so', 'libtinyxml2-v36.so'),
    'vendor/etc/seccomp_policy/syshealthmon.policy': blob_fixup()
        .add_line_if_missing('lseek: 1'),
    'vendor/lib64/libwfdmmsrc_proprietary.so': blob_fixup().replace_needed('libwfdaac_vendor.so', 'libwfdaac.lenovo.so'),
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
