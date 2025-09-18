# Driver Flutter App

A basic Driver App simulating a food delivery flow: view assigned orders, navigate to restaurant/customer, geofence-based pickup/delivery, and live location updates.

---

## Features

- **Mock Login:** Simple mobile number/password login (no real backend).
- **Assigned Order Screen:** Shows order ID, restaurant & customer info, order amount (dummy).
- **Order Flow:**
  - Start Trip → Arrived at Restaurant → Picked Up → Arrived at Customer → Delivered
  - Geofence checks: arrival actions only allowed within 50 meters.
  - Distance display to restaurant/customer.
- **Navigation:** Navigate button opens Google Maps directions.
- **Location Updates:**
  - Current driver location displayed.
  - Updates every 10 seconds (printed to console as if sending to server).
- **Permission Handling:** Requests location permission, shows appropriate messages if denied.
- **Slider Button:** Slide-to-confirm order flow steps.
- **Floating Snackbar:** Shows messages like "Order delivered" above FAB.

---

## Setup Steps

1. **Clone the repository:**

```
git clone https://github.com/sree-vignesh/driver_flutter_app.git
cd driver_flutter_app
```

2. **Install dependencies:**

```
flutter pub get
```

3. **Run the app:**

```
flutter run
```

4. **Required permissions:**

- Location permission must be granted for the app to work.
- If location service is off, tap the FAB to enable it.

---

## Dummy Login Credentials

> Any mobile number/password will work, login is mock only.

- **mobile number:** `12345 67890`
- **Password:** `password123`

---

## Assumptions Made

1. Only **one assigned order** is shown at a time.
2. Distance calculations use **straight-line distance** (Geolocator).
3. Geofence threshold for arrival is **50 meters**.
4. Custom Slider is used due to the restriction of packages.
5. The app does **not connect to a real backend** — all order data is dummy.
6. No persistent storage — app state resets on restart.
