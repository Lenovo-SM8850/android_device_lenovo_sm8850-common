/*
 * SPDX-License-Identifier: Apache-2.0
 */
package io.github.miner7222.lenovodefaults;

import android.content.BroadcastReceiver;
import android.content.ContentResolver;
import android.content.Context;
import android.content.Intent;
import android.os.UserHandle;
import android.provider.Settings;

import lineageos.providers.LineageSettings;

public final class BootCompletedReceiver extends BroadcastReceiver {
    private static final String[] DEFAULT_OFF_KEYS = {
        "spoof_pif_enabled", "spoof_trickystore_enabled",
    };

    @Override
    public void onReceive(Context context, Intent intent) {
        if (!Intent.ACTION_LOCKED_BOOT_COMPLETED.equals(intent.getAction())
                && !Intent.ACTION_BOOT_COMPLETED.equals(intent.getAction())) {
            return;
        }

        ContentResolver resolver = context.getContentResolver();
        // Persist the battery-light default shared by the summary and backend.
        if (LineageSettings.System.getStringForUser(resolver,
                LineageSettings.System.BATTERY_LIGHT_ENABLED, UserHandle.USER_SYSTEM) == null) {
            LineageSettings.System.putIntForUser(resolver,
                    LineageSettings.System.BATTERY_LIGHT_ENABLED, 1, UserHandle.USER_SYSTEM);
        }
        for (String key : DEFAULT_OFF_KEYS) {
            if (Settings.System.getStringForUser(resolver, key, UserHandle.USER_SYSTEM) == null) {
                Settings.System.putIntForUser(resolver, key, 0, UserHandle.USER_SYSTEM);
            }
        }
    }
}
