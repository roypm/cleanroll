# Technical

## Stack

- Flutter + Dart
- Android + iOS
- Shared code wherever possible
- No backend, no auth, no database for MVP

---

## Architecture

Keep a light layered structure:

```text
lib/
├── main.dart
├── app/                 # app widget, theme
├── models/              # PhotoItem, CleaningSession, Album, OrderMode
├── screens/             # home, album, order, cleaning, review, finished
├── widgets/             # photo card, grid, buttons
├── services/            # photo + permission access
└── controllers/         # cleaning session controller
```

This is a guideline. Do not create empty files just to match the tree.

Separate:

- UI / screens
- session logic
- photo-library service

Do not call platform photo APIs directly from widgets.

---

## State management

Use one lightweight approach consistently:

- `ChangeNotifier`, `ValueNotifier`, or a simple controller

Do not add Bloc / Riverpod / Redux for MVP unless the project already depends on it and it clearly helps.

Session state stays in memory. If the app is killed before confirmation, losing the session is acceptable.

---

## Domain concepts

### OrderMode

- `newestFirst`
- `oldestFirst`
- `random`

### CleaningSession

Tracks at least:

- selected album
- order mode
- photo list for the session
- current index
- kept set
- deletion set
- last actions for undo (stack, max 5)
- whether the session finished reviewing all photos

Session decisions are not deletions.

Review can open before the album is finished. Continuing from Review must restore the same `currentIndex` and sets.

### PhotoItem

Use platform asset identifiers / references.
Do not store image binary data in session state.

---

## Services

### PermissionService / PhotoService

Conceptual responsibilities:

- request / read permission state
- list albums
- list photos for an album
- provide thumbnails
- delete assets through the official platform API

Map package-specific permission types to simple app states:

`unknown | granted | limited | denied | permanentlyDenied`

---

## Deletion invariant

Two phases only:

1. Selection during cleaning / review
2. Confirmed platform deletion

Never modify the photo library on swipe, undo, navigation, or deselection.

Handle results explicitly:

- all succeeded
- all failed
- partial failure
- cancelled when supported

UI must never claim more deletions than actually succeeded.

---

## Platform notes

- Android: respect the media permission model for the chosen min SDK; no filesystem deletion as the normal path
- iOS: use PhotoKit through the chosen Flutter package; support limited library access
- Prefer a maintained photo package that supports read + delete on both platforms
- Verify package support before adding it

---

## Performance

- lazy thumbnails
- avoid loading full-resolution images for every swipe
- cleaning screen only needs current / nearby photos
- review grid uses small thumbnails
- optimize only after a real performance problem

---

## Theme

Centralize spacing, typography, colors, and button styles in a small theme.
Do not build a full design system early.

---

## Testing priorities

Unit-test session logic first:

- keep advances and does not delete
- mark-for-delete adds to set and does not delete
- undo restores previous decision
- deselect removes from deletion set
- empty deletion set does not offer delete CTA
- opening Review mid-session preserves index and sets
- Continue from Review resumes at the same index
- order modes produce the expected ordering / shuffle once

Widget-test where practical: buttons, grid count, confirmation.

Manual/device testing for permissions, limited access, and real deletion.

---

## Dependency policy

Add a package only if Flutter / existing deps cannot do the job.
Prefer maintained, focused packages.
Every dependency needs a reason.

---

## Done when

- app builds for Android and iOS
- album + order selection works
- swipe / buttons / undo work
- mid-session Review + Continue works
- review / deselect / preview work
- confirmed deletion uses platform APIs
- failures are surfaced correctly
- no accidental deletion before confirmation
- session tests pass
- format + analyzer are clean
