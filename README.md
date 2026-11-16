# Government Complaints — Flutter Client

The citizen-facing Flutter app for the [Government Complaints System](https://github.com/AmmarZeineh/complaints) API.
This repository covers the **authentication flow**: sign up, email verification and log in.
It is the base the complaint screens are built on.

![Flutter](https://img.shields.io/badge/Flutter-02569B?logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?logo=dart&logoColor=white)
![BLoC](https://img.shields.io/badge/State-BLoC%2FCubit-blue)

## What's built

- Sign up and log in against the NestJS API
- Email verification with a one-time code (`flutter_verification_code_field`)
- Arabic and English with `easy_localization`

## Architecture

Feature-first Clean Architecture (`lib/core`, `lib/feature/auth` with data / domain / presentation),
BLoC/Cubit state, `get_it` for dependency injection, Dio for networking and `dartz` `Either` for errors.

## Tech stack

Flutter · flutter_bloc · get_it · Dio · dartz · easy_localization · flutter_screenutil

## Getting started

```bash
flutter pub get
flutter run
```

## Author

**Ammar Zeineh**, Flutter Developer · [LinkedIn](https://linkedin.com/in/ammar-zeineh) · [GitHub](https://github.com/AmmarZeineh)
