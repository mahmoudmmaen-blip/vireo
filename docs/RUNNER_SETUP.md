# RUNNER_SETUP — كيف يشتغل نظام الـ Runner مع Cursor

## الفكرة

- أنت بتحط task files (JSON) في `.runner/inbox/`
- `runner.ps1` بينقل أول task لـ `running/` ويعمل `CURRENT_TASK.md`
- الـ Cursor agent (بيقرأ `AGENTS.md` أوتوماتيك لأنه في الـ root) بيشتغل على الـ current task لما تقوله **"run next"** أو **"كمل"**
- النتيجة والتقرير بيروحوا `.runner/done/`

> ملاحظة صريحة: الـ script مش بيخلي Cursor يشتغل لوحده بالكامل — لازم chat مفتوح وتقول "run next". الآلية دي هي اللي بتخلي النظام قابل لإعادة الاستخدام في أي project: انسخ `.runner/` + `AGENTS.md` + عدّل قواعد المنتج.

## التركيب في project جديد (5 دقائق)

```
YourProject\
  AGENTS.md              <- قواعد الـ agent + الـ gates (عدّلها حسب المشروع)
  .runner\
    runner.ps1           <- سكريبت إدارة الـ lifecycle
    inbox\               <- هنا بتحط الـ tasks
    running\
    done\
  docs\
    RUNNER_SETUP.md
```

1. انسخ الـ structure زي ما هو.
2. عدّل `AGENTS.md`: غيّر HARD RULES وProduct Rules حسب المشروع (package name، منصات، gates).
3. افتح Cursor terminal في الـ root وشغّل:
   ```powershell
   powershell -File .runner/runner.ps1
   ```
4. حط أول task JSON في `inbox/`، وقول في الـ chat: **"run next"**.

## شكل الـ task file

```json
{
  "id": "P45",
  "title": "عنوان قصير",
  "priority": "high | medium | low",
  "goal": "الهدف في سطر — ليه بنعمل ده",
  "steps": ["خطوة محددة وقابلة للتنفيذ", "..."],
  "acceptance": ["معيار قبول قابل للاختبار", "..."],
  "gates": ["analyze", "test", "build:aab"],
  "no_touch": ["files أو paths ممنوع المساس بيها"]
}
```

**قواعد كتابة tasks كويسة:**
- task واحد = scope واحد صغير (feature أو fix). لو أكبر من نص يوم شغل، قسّمه.
- `acceptance` لازم تكون قابلة للاختبار — مش "الشكل يبقى حلو".
- استخدم `no_touch` بسخاء حوالين الحاجات الخطيرة (signing, billing, package name).
- رقّم بشكل متسلسل (P45, P46...) — الـ runner بياخد الأصغر أولاً.

## Gates المتاحة في Vireo

| Gate | بيعمل إيه |
|---|---|
| `analyze` | `flutter analyze` — 0 errors |
| `test` | `flutter test` — كلها تعدي |
| `build:aab` | `flutter build appbundle --release` + تقرير path/size/version |
| `package` | تلقائي دائماً: `applicationId` لازم `com.vireofit.app` |

## سير العمل اليومي المقترح

1. الصبح: حط 1–3 tasks في الـ inbox (أو قولي وأنا أكتبهم).
2. شغّل الـ runner، وقول "run next" في Cursor.
3. راجع التقرير في `done/` قبل ما ترفع أي حاجة على Play Console.
4. **قاعدة ذهبية:** مفيش AAB بيترفع يدوياً إلا بعد report فيه gate `package` ✓.
