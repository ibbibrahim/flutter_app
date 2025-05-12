# 📚 School App

Welcome to **login\_portal**, a modern Flutter-based school management app designed for parents and students to easily track academic and personal information in real time.

## 🚀 Overview

`login_portal` is part of a comprehensive school information system built with Flutter. It provides a smooth, intuitive interface for accessing key student data such as:

* 🎯 Attendance tracking with swipeable calendar views
* 🦧 Health profile management with update functionality
* 🏠 Address and parent info with WebView editing
* 🧾 Basic information like QID, DOB, Religion, and more
* 🔐 Secure student login via backend integration

This app ensures a seamless experience for families and school admins by integrating with core PHP APIs and displaying dynamic student data.

---

## ✨ Features

### 👨‍🏫 Student Dashboard

* Quick overview of student’s attendance, health, and personal records.
* Clean UI with actionable cards.

### 🗕️ Attendance Calendar

* Monthly attendance tracking with left/right swipe navigation.
* Marked days with status colors: Present (green), Absent (red), etc.
* Detailed day-wise view with clear visual feedback.

### 🏥 Health Profile

* View health card, height, weight, BMI, allergies, and conditions.
* Update button opens a responsive WebView screen for editing.

### 🏡 Address & Parent Info

* View residential details like zone, villa/flat, and landmark.
* In-app WebView to update address and parent information securely.

---

## 📲 Tech Stack

* **Frontend**: Flutter (Dart)
* **Backend API**: Core PHP (JSON-based)
* **Web Content**: Rendered via WebView
* **State Management**: SetState (Lightweight approach)
* **UI Library**: Material Components

---

## 🛠️ Getting Started

To run this project locally:

```bash
flutter pub get
flutter run
```

---

## 🔁 Flutter Upgrade Compatibility Checklist

Use this checklist whenever you upgrade Flutter to ensure your project stays compatible:

### 1️⃣ Run Upgrade Command

```bash
flutter upgrade
flutter --version
```

* 📌 Note down Flutter & Dart versions.

---

### 2️⃣ Update Dart SDK in `pubspec.yaml`

```yaml
environment:
  sdk: '>=3.7.0 <4.0.0' # Example, adjust based on flutter --version
```

Then run:

```bash
flutter pub get
```

---

### 3️⃣ Check Android Compile SDK

**File:** `android/app/build.gradle`

```gradle
android {
    compileSdkVersion 34 // or 35
    targetSdkVersion 34
}
```

---

### 4️⃣ Update Android Gradle Plugin (AGP)

**File:** `android/settings.gradle`

```gradle
plugins {
    id "com.android.application" version "8.1.0" apply false
}
```

---

### 5️⃣ Update Gradle Wrapper

**File:** `android/gradle/wrapper/gradle-wrapper.properties`

```properties
distributionUrl=https\://services.gradle.org/distributions/gradle-8.2-bin.zip
```

---

### 6️⃣ Update Kotlin Version (if used)

**File:** `android/settings.gradle`

```gradle
id "org.jetbrains.kotlin.android" version "1.9.10" apply false
```

---

### 7️⃣ Clean & Rebuild Project

```bash
flutter clean
flutter pub get
flutter build apk # or flutter run
```

---

### 8️⃣ Resolve Plugin Warnings

```bash
flutter pub outdated
flutter pub upgrade --major-versions
```

---

This checklist ensures your Flutter project remains smooth and future-proof after every upgrade.
