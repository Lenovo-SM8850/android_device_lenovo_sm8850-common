#!/usr/bin/env -S PYTHONPATH=../../../tools/extract-utils python3
#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

from pathlib import Path
import re

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


def enable_ull_scan_requests(ctx, file, file_path, **kwargs):
    path = Path(file_path)
    data = path.read_bytes()
    lines = data.splitlines(keepends=True)
    ends = [i for i, line in enumerate(lines) if line.rstrip(b'\r\n') == b'END']
    if len(ends) != 1 or re.search(rb'(?m)^\s*wlm_latency_flags_ultralow\s*=', data):
        raise ValueError(f'{file.dst}: expected one END and no ULL latency assignment')

    newline = b'\r\n' if lines[ends[0]].endswith(b'\r\n') else b'\n'
    lines.insert(ends[0], b'wlm_latency_flags_ultralow=0x180c82' + newline)
    path.write_bytes(b''.join(lines))


def patch_vibrator_capabilities(ctx, file, file_path, **kwargs):
    # Stock compose blocks and reports fake durations. Clear only CAP_COMPOSE_EFFECTS (0x20).
    # Match instruction context, not file offsets: patchelf may move ELF sections.
    if 'vibratorCL' in file_path:
        pattern = bytes.fromhex(
            'fd030091 f30308aa e8058052 a2ffffd0 42483a91 280000b9 a1ffffd0 21803991 60008052 e3058052 ba0e0094')
        patches = ((8, bytes.fromhex('e8058052'), bytes.fromhex('e8018052')),
                   (36, bytes.fromhex('e3058052'), bytes.fromhex('e3018052')))
    else:
        pattern = bytes.fromhex('08544139 1f050071 81000054 48048052 6300082a 230000b9 08584139')
        patches = ((12, bytes.fromhex('48048052'), bytes.fromhex('48008052')),)
    with open(file_path, 'r+b') as blob:
        data = blob.read()
        matches = data.count(pattern)
        if matches != 1:
            raise ValueError(
                f'{file_path}: expected one vibrator getCapabilities pattern, found {matches}'
            )
        start = data.index(pattern)
        for offset, original, replacement in patches:
            if len(original) != len(replacement) or data[start + offset:start + offset + len(original)] != original:
                raise ValueError(f'{file_path}: unexpected vibrator instruction at {start + offset:#x}')
        # Validate every instruction before writing any changes.
        for offset, original, replacement in patches:
            blob.seek(start + offset)
            blob.write(replacement)


blob_fixups: blob_fixups_user_type = {
    'vendor/etc/media_codecs_canoe_sku1_vendor.xml': blob_fixup()
        .regex_replace('\\s*<Include href="media_codecs_dolby_audio\\.xml"\\s*/>', '')
        .regex_replace('\\s*<MediaCodec\\b[^>]*(?:name="[^"]*(?:dolby|\\.dv\\.)[^"]*"|type="video/dolby-vision")[^>]*>[\\s\\S]*?</MediaCodec>', ''),
    (
        'vendor/etc/wifi/kiwi_v2/WCNSS_qcom_cfg.ini',
        'vendor/etc/wifi/wcn7750/WCNSS_qcom_cfg.ini',
    ): blob_fixup()
        .call(enable_ull_scan_requests, need_tmp_dir=False),
    'vendor/bin/init.qti.kernel.debug-alor.sh': blob_fixup()
        .regex_replace(r'echo 4 > \$DCC_PATH/curr_list', 'echo 6 > $DCC_PATH/curr_list'),
    'system_ext/etc/permissions/telephony_system-ext_privapp-permissions-qti.xml': blob_fixup()
        .regex_replace('<privapp-permissions package="(?:org.codeaurora.dialer|com.android.mms)">[\\s\\S]*?</privapp-permissions>', ''),
    'system_ext/lib64/libwfdcommonutils.so': blob_fixup()
        .remove_needed('libheif.so'),
    'system_ext/priv-app/WfdService/WfdService.apk': blob_fixup()
        .apktool_patch('blob-patches/WfdService'),
    'system_ext/lib64/libwfdmmsrc_system.so': blob_fixup()
        .replace_needed('libaudioclient.so', 'libaudiobase.so')
        .add_needed('libgui_shim.so'),
    'system_ext/lib64/libwfdnative.so': blob_fixup()
        .add_needed('libinput_shim.so'),
    'system_ext/lib64/libwfdservice.so': blob_fixup()
        .add_needed('libaudiobase.so')
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
    'vendor/lib64/vendor.qti.hardware.vibratorCL.impl-lenovo.so': blob_fixup()
        .call(patch_vibrator_capabilities, need_tmp_dir=False),
    'vendor/lib64/vendor.qti.hardware.vibratorOL.impl-lenovo.so': blob_fixup()
        .replace_needed('libqtivibratoreffect.so', 'libqtivibratoreffect-lenovo.so')
        .replace_needed('libqtivibratoreffectoffload.so', 'libqtivibratoreffectoffload-lenovo.so')
        .call(patch_vibrator_capabilities, need_tmp_dir=False),
    'vendor/lib64/libqcodec2_core.so': blob_fixup()
        .replace_needed('android.hardware.graphics.common-V5-ndk.so', 'android.hardware.graphics.common-V7-ndk.so'),
    'vendor/lib64/libpowercore.so': blob_fixup()
        .replace_needed('libtinyxml2.so', 'libtinyxml2-v36.so'),
    'vendor/lib64/libwfdmmsrc_proprietary.so': blob_fixup()
        .replace_needed('libwfdaac_vendor.so', 'libwfdaac.lenovo.so'),
    'vendor/etc/seccomp_policy/syshealthmon.policy': blob_fixup()
        .add_line_if_missing('lseek: 1'),
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


if __name__ == '__main__':
    utils = ExtractUtils.device(module)
    utils.run()
