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


def lib_fixup_framework_suffix(lib: str, partition: str) -> str:
    return f'{lib}-system' if partition in ('system', 'system_ext') else lib


lib_fixups: lib_fixups_user_type = {
    **lib_fixups,
    'vendor.qti.ImsRtpService-V2-ndk':
        lib_fixup_system_suffix,
    'vendor.qti.diaghal-V1-ndk':
        lib_fixup_framework_suffix,
    'vendor.qti.diaghal@1.0':
        lib_fixup_system_suffix,
    'vendor.qti.imsrtpservice@3.0':
        lib_fixup_system_suffix,
    'vendor.qti.imsrtpservice@3.1':
        lib_fixup_system_suffix,
    'vendor.qti.hardware.wifidisplaysession_aidl-V1-ndk':
        lib_fixup_system_suffix,
}

blob_fixups: blob_fixups_user_type = {
    'vendor/bin/init.qti.kernel.debug-alor.sh': blob_fixup()
        .regex_replace(r'echo 4 > \$DCC_PATH/curr_list', 'echo 6 > $DCC_PATH/curr_list'),
    'vendor/bin/init.qti.kernel.debug.sh': blob_fixup()
        .regex_replace(r'\"660\"\|\"661\"\|\"704\"\|\"722\"\|\"723\"\)', '"660"|"661"|"704"|"722"|"723"|"743")'),
    'vendor/bin/init.qti.kernel.early_debug.sh': blob_fixup()
        .regex_replace(r'\"727\"\)', '"727"|"743")')
        .regex_replace(r'Copyright \(c\) Qualcomm Technologies, Inc\. and/or its subsidiaries\.', 'Copyright (c) 2024-2025 Qualcomm Technologies, Inc.'),
    'system_ext/etc/permissions/telephony_system-ext_privapp-permissions-qti.xml': blob_fixup()
        .regex_replace('<privapp-permissions package="(?:org.codeaurora.dialer|com.android.mms)">[\\s\\S]*?</privapp-permissions>', ''),
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
    'vendor/lib64/libwfdmmsrc_proprietary.so': blob_fixup()
        .replace_needed('libwfdaac_vendor.so', 'libwfdaac.lenovo.so'),
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


def write_face_manifest(ctx, packages_ctx):
    ctx.bp_out.write('\nprebuilt_etc {\n    name: "face-lenovo.xml",\n    src: "proprietary/vendor/etc/vintf/manifest/face-default.xml",\n    filename: "face-default.xml",\n    relative_install_path: "vintf/manifest",\n    vendor: true,\n}\n')
    ctx.product_mk_out.write('\nPRODUCT_PACKAGES += face-lenovo.xml\n')

module = ExtractUtilsModule(
    'sm8850-common',
    'lenovo',
    blob_fixups=blob_fixups,
    lib_fixups=lib_fixups,
    namespace_imports=namespace_imports,
)



for proprietary_file in module.proprietary_files:
    proprietary_file.add_post_makefile_generation_fn(write_face_manifest)


def begin_modem_packages(ctx, packages_ctx):
    ctx.product_mk_out.write('\nifeq ($(LENOVO_HAS_MODEM),true)\n')

def end_modem_packages(ctx, packages_ctx):
    ctx.product_mk_out.write('endif\n')

modem_files = module.add_proprietary_file('proprietary-files-modem.txt')
modem_files.add_pre_makefile_generation_fn(begin_modem_packages)
modem_files.add_post_makefile_generation_fn(end_modem_packages)


if __name__ == '__main__':
    utils = ExtractUtils.device(module)
    utils.run()
