# Asl Attara – Inventory & Sales Management System

A cross-platform inventory and sales management application designed for small businesses. The system supports offline-first functionality with secure cloud synchronization, allowing users to manage products, track inventory movements, record sales transactions, and maintain data backups.

## Features

* User Authentication (Login, Register, Forgot Password)
* Product Management
* Category Management
* Sales Recording
* Automatic Inventory Updates
* Inventory Movement Tracking
* Inventory Auditing
* Activity Logs
* Offline-First Experience
* Secure Cloud Backup & Synchronization
* User-Specific Data Isolation

## Tech Stack

* Flutter
* Dart
* Firebase Authentication
* Cloud Firestore
* SQLite (sqflite)
* Flutter Bloc (Cubit)
* Clean Architecture
* GetIt (Dependency Injection)

## Architecture

The project follows Clean Architecture principles and is organized using a feature-based structure:

```text
lib/
├── core/
├── features/
│   ├── auth/
│   ├── products/
│   ├── categories/
│   ├── sales/
│   ├── inventory/
│   └── activity/
└── main.dart
```

Each feature is separated into:

```text
feature/
├── data/
├── domain/
└── presentation/
```

## Offline-First Strategy

SQLite is used as the primary local database to ensure fast performance and uninterrupted operation without internet access.

Firebase Authentication and Cloud Firestore are used for:

* Secure user authentication
* Cloud backup
* Data synchronization
* User-specific data storage

## Security

Firestore Security Rules ensure that each user can only access their own data.

## Getting Started

1. Clone the repository.
2. Install dependencies:

```bash
flutter pub get
```

3. Configure Firebase:

```bash
flutterfire configure
```

4. Run the application:

```bash
flutter run
```

## Author

Gamal Azzam

* LinkedIn: https://www.linkedin.com/in/gamal-3zzam/
