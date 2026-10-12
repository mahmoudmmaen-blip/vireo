package com.vireofit.app

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider

class VireoWidgetSmallProvider : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.widget_small).apply {
                val score = widgetData.getInt("widget_daily_score", 0)
                val steps = widgetData.getInt("widget_steps", 0)
                val water = widgetData.getInt("widget_water_ml", 0)

                setTextViewText(R.id.widget_score_val, score.toString())
                setTextViewText(R.id.widget_steps_val, "👣 $steps")
                setTextViewText(R.id.widget_water_val, "💧 ${(water / 1000.0).let { String.format("%.1fL", it) }}")
            }
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}
