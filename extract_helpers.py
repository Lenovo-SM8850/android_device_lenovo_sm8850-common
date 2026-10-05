#
# SPDX-License-Identifier: Apache-2.0
#

import os
from pathlib import Path


def source_audio_builds():
    config = Path(__file__).resolve().parent / 'configs/audio/source-builds.mk'
    settings = {}
    for line in config.read_text().splitlines():
        key, separator, value = line.partition(':=')
        if separator:
            settings[key.strip()] = value.strip()
    keys = {'effects': 'LENOVO_SOURCE_AUDIO_EFFECTS',
            'wfd_aac': 'LENOVO_SOURCE_WFD_AAC'}
    if set(settings) != set(keys.values()) or any(
        value not in ('true', 'false') for value in settings.values()
    ):
        raise ValueError('Invalid Lenovo source audio build selectors')
    return {name: settings[key] == 'true' for name, key in keys.items()}


def device_blob_fixup_recipes():
    return {
        (
            'vendor/lib64/soundfx/libquasar.so',
            'vendor/lib64/camera/components/com.qti.node.fd.so',
            'vendor/lib64/hw/camera.qcom.core.so',
            'vendor/lib64/libcamerapoweroptfeature.so',
            'vendor/lib64/libcamxdumpinforecorder.so',
            'vendor/lib64/libpowercore.so',
            'vendor/lib64/libvideooptfeature.so',
        ): [('replace_needed', ['libtinyxml2.so', 'libtinyxml2-v36.so'])],
        (
            'vendor/lib64/camera/components/com.qti.node.dewarp.so',
            'vendor/lib64/vendor.qti.hardware.camera.offlinecamera-service-impl.so',
        ): [('replace_needed', ['android.hardware.graphics.allocator-V1-ndk.so',
                               'android.hardware.graphics.allocator-V2-ndk.so'])],
        'vendor/lib64/libqcodec2_core.so': [
            ('replace_needed', ['android.hardware.graphics.common-V5-ndk.so',
                               'android.hardware.graphics.common-V7-ndk.so']),
        ],
    }


def device_blob_fixups():
    from extract_utils.fixups_blob import blob_fixup

    fixups = {}
    for paths, operations in device_blob_fixup_recipes().items():
        fixup = blob_fixup()
        for operation, arguments in operations:
            getattr(fixup, operation)(*arguments)
        fixups[paths] = fixup
    return fixups


def write_elf_data_modules(proprietary_file, ctx, packages_ctx, *, device, owner):
    from extract_utils.file import SimpleFileList

    # Preserve ELF data bytes and installation paths.
    copies = SimpleFileList()
    for file in proprietary_file.file_list.copy_files:
        data_path = (
            file.dst.endswith('.odex')
            or file.dst.startswith(('vendor/firmware/', 'vendor/etc/bpf/',
                                    'vendor/etc/dcp_symbols/'))
        )
        is_elf = False
        if data_path:
            with open(os.path.join(packages_ctx.vendor_prop_path, file.dst), 'rb') as source:
                is_elf = source.read(4) == b'\x7fELF'
        if not is_elf:
            copies.add(file)
            continue
        name = 'lenovo_' + device + '_' + file.dst.replace('/', '_').replace('.', '_')
        directory, filename = file.dst.split('/', 1)[1].rsplit('/', 1)
        if device != 'sm8850-common':
            ctx.mk_out.write(f'\nifeq ($(TARGET_DEVICE),{device})\n')
        ctx.mk_out.write(
            '\ninclude $(CLEAR_VARS)\n'
            f'LOCAL_MODULE := {name}\n'
            f'LOCAL_MODULE_OWNER := {owner}\n'
            'LOCAL_MODULE_CLASS := ETC\n'
            f'LOCAL_SRC_FILES := {packages_ctx.vendor_prop_rel_sub_path}/{file.dst}\n'
            f'LOCAL_MODULE_PATH := $(TARGET_OUT_{file.partition.upper()})/{directory}\n'
            f'LOCAL_MODULE_STEM := {filename}\n'
            'include $(BUILD_PREBUILT)\n'
        )
        if device != 'sm8850-common':
            ctx.mk_out.write('endif\n')
        ctx.product_mk_out.write(f'\nPRODUCT_PACKAGES += {name}\n')
    proprietary_file.file_list.copy_files = copies
