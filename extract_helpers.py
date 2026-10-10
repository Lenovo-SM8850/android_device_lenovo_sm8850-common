#
# SPDX-License-Identifier: Apache-2.0
#

import os


def device_blob_fixups():
    from extract_utils.fixups_blob import blob_fixup

    return {
        (
            'vendor/lib64/soundfx/libquasar.so',
            'vendor/lib64/camera/components/com.qti.node.fd.so',
            'vendor/lib64/hw/camera.qcom.core.so',
            'vendor/lib64/libcamerapoweroptfeature.so',
            'vendor/lib64/libcamxdumpinforecorder.so',
            'vendor/lib64/libpowercore.so',
            'vendor/lib64/libvideooptfeature.so',
        ): blob_fixup()
            .replace_needed('libtinyxml2.so', 'libtinyxml2-v36.so'),
        (
            'vendor/lib64/camera/components/com.qti.node.dewarp.so',
            'vendor/lib64/vendor.qti.hardware.camera.offlinecamera-service-impl.so',
        ): blob_fixup()
            .replace_needed('android.hardware.graphics.allocator-V1-ndk.so', 'android.hardware.graphics.allocator-V2-ndk.so'),
        'vendor/lib64/libqcodec2_core.so': blob_fixup()
            .replace_needed('android.hardware.graphics.common-V5-ndk.so', 'android.hardware.graphics.common-V7-ndk.so'),
    }  # fmt: skip

def write_elf_data_modules(proprietary_file, ctx, packages_ctx, *, device, owner):
    from extract_utils import makefiles
    from extract_utils.file import FileArgs, SimpleFileList

    # This extract-utils revision applies MODULE only to stem-capable rules.
    # The OEM face XML needs a distinct module name, retaining filename_from_src.
    original = makefiles.file_stem_package_name
    if not getattr(original, '_lenovo_face_name', False):
        def face_module_name(file, can_have_stem=False, any_extension=False):
            if (file.dst == 'vendor/etc/vintf/manifest/face-default.xml'
                    and file.args.get(FileArgs.MODULE) == 'face-lenovo.xml'):
                can_have_stem = True
            return original(file, can_have_stem, any_extension)

        face_module_name._lenovo_face_name = True
        makefiles.file_stem_package_name = face_module_name

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
