#!/usr/bin/env -S PYTHONPATH=../../../tools/extract-utils python3
#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

from pathlib import Path
import hashlib
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
    'vendor.qti.snapdragonServices-V2-ndk':
        lib_fixup_framework_suffix,
    'vendor.qti.hardware.perf2-V1-ndk':
        lib_fixup_framework_suffix,
    'vendor.qti.hardware.cacertaidlservice-V1-ndk':
        lib_fixup_system_suffix,
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
    'libdolbyui':
        lambda lib, partition: f'{lib}-system' if partition == 'system' else lib,
    'libdolbyproxyandroid':
        lambda lib, partition: f'{lib}-system' if partition == 'system' else lib,
    'vendor.qti.hardware.wifidisplaysession_aidl-V1-ndk':
        lib_fixup_system_suffix,
    'vendor.qti.qspmhal-V1-ndk':
        lib_fixup_system_suffix,
    'vendor.qti.hardware.vpp-V1-ndk':
        lib_fixup_framework_suffix,
}


def keep_qti_decoder_output_retries(ctx, file, file_path, **kwargs):
    path = Path(file_path)
    data = bytearray(path.read_bytes())
    cases = {'87f54f332136968a44bdb7e43d651e53fec3c1a6a56798af8bb24dd8af9695fd': (1772092, '69090054', '97823e087e3d34cbf53ca9334e8c5f0002cd265237b9c75600fbe7afa8c6fc97'), '8b95c98941fe03657c6d0c41d9892f380603a25a6642017fdc7e5703cadef3e8': (1780816, '69090054', 'e778f61c4ea31af061ea6b986dfe2f94cd0b46971a2230fda2db2b599cb145a3')}
    actual = hashlib.sha256(data).hexdigest()
    if actual not in cases:
        raise ValueError(f"{file.dst}: unexpected QTI decoder SHA256 {actual}")
    offset, original, expected = cases[actual]
    if data[offset:offset + 4] != bytes.fromhex(original):
        raise ValueError("Unexpected output-allocation retry branch")
    # DecoderOutputAllocator::handleOutputBufferAllocation: keep retries.
    data[offset:offset + 4] = bytes.fromhex("4b 00 00 14")
    if hashlib.sha256(data).hexdigest() != expected:
        raise ValueError("Unexpected patched QTI decoder SHA256")
    path.write_bytes(data)


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


def patch_hexlp_resolution_cap(ctx, file, file_path, **kwargs):
    path = Path(file_path)
    data = bytearray(path.read_bytes())
    expected = 'e24302326bb6379199b014f3142ef259ce5b83d05cb218980430967938a349b6'
    if hashlib.sha256(data).hexdigest() != expected:
        raise ValueError(f'{file.dst}: unexpected hexlp session source')
    pattern = bytes.fromhex('1f 05 1b 71')
    if data.count(pattern) != 1:
        raise ValueError(f'{file.dst}: expected one resolution cap, found {data.count(pattern)}')
    offset = data.index(pattern)
    data[offset:offset + 4] = bytes.fromhex('1f c5 1d 71')
    fixed = '498198bbd436d52b7147516f39c15ab233370cee2371f83ed95b310c0b2e834b'
    if hashlib.sha256(data).hexdigest() != fixed:
        raise ValueError(f'{file.dst}: unexpected patched hexlp session')
    path.write_bytes(data)


def patch_gppservice_rc(ctx, file, file_path, **kwargs):
    path = Path(file_path)
    data = path.read_bytes()
    expected = 'd9fe1cbd0f0e29fbf6146ad1cbeece02554ba28a88d022f4b4373b702b1c93e3'
    if hashlib.sha256(data).hexdigest() != expected:
        raise ValueError(f'{file.dst}: unexpected gppservice.rc source')
    if not data.endswith(b'\n'):
        data += b'\n'
    data += (b'\non property:vendor.gpp.reload=1\n'
             b'    restart vendor.gppservice\n'
             b'    setprop vendor.gpp.reload 0\n'
             b'\non post-fs-data\n'
             b'    mkdir /data/misc/lenovo-gpp 0770 system system\n'
             b'    copy /system/etc/gpp_app_list /data/misc/lenovo-gpp/list\n'
             b'    chown system system /data/misc/lenovo-gpp/list\n'
             b'    chmod 0660 /data/misc/lenovo-gpp/list\n'
             b'    restorecon /data/misc/lenovo-gpp\n'
             b'    restorecon /data/misc/lenovo-gpp/list\n'
             b'    mount none /data/misc/lenovo-gpp/list /system/etc/gpp_app_list bind\n')
    fixed = '39d1525109621555c5aae506a67cc7b4a20e9db1c17fb93b83dc7da80f397b8e'
    if hashlib.sha256(data).hexdigest() != fixed:
        raise ValueError(f'{file.dst}: unexpected patched gppservice.rc')
    path.write_bytes(data)


blob_fixups: blob_fixups_user_type = {
    'system_ext/priv-app/WfdService/WfdService.apk': blob_fixup()
        .apktool_patch('blob-patches/WfdService'),
    'system/framework/WfdCommon.jar': blob_fixup()
        .apktool_patch('blob-patches/WfdCommon.patch'),
    'system/etc/init/gppservice.rc': blob_fixup()
        .call(patch_gppservice_rc, need_tmp_dir=False),
    'system/lib64/libgpphexlpsession.so': blob_fixup()
        .call(patch_hexlp_resolution_cap, need_tmp_dir=False),
    ('vendor/etc/wifi/kiwi_v2/WCNSS_qcom_cfg.ini', 'vendor/etc/wifi/wcn7750/WCNSS_qcom_cfg.ini'): blob_fixup()
        .call(enable_ull_scan_requests, need_tmp_dir=False),
    'vendor/bin/init.qti.kernel.debug-alor.sh': blob_fixup()
        .regex_replace(r'echo 4 > \$DCC_PATH/curr_list', 'echo 6 > $DCC_PATH/curr_list'),
    'system_ext/etc/permissions/telephony_system-ext_privapp-permissions-qti.xml': blob_fixup()
        .regex_replace('<privapp-permissions package="(?:org.codeaurora.dialer|com.android.mms)">[\\s\\S]*?</privapp-permissions>', ''),
    (
        'system/lib64/libdolbyui.so',
        'vendor/lib64/libdolbyui.so',
    ): blob_fixup()
        .replace_needed('android.hardware.graphics.common-V6-ndk.so', 'android.hardware.graphics.common-V7-ndk.so'),
    (
        'vendor/lib64/c2.dolby.vision.dec.so',
        'vendor/lib64/c2.dolby.vision.sec.dec.so',
    ): blob_fixup()
        .add_needed('libcodec2_shim.so'),
    'system_ext/lib64/libwfdservice.so': blob_fixup()
        .replace_needed('android.media.audio.common.types-V4-cpp.so', 'android.media.audio.common.types-V5-cpp.so'),
    'vendor/etc/seccomp_policy/qsap_qapeservice.policy': blob_fixup()
        .add_line_if_missing('lseek: 1'),
    'vendor/bin/hw/vendor.qti.media.c2audio@1.0-service': blob_fixup()
        .replace_needed('android.hardware.media.c2-V1-ndk.so', 'android.hardware.media.c2-V2-ndk.so'),
    (
        'vendor/bin/poweropt-service',
        'vendor/bin/qsap_mpamsvc',
        'vendor/lib64/camera/components/com.qti.node.fd.so',
        'vendor/lib64/hw/camera.qcom.core.so',
        'vendor/lib64/libaodoptfeature.so',
        'vendor/lib64/libcamerapoweroptfeature.so',
        'vendor/lib64/libgamepoweroptfeature.so',
        'vendor/lib64/liblearningmodule.so',
        'vendor/lib64/liboffscreenpoweroptfeature.so',
        'vendor/lib64/libpowercallback.so',
        'vendor/lib64/libpsmoptfeature.so',
        'vendor/lib64/libstandbyfeature.so',
        'vendor/lib64/libvideooptfeature.so',
        'vendor/lib64/soundfx/libquasar.so',
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
    'vendor/lib64/vendor.qti.hardware.vibratorCL.impl-lenovo.so': blob_fixup()
        .call(patch_vibrator_capabilities, need_tmp_dir=False),
    'vendor/lib64/vendor.qti.hardware.vibratorOL.impl-lenovo.so': blob_fixup()
        .replace_needed('libqtivibratoreffect.so', 'libqtivibratoreffect-lenovo.so')
        .replace_needed('libqtivibratoreffectoffload.so', 'libqtivibratoreffectoffload-lenovo.so')
        .call(patch_vibrator_capabilities, need_tmp_dir=False),
    'vendor/lib64/libqcodec2_core.so': blob_fixup()
        .replace_needed('android.hardware.graphics.common-V5-ndk.so', 'android.hardware.graphics.common-V7-ndk.so'),
    'vendor/lib64/libqcodec2_v4l2codec.so': blob_fixup()
        .call(keep_qti_decoder_output_retries, need_tmp_dir=False),
    'vendor/lib64/libpowercore.so': blob_fixup()
        .replace_needed('libtinyxml2.so', 'libtinyxml2-v36.so'),
    'vendor/lib64/libwfdmmsrc_proprietary.so': blob_fixup()
        .replace_needed('libwfdaac_vendor.so', 'libwfdaac.lenovo.so'),
    'vendor/lib64/vendor.qti.hardware.camera.offlinecamera-service-impl.so': blob_fixup()
        .replace_needed('android.hardware.graphics.allocator-V1-ndk.so', 'android.hardware.graphics.allocator-V2-ndk.so'),
    (
        'vendor/etc/vintf/manifest/c2_manifest_vendor.xml',
        'vendor/etc/vintf/manifest/c2_manifest_vendor_audio.xml',
    ): blob_fixup()
        .regex_replace(r'(\s*)(<name>android.hardware.media.c2</name>)(?:\s*<version>\d+</version>)?', r'\1\2\1<version>2</version>'),
    'vendor/etc/seccomp_policy/syshealthmon.policy': blob_fixup()
        .add_line_if_missing('clock_gettime: 1')
        .add_line_if_missing('lseek: 1'),
    'vendor/lib64/libcamxdumpinforecorder.so': blob_fixup()
        .replace_needed('libtinyxml2.so', 'libtinyxml2-v36.so'),
    'vendor/bin/hw/vendor.qti.media.c2@1.0-service': blob_fixup()
        .replace_needed('android.hardware.media.c2-V1-ndk.so', 'android.hardware.media.c2-V2-ndk.so'),
    'vendor/bin/init.qti.kernel.early_debug.sh': blob_fixup()
        .regex_replace(r'Copyright \(c\) Qualcomm Technologies, Inc\. and/or its subsidiaries\.', 'Copyright (c) 2024-2025 Qualcomm Technologies, Inc.'),
    'vendor/etc/wifi/peach_v2/WCNSS_qcom_cfg.ini': blob_fixup()
        .call(enable_ull_scan_requests, need_tmp_dir=False),
    'vendor/lib64/camera/components/com.qti.node.dewarp.so': blob_fixup()
        .replace_needed('android.hardware.graphics.allocator-V1-ndk.so', 'android.hardware.graphics.allocator-V2-ndk.so'),
    'vendor/lib64/soundfx/libswgamedapaidl.so': blob_fixup()
        .replace_needed('android.hardware.audio.effect-V3-ndk.so', 'android.hardware.audio.effect-V4-ndk.so')
        .replace_needed('android.media.audio.common.types-V4-ndk.so', 'android.media.audio.common.types-V5-ndk.so'),
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
