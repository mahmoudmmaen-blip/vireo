package com.vireoapp.fitness

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetBackgroundIntent
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider

class VireoWidgetMediumProvider : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.widget_medium).apply {
                val score = widgetData.getInt("widget_daily_score", 0)
                val steps = widgetData.getInt("widget_steps", 0)
                val water = widgetData.getInt("widget_water_ml", 0)

                setTextViewText(R.id.widget_score_val, score.toString())
                setTextViewText(R.id.widget_steps_val, "$steps ط®ط·ظˆط©")
                setTextViewText(R.id.widget_water_val, "$water ظ…ظ„")

                // Pending intent to open app on home
                val pendingIntent = HomeWidgetLaunchIntent.getActivity(
                    context,
                    MainActivity::class.java
                )
                setOnClickPendingIntent(R.id.widget_medium_container, pendingIntent)

                // Background intent for +250ml water action
                val backgroundIntent = HomeWidgetBackgroundIntent.getBroadcast(
                    context,
                    android.net.Uri.parse("vireo://quick_water_250")
                )
                setOnClickPendingIntent(R.id.widget_btn_water, backgroundIntent)
            }
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}
