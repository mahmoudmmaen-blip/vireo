package com.vireoapp.fitness

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.net.Uri
import android.view.View
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider

class VireoWidgetSmallProvider : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        val calories = widgetData.getInt("widget_calories_remaining", 0)
        val emoji = widgetData.getString("widget_mascot_emoji", "ًںکٹ") ?: "ًںکٹ"
        val fastingActive = widgetData.getBoolean("widget_fasting_active", false)
        val fastingMin = widgetData.getInt("widget_fasting_remaining_min", 0)
        val isDark = widgetData.getBoolean("widget_is_dark", true)
        val isRtl = widgetData.getBoolean("widget_is_rtl", false)

        appWidgetIds.forEach { widgetId ->
            val layoutId = if (isDark) R.layout.widget_small else R.layout.widget_small_light
            val views = RemoteViews(context.packageName, layoutId).apply {
                setTextViewText(R.id.widget_mascot_emoji, emoji)
                setTextViewText(R.id.widget_calories_val, calories.toString())

                if (fastingActive && fastingMin > 0) {
                    val hours = fastingMin / 60
                    val mins = fastingMin % 60
                    val countdown = if (isRtl) {
                        "âڈ³ ${hours}:${mins.toString().padStart(2, '0')} ظ„ظ„ط¥ظپط·ط§ط±"
                    } else {
                        "âڈ³ ${hours}:${mins.toString().padStart(2, '0')} to eat"
                    }
                    setTextViewText(R.id.widget_fasting_countdown, countdown)
                    setViewVisibility(R.id.widget_fasting_countdown, View.VISIBLE)
                } else {
                    setViewVisibility(R.id.widget_fasting_countdown, View.GONE)
                }

                val launchUri = Uri.parse("vireo://nutrition/camera")
                val pendingIntent = HomeWidgetLaunchIntent.getActivity(
                    context,
                    MainActivity::class.java,
                    launchUri
                )
                setOnClickPendingIntent(R.id.widget_small_container, pendingIntent)
            }
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}
