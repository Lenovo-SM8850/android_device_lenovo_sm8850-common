/*
 * SPDX-License-Identifier: Apache-2.0
 */
package io.github.miner7222.lenovodefaults;

import android.content.BroadcastReceiver;
import android.content.ContentResolver;
import android.content.Context;
import android.content.Intent;
import android.os.UserHandle;

import lineageos.providers.LineageSettings;

public final class BootCompletedReceiver extends BroadcastReceiver {
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
    }
}
