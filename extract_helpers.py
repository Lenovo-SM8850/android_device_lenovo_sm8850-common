#
# SPDX-License-Identifier: Apache-2.0
#


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


def preserve_face_module_name(ctx, packages_ctx):
    from extract_utils import makefiles
    from extract_utils.file import FileArgs

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
