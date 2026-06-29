# GrandeBeach Flutter Project Guidelines

## Project Overview

This project is a production-ready Flutter application for GrandeBeach Resort.

The application is a chalet booking platform supporting:

- Authentication
- Booking Management
- Dynamic Pricing
- Promotions
- Loyalty Program
- Payments
- Google Maps
- Notifications
- Reviews
- Multi-language (Arabic / English)
- Dark Mode

Always assume production-quality code.

---

# Architecture

Use Feature First + Clean Architecture.

Each feature should contain:

```
feature/

├── models/
├── services/ (interface/impl)
├── repositories/ (interface/impl)
├── controllers/
├── screens/
└── widgets/
```

Never place unrelated features together.

---

# State Management

Always use Riverpod.

Prefer:

- AsyncNotifier
- Notifier
- Provider
- FutureProvider

Avoid:

- Provider package
- Bloc
- GetX
- setState except for very small UI-only state.

---

# Navigation

Use go_router.

Support authentication guards.

Use typed routes where possible.

---

# Network

Use Dio.

Every API call must go through:

Repository
↓

Remote Data Source
↓

Api Client (Dio)

Never call Dio directly inside UI.

Use interceptors for:

- Authentication
- Refresh Token
- Logging
- Localization
- Error Handling

---



# Dependency Injection

Use Riverpod providers.

Avoid GetIt unless specifically required.

---

# Local Storage

Use:

Hive
for cached data.

flutter_secure_storage
for tokens.

Never store tokens inside Hive.

---

# Error Handling

Use Result pattern.

Repositories should return:

Result<T>

instead of throwing exceptions.

---

# Widgets

Never create private widget methods inside screen files.

❌

Widget _buildHeader()

Widget _buildCard()

Widget _buildButton()

Instead,

Create separate widget files.

Example:

booking/

presentation/

screens/

booking_screen.dart

widgets/

booking_header.dart

booking_price_card.dart

booking_footer.dart

Every reusable widget must live inside widgets/.

---

# Screen Size

Responsive layout must support:

Mobile (different devices)
Tablet

Use LayoutBuilder or flutter_screenutil when needed.

---

# Localization

Support:

English (LTR)

Arabic (RTL)

Every new text must be localized.

Never hardcode UI strings.

---

# Theme

Support:

Light Mode

Dark Mode

Project Colors:

Primary Gold:

#D39C00

Primary Grey:

#3A3A3A

Colors must adapt correctly for both themes.

Never hardcode colors inside widgets.

Always use AppTheme or Theme.of(context).

---

# Images

Use CachedNetworkImage.

Use shimmer loading placeholders.

---

# Loading states



Use skelton  loading placeholders that match screen design .

---

# Code Style

Use const whenever possible.

Prefer stateless widgets.

Keep widget trees clean.

Avoid nested code.

Split large widgets.

Follow Dart formatting.

---

# Folder Structure

lib/

core/

config/

constants/

errors/

extensions/

network/

routes/

services/

theme/

utils/

widgets/

features/

    authentication/

    booking/

    chalets/

    checkout/

    home/

    loyalty/

    notifications/

    payment/

    profile/

    promotions/

    reviews/

    search/

    settings/

    shared/

assets/

---

# Best Practices

Prefer composition over inheritance.

Keep business logic out of UI.

UI should only interact with Providers.

Never calculate booking prices locally.

Pricing must always come from backend.

Always separate:

UI

Business Logic

Network

Storage

Always write scalable production-ready Flutter code.

When generating new code, follow these guidelines automatically.