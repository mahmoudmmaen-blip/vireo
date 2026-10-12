# Google AdMob Content Safety & Blocking Controls Checklist

This document details the exact, step-by-step checklist for configuring **strict family-safe ad filtering** inside the Google AdMob Dashboard for Vireo.

---

## 1. Vireo Brand & Safety Policy

Vireo enforces a strict family-safe policy:
- **No women imagery or provocative depictions**
- **No sexual, reproductive, or dating content**
- **No lingerie, swimwear, or women's revealing clothing**
- **No gambling, alcohol, politics, or religion**
- **Max Ad Content Rating:** **G** (General Audiences)

---

## 2. In-Code Filtering (Already Implemented)

Vireo automatically instructs the Google Mobile Ads SDK to apply the highest content restriction before loading any ads:

```dart
MobileAds.instance.updateRequestConfiguration(
  RequestConfiguration(
    maxAdContentRating: MaxAdContentRating.g,
    tagForChildDirectedTreatment: TagForChildDirectedTreatment.unspecified,
    tagForUnderAgeOfConsent: TagForUnderAgeOfConsent.unspecified,
  ),
);
```

---

## 3. AdMob Console Blocking Controls Checklist

Follow these steps in your [Google AdMob Console](https://apps.admob.com):

### Step A: Maximum Ad Content Rating
1. Go to **Blocking controls** &rarr; **All apps** (or select **Vireo**).
2. Click on **Ad content rating**.
3. Set the **Maximum ad content rating** to **G** (Content suitable for general audiences).
4. Save changes.

### Step B: Sensitive Categories (Block ALL of the following)
1. Go to **Blocking controls** &rarr; **Sensitive categories**.
2. Block **all** available categories, especially:
   - [x] **Dating**
   - [x] **Sexual & reproductive health**
   - [x] **References to sex & sexuality**
   - [x] **Gambling & betting** (including simulated gambling)
   - [x] **Alcohol**
   - [x] **Sensationalism & shocking content**
   - [x] **Get-rich-quick / financial schemes**
   - [x] **Religion**
   - [x] **Politics**
   - [x] **Cosmetic procedures & body modification**
   - [x] **Weight loss drugs & invasive surgeries**

### Step C: General Categories (Block Apparel & Beauty Subcategories)
1. Go to **Blocking controls** &rarr; **General categories**.
2. Expand **Apparel**:
   - [x] Block **Women's Clothing**
   - [x] Block **Lingerie & Underwear**
   - [x] Block **Swimwear**
3. Expand **Beauty & Personal Care**:
   - [x] Block categories with model/revealing photography
4. Expand **Fashion & Modeling**:
   - [x] Block as appropriate

### Step D: Ad Review Center
1. Navigate to **Blocking controls** &rarr; **Ad review center**.
2. Turn ON **Ad review center**.
3. **Manual Review:** Periodically review shown ads. You can immediately block any specific ad or advertiser account across all your apps with 1 click.

### Step E: User-Based & Personalized Ads (Optional)
1. In **Blocking controls** &rarr; **EU user consent / Advanced settings**, review personalized ads settings.

---

## 4. Important Operational Note

> **Note:** Automated network filters catch the vast majority of non-compliant ads. However, no automated filter is 100% infallible. The **Ad Review Center** in the AdMob Console is your ultimate safeguard: check it weekly during the first month to review and block any ad that does not meet Vireo's standards.
