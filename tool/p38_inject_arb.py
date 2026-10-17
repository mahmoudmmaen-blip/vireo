# -*- coding: utf-8 -*-
"""Inject P38 l10n keys into all app_*.arb files (idempotent)."""
from __future__ import annotations

import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1] / "lib" / "core" / "l10n"

# English + Egyptian Arabic are authored; other locales get EN fallback for now.
EN = {
    "rebalanceCardTitle": "Today's rebalance",
    "rebalanceSafeDay": "You're still in the safe zone today",
    "rebalanceNeedsTap": "Nothing changes until you tap an option",
    "weeklyBalanceTitle": "Weekly balance",
    "weeklyBalanceEmpty": "Log a few days to see your weekly balance",
    "weeklyBalanceOnTrack": "Still on track: weekly deficit {actual} of {target}",
    "@weeklyBalanceOnTrack": {
        "placeholders": {
            "actual": {"type": "int"},
            "target": {"type": "int"},
        }
    },
    "weeklyBalanceOffTrack": "This week: deficit {actual} of {target} — we can adjust",
    "@weeklyBalanceOffTrack": {
        "placeholders": {
            "actual": {"type": "int"},
            "target": {"type": "int"},
        }
    },
    "weeklyBalanceCumulative": "Cumulative: {kcal} kcal",
    "@weeklyBalanceCumulative": {"placeholders": {"kcal": {"type": "int"}}},
    "energyLedgerTitle": "Your burn balance",
    "energyLedgerToday": "Today",
    "energyLedgerWeek": "Week",
    "energyLedgerMonth": "Month",
    "energyLedgerAllTime": "All time",
    "energyLedgerBurned": "Burned {kcal} kcal ≈ {fatKg} kg fat",
    "@energyLedgerBurned": {
        "placeholders": {
            "kcal": {"type": "int"},
            "fatKg": {"type": "String"},
        }
    },
    "energyLedgerBalanceNote": "Activity kcal and balance-based fat are labeled separately (estimate)",
    "energyLedgerStepsDistance": "{steps} steps · {km} km",
    "@energyLedgerStepsDistance": {
        "placeholders": {
            "steps": {"type": "int"},
            "km": {"type": "String"},
        }
    },
    "fingerprintTitle": "Your Fingerprint — Vireo smart system",
    "fingerprintSubtitle": "Learned from your real habits after 14 days",
    "fingerprintReset": "Reset",
    "fingerprintActivity": "Your activity",
    "fingerprintNutrition": "Your eating",
    "fingerprintTolerance": "Your tolerance",
    "fingerprintChronotype": "Your timing",
    "fingerprintStepsUnit": "comfortable steps",
    "fingerprintMealsCount": "{count} meals / day",
    "@fingerprintMealsCount": {"placeholders": {"count": {"type": "int"}}},
    "fingerprintDeficitValue": "Sustainable deficit ≈ {kcal} kcal",
    "@fingerprintDeficitValue": {"placeholders": {"kcal": {"type": "int"}}},
    "fingerprintLogHour": "Usually logs around {hour}:00",
    "@fingerprintLogHour": {"placeholders": {"hour": {"type": "int"}}},
    "fingerprintActivityWhy": "Why? Median of your best 70% step days",
    "fingerprintNutritionWhy": "Why? From your meal times and favorites",
    "fingerprintToleranceWhy": "Why? Deficit you sustain without rebound",
    "fingerprintChronotypeWhy": "Why? From your logging and walk hours",
    "fingerprintEdit": "Edit",
    "fingerprintNotReady": "Still learning — {days}/14 days",
    "@fingerprintNotReady": {"placeholders": {"days": {"type": "int"}}},
    "strideCalibratedBadge": "Calibrated to your walk ✓",
    "stepSourceLabel": "Source: {source}",
    "@stepSourceLabel": {"placeholders": {"source": {"type": "String"}}},
    "stepSourcePedometer": "Phone sensor",
    "stepSourceHealth": "Health Connect",
    "stepSourceManual": "Manual",
    "stepSourceNone": "Unavailable",
    "eatBackSettingTitle": "Eat-back from exercise",
    "eatBackHalf": "50% (default)",
    "eatBackFull": "100%",
    "eatBackNone": "0%",
    "tdeeCheckInTitle": "Your plan updated",
    "tdeeCheckInUndo": "Undo",
    "missedStepsCardTitle": "Yesterday's steps",
    "outdoorNetKcalLabel": "Net kcal",
    "outdoorCadenceLabel": "Cadence",
    "weeklyReviewTitle": "Weekly review",
    "adaptiveTdeeBlendNote": "Blended from your logs + formula",
}

AR_EG = {
    "rebalanceCardTitle": "تظبيط يومك",
    "rebalanceSafeDay": "عادي — يومك لسه في الأمان",
    "rebalanceNeedsTap": "مفيش تغيير غير لما تختار",
    "weeklyBalanceTitle": "ميزان الأسبوع",
    "weeklyBalanceEmpty": "سجّل كام يوم عشان نشوف ميزان الأسبوع",
    "weeklyBalanceOnTrack": "لسه في الهدف: عجز أسبوعي {actual} من {target}",
    "@weeklyBalanceOnTrack": {
        "placeholders": {
            "actual": {"type": "int"},
            "target": {"type": "int"},
        }
    },
    "weeklyBalanceOffTrack": "الأسبوع ده: عجز {actual} من {target} — نقدر نعدّل",
    "@weeklyBalanceOffTrack": {
        "placeholders": {
            "actual": {"type": "int"},
            "target": {"type": "int"},
        }
    },
    "weeklyBalanceCumulative": "التراكمي: {kcal} سعرة",
    "@weeklyBalanceCumulative": {"placeholders": {"kcal": {"type": "int"}}},
    "energyLedgerTitle": "رصيد حرقك",
    "energyLedgerToday": "اليوم",
    "energyLedgerWeek": "الأسبوع",
    "energyLedgerMonth": "الشهر",
    "energyLedgerAllTime": "من أول يوم",
    "energyLedgerBurned": "حرقت {kcal} سعرة ≈ {fatKg} كجم دهون",
    "@energyLedgerBurned": {
        "placeholders": {
            "kcal": {"type": "int"},
            "fatKg": {"type": "String"},
        }
    },
    "energyLedgerBalanceNote": "سعرات النشاط وتقدير الدهون من الرصيد منفصلين (تقديري)",
    "energyLedgerStepsDistance": "{steps} خطوة · {km} كم",
    "@energyLedgerStepsDistance": {
        "placeholders": {
            "steps": {"type": "int"},
            "km": {"type": "String"},
        }
    },
    "fingerprintTitle": "بصمتك — نظام Vireo الذكي",
    "fingerprintSubtitle": "اتعلمت من عاداتك الحقيقية بعد ١٤ يوم",
    "fingerprintReset": "ارجّع الافتراضي",
    "fingerprintActivity": "نشاطك",
    "fingerprintNutrition": "أكلك",
    "fingerprintTolerance": "تحمّلك",
    "fingerprintChronotype": "مواعيدك",
    "fingerprintStepsUnit": "خطوة مريحة",
    "fingerprintMealsCount": "{count} وجبات / يوم",
    "@fingerprintMealsCount": {"placeholders": {"count": {"type": "int"}}},
    "fingerprintDeficitValue": "عجز تتحمّله ≈ {kcal} سعرة",
    "@fingerprintDeficitValue": {"placeholders": {"kcal": {"type": "int"}}},
    "fingerprintLogHour": "بتسجّل عادة حوالي الساعة {hour}",
    "@fingerprintLogHour": {"placeholders": {"hour": {"type": "int"}}},
    "fingerprintActivityWhy": "ليه؟ متوسط أحسن ٧٠٪ من أيام خطواتك",
    "fingerprintNutritionWhy": "ليه؟ من مواعيد وجباتك وأكلك المفضّل",
    "fingerprintToleranceWhy": "ليه؟ العجز اللي بتكمله من غير ارتداد",
    "fingerprintChronotypeWhy": "ليه؟ من مواعيد التسجيل والمشي",
    "fingerprintEdit": "عدّلها",
    "fingerprintNotReady": "لسه بنتعلّم — {days}/١٤ يوم",
    "@fingerprintNotReady": {"placeholders": {"days": {"type": "int"}}},
    "strideCalibratedBadge": "مُعايَر على مشيك ✓",
    "stepSourceLabel": "المصدر: {source}",
    "@stepSourceLabel": {"placeholders": {"source": {"type": "String"}}},
    "stepSourcePedometer": "حساس الموبايل",
    "stepSourceHealth": "الصحة",
    "stepSourceManual": "يدوي",
    "stepSourceNone": "غير متاح",
    "eatBackSettingTitle": "استرجاع سعرات التمرين",
    "eatBackHalf": "٥٠٪ (افتراضي)",
    "eatBackFull": "١٠٠٪",
    "eatBackNone": "٠٪",
    "tdeeCheckInTitle": "خطتك اتعدلت",
    "tdeeCheckInUndo": "تراجع",
    "missedStepsCardTitle": "خطوات امبارح",
    "outdoorNetKcalLabel": "صافي سعرات",
    "outdoorCadenceLabel": "إيقاع الخطوة",
    "weeklyReviewTitle": "مراجعة الأسبوع",
    "adaptiveTdeeBlendNote": "مزيج من تسجيلك + المعادلة",
}

AR = dict(AR_EG)  # MSA/SA get EG copy for coach tone consistency where sensible
AR["fingerprintTitle"] = "بصمتك — نظام Vireo الذكي"


def merge(path: Path, extra: dict) -> None:
    data = json.loads(path.read_text(encoding="utf-8"))
    changed = False
    for k, v in extra.items():
        if k not in data:
            data[k] = v
            changed = True
    if changed:
        path.write_text(
            json.dumps(data, ensure_ascii=False, indent=2) + "\n",
            encoding="utf-8",
        )
        print(f"updated {path.name}")
    else:
        print(f"skip {path.name}")


def main() -> None:
    mapping = {
        "app_en.arb": EN,
        "app_ar_EG.arb": AR_EG,
        "app_ar.arb": AR,
        "app_ar_SA.arb": AR,
        "app_es.arb": EN,
        "app_fr.arb": EN,
        "app_hi.arb": EN,
        "app_id.arb": EN,
        "app_tr.arb": EN,
        "app_ur.arb": EN,
    }
    for name, extra in mapping.items():
        merge(ROOT / name, extra)


if __name__ == "__main__":
    main()
