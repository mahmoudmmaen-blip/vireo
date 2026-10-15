# Play Console — إجابات النماذج (v2, 2026-10-14)

> الإجابات مبنية على الكود الحالي (supabase/functions + AndroidManifest + DATA_MAP).
> ⚠️ أي ميزة تتغير بعدين (مثلاً تفعيل مزامنة بيانات الدورة) لازم تحدّث الإجابات دي قبل أي نسخة جديدة.

---

## 1) Data safety

### الأسئلة العامة
| السؤال | الإجابة |
|---|---|
| Does your app collect or share any of the required user data types? | **Yes** |
| Is all of the user data collected by your app encrypted in transit? | **Yes** (HTTPS/TLS) |
| Do you provide a way for users to request that their data is deleted? | **Yes** — داخل التطبيق (Settings → Delete account) + إيميل |
| Data deletion URL (مطلوب) | صفحة ويب فيها خطوات المسح + الإيميل (هتتعمل مع سياسة الخصوصية) |

### أنواع البيانات
| النوع في Play | Collected | Shared | Optional? | الغرض | ملاحظات |
|---|---|---|---|---|---|
| **Personal info → Email address** | Yes | No | Required (لو عمل حساب) | Account management | Supabase Auth |
| **Personal info → User IDs** | Yes | No | Required | Account management, App functionality | |
| **Health and fitness → Health info** | Yes | No | Optional | App functionality, Personalization | الوزن، قياسات الجسم، تقارير InBody (الأرقام بس — صورة التقرير بتتحلل ومش بتتخزن)، إجابات الأمان (حمل/سكر). **بيانات الدورة: محلية فقط → لا تُعلن كـ collected** (شوف تحت) |
| **Health and fitness → Fitness info** | Yes | No | Optional | App functionality, Personalization | خطوات، تمارين، صيام، Health Connect |
| **Location → Precise location** | Yes | No | Optional | App functionality | أثناء المشي/الجري الخارجي بس، foreground فقط، مفيش background |
| **Location → Approximate location** | Yes | **Yes** | Optional | Advertising (AdMob للمجاني) | |
| **Photos and videos → Photos** | Yes | No | Optional | App functionality | صور الأكل وتقارير الجسم تتحلل عن طريق Gemini (معالج خدمة — مش "sharing" حسب تعريف Play) **وما بتتخزنش**. صور التقدم محلية إلا لو فعّل النسخ الاحتياطي |
| **Audio → Voice or sound recordings** | **No** | No | — | — | التحويل لنص على الجهاز (speech_to_text) والصوت ما بيتسجلش |
| **Messages → Other in-app messages** | Yes | No | Optional | App functionality | رسايل كوتش Vireo بتتبعت للسيرفر → Gemini للرد، **وما بتتخزنش على السيرفر** (اللي بيتخزن عداد الاستخدام بس). علّم **Processed ephemerally = Yes** |
| **Financial info → Purchase history** | Yes | No | Required (للمشتركين) | App functionality | RevenueCat / Google Play Billing |
| **App activity → App interactions** | Yes | No | Optional | Analytics | |
| **App info and performance → Crash logs, Diagnostics** | Yes | Yes | Optional | Analytics | Sentry + AdMob |
| **Device or other IDs** | Yes | **Yes** | Optional | Advertising, Analytics | AD_ID للمجاني بس |

### بيانات الدورة الشهرية (مهم)
- محفوظة في Hive مشفّر **على الجهاز فقط**، ومفيش مزامنة.
- حسب تعريف Google: البيانات اللي ما بتطلعش من الجهاز **مش "collected"**، فما تتعلنش في Data safety.
- لو اتفعّلت المزامنة في المستقبل → لازم تتعلن: Health info (menstrual) — Collected, Not shared, Optional.

---

## 2) Health apps declaration (App content → Health apps)
علّم على:
- ✅ **Nutrition and weight management**
- ✅ **Activity and fitness**
- ✅ **Menstrual / reproductive health** (عشان متابعة الدورة ووضع الحمل)
- ✅ **Sleep management** (لو تتبع النوم/تذكير النوم ظاهر في التطبيق)
- ❌ Medical / disease management, Clinical, Medications (لأ)

## 3) Health Connect permissions declaration
- مكتوب في الـManifest: READ_STEPS, HEART_RATE, RESTING_HEART_RATE, HRV, OXYGEN_SATURATION, SLEEP, WEIGHT, BODY_FAT, LEAN_BODY_MASS, EXERCISE.
- ⚠️ **Google بترفض أي صلاحية Health Connect مش مستخدمة فعلاً.** قبل الرفع لازم الـAgent يتأكد إن كل صلاحية مستخدمة في الكود ويشيل الباقي (موجود في P37). لكل صلاحية تفضل: اكتب ميزة واحدة واضحة بتستخدمها (مثلاً WEIGHT/BODY_FAT/LEAN_BODY_MASS → تحديث تحليل الجسم من الميزان الذكي).

## 4) Content rating (IARC questionnaire)
| السؤال | الإجابة |
|---|---|
| Category | **All other app types** (مش Game ولا Social ولا Reference) |
| Violence / Fear / Sexual content / Profanity / Drugs / Gambling | **No** لكلهم |
| Does the app allow users to interact or exchange content? | **Yes** — تحديات الخطوات مع الأصدقاء (لوحة صدارة بالخطوات بس) |
| Does the app share user's location with other users? | **No** |
| Digital purchases | **Yes** (اشتراك Pro) |
| Ads | **Yes** |
| النتيجة المتوقعة | تقريباً **PEGI 3 / Everyone** مع ملاحظة "Users Interact, In-App Purchases" |

## 5) Target audience and content
- Target age: **18 and over فقط** ✅
  - السبب: تطبيق سعرات وصيام وتخسيس → لو اخترت أقل من 18 هيدخل تحت سياسة Families وقيود أصعب بكتير على الإعلانات والبيانات.
- Appeals to children? **No**

## 6) Ads
- Contains ads: **Yes**

## 7) App access (للمراجع)
- اختار: **All or some functionality is restricted** ← ادّي بيانات حساب مراجع:
  - إيميل حساب تجريبي + باسورد (انت اللي تعمله وتكتبه — أنا ما أقدرش)
  - شغّل له SQL الـpro_grants (موجود في docs/RELEASE.md §5b) عشان يشوف مزايا Pro.
  - ملاحظة للمراجع: "Use the 'Scan meal' button on Home; any food photo works. Body report: Home → Body analysis → Scan InBody report."

## 8) Government apps / Financial features / News
- **No** لكلهم.
