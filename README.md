# SkillBridge

A mobile platform that connects skilled workers (welders, tailors, carpenters,
hairdressers and more) with clients who need their services. Workers **show**
their skills, **prove** them with badges and certifications, and **grow** their
reputation by winning jobs.

Built with Flutter.

## Features

- **Onboarding** — branded splash and a three-step intro: Show It, Prove It, Grow It.
- **Role selection** — sign up as a Skilled Worker or a Client.
- **Authentication** — registration and sign in with form validation.
- **Worker profile setup** — trade, location, bio, experience, rate and skills.
- **Dashboards** — role-specific landing screens after authentication.

## Getting started

### Prerequisites

- Flutter 3.47+ (Dart 3.13+)

### Run the app

```bash
flutter pub get
flutter run
```

### Run the tests

```bash
flutter analyze
flutter test
```

## Demo accounts

The app ships with in-memory demo accounts so you can sign in immediately:

| Role   | Email                     | Password      |
| ------ | ------------------------- | ------------- |
| Worker | `worker@skillbridge.app`  | `password123` |
| Client | `client@skillbridge.app`  | `password123` |

New accounts can also be created from the role selection screen. All accounts
live in memory only and reset when the app restarts.

## App flow

```
Splash → Onboarding → Role Selection → Register / Sign In
       → Worker Profile Setup (workers only) → Worker / Client Dashboard
```

## Project structure

```
lib/
├── main.dart                 # Entry point
├── app.dart                  # Root widget (AuthScope + MaterialApp)
├── core/                     # Theme, colors, routes, constants, validators
│   ├── app_colors.dart
│   ├── app_theme.dart
│   ├── app_routes.dart
│   ├── app_constants.dart
│   └── validators.dart
├── models/                   # User role, user and worker profile models
│   ├── user_role.dart
│   ├── app_user.dart
│   └── worker_profile.dart
├── state/                    # Session state shared across the app
│   ├── auth_service.dart
│   └── auth_scope.dart
├── widgets/                  # Reusable UI components
│   ├── brand_logo.dart
│   ├── app_text_field.dart
│   └── primary_button.dart
└── features/                 # Screens grouped by area
    ├── splash/
    ├── onboarding/
    ├── auth/
    ├── profile/
    └── dashboard/
```

## Theme

The brand uses a **navy blue** palette (`#0B2447`) with an amber accent
(`#F2A93B`), applied through a Material 3 theme in `lib/core/app_theme.dart`.

## Shared session state

Every screen can read the logged-in session through `AuthScope`:

```dart
final auth = AuthScope.of(context);

auth.currentUser;    // AppUser? (name, email, phone, role, location, initials)
auth.userRole;       // UserRole.worker | UserRole.client
auth.workerProfile;  // WorkerProfile? (trade, bio, location, skills, rate)
auth.signOut();
```

`AuthService` is currently in-memory and can be swapped for a backend later
without changing the screens.

## Team breakdown

| Section | Owner    | Screens   | Scope                                                            |
| ------- | -------- | --------- | ---------------------------------------------------------------- |
| 1       | Person 1 | 1–5       | App entry, onboarding and authentication *(done)*               |
| 2       | Person 2 | 6–7       | Worker and client dashboards                                     |
| 3       | Person 3 | 8–12      | Worker discovery and profiles                                    |
| 4       | Person 4 | 13–19     | Jobs, bookings and communication                                 |
| 5       | Person 5 | 20–24     | Skills verification, certification and final integration         |

### Handover from Section 1 to Section 2

Section 1 provides:

- The signed-in user (`AppUser`) including name, email, phone and location.
- The selected `UserRole` (worker or client).
- The worker's basic `WorkerProfile` when applicable.
- Named routes (`AppRoutes`) for navigation and `signOut()` for logout.

Person 2 replaces the placeholder dashboard sections with profile completion,
job/skills overviews and role-specific bottom navigation.
