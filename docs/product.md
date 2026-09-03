# Product

## Overview

CleanRoll helps users clean a photo album quickly by reviewing one photo at a time.

Platforms: Android and iOS.
No backend. No login. No internet required for the core flow.
Photos never leave the device.

---

## Goal

Let a user pick an album, choose an order, swipe through photos, and confidently delete unwanted ones without accidents.

Users must not be trapped in a large album. They can open Review at any time, then continue swiping or delete what they have marked so far.

---

## MVP flow

1. Open app (home = album grid with CleanRoll header + settings drawer)
2. Request photo-library permission if needed (same screen)
3. Optionally set theme (light/dark/system) and language (en/es/ca/system) from the left drawer
4. Choose an album
5. Choose an order in a bottom sheet:
   - Newest → oldest
   - Oldest → newest
   - Random
6. Review photos one by one:
   - swipe one side → Keep
   - swipe the other side → mark for deletion
   - Undo last decision
   - **Review** button (center) → open the deletion grid anytime
7. From Review the user can:
   - deselect individual photos
   - preview a selected photo
   - **Continue** → return to cleaning at the same place
   - **Delete N photos** → platform deletion (system confirmation)
8. When the album runs out of photos, open Review automatically
9. After successful deletion, show completion with a Done button back to home

---

## Session rules

### Keep

- mark current photo as kept
- advance to next photo
- do not modify the library

### Delete (mark)

- add current photo to the deletion set
- advance to next photo
- do not delete yet

### Undo

- reverse up to the last 5 Keep / Delete decisions
- no unlimited undo history in MVP
- Review deselection is not part of the undo stack

### Mid-session Review

- available at any time during cleaning via a clear **Review** control
- shows only photos currently marked for deletion
- **Continue** resumes cleaning without losing progress
- deleting from Review only affects the current deletion set
- remaining unreviewed photos are left untouched

### Order

- Newest → oldest: platform creation date descending
- Oldest → newest: ascending
- Random: shuffle once when the session starts

### Album

- user selects one album/collection before cleaning
- session only reviews photos from that album
- do not build album management (create/rename/move)

---

## Review rules

- show count of selected photos
- show 3-column grid
- tap to deselect from deletion set
- preview stays simple: tap thumbnail to enlarge, tap photo or dark background to close
- deselect only from the grid (X), not from preview
- primary destructive CTA: `Delete N photos` (correct singular/plural)
- secondary action: `Continue` (back to cleaning) when the session is not finished
- never show `Delete 0 photos`
- if none selected and session still has photos: `Nothing selected` + `Continue`
- if none selected and session finished: `Nothing to delete` + start new session

Deletion only happens after the user taps Delete in Review and the platform delete flow completes (including any system confirmation dialog).

Do not show a second in-app confirmation dialog.

---

## Permissions and empty states

Handle:

- permission granted / denied / limited / permanently denied
- empty album / no accessible photos
- loading and deletion failures with plain-language messages

Limited access: work only with accessible photos. Do not claim access the app does not have.

---

## Out of scope

Do not implement unless explicitly requested:

- login / accounts / backend / cloud
- ads / subscriptions / analytics
- AI / duplicates / similar photos
- photo editing / filters
- album management beyond selection
- videos as a special mode (unless the chosen album naturally includes them and platform APIs make it trivial; prefer photos-only for MVP)
- statistics / history / gamification
- multi-device sync

---

## Success criteria

A user can:

1. grant photo access
2. pick an album and an order
3. swipe Keep / Delete with undo
4. open Review mid-session and continue later
5. review, deselect, and delete only the current selection
6. finish early without reviewing every photo in a large album
7. start another session

The flow must feel fast, obvious, and safe.
