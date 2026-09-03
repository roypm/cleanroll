# UX

## Principles

Minimal, fast, visual, one-handed, trustworthy.
The photo is the main content. UI stays out of the way.

Users must always be able to leave the swipe loop via Review — never trap them in a large album.

Priority order:

1. Safety
2. Clarity
3. Speed
4. Ease of use
5. Visual polish

---

## Navigation

```text
Home (albums)
  ↳ settings drawer (left)
  ↳ order bottom sheet
  → Cleaning ⇄ Review
  → Finished
```

Cleaning and Review go back and forth until the user confirms deletion or ends the session.

No tabs. Settings live only in the home drawer.

---

## Screens

### Home

The home screen is the album grid with a light brand header.

- hamburger (animated menu/close) on the **left** of the header
- title: CleanRoll + short tagline
- 2-column grid of square album covers (name + photo count)
- tapping an album opens an order bottom sheet
- if permission is missing, show the permission explanation on this same screen (Allow access / Open settings)
- no separate “Start cleaning” screen

### Settings drawer

Opened from the home hamburger. Slides in from the left.

- Appearance: Light / Dark / System
- Language: English / Español / Català / System
- Choices persist on device
- Selecting an option can close the drawer

### Order bottom sheet

Shown after tapping an album. Lightweight — not a full screen.

Three clear options:

- Newest first
- Oldest first
- Random

Choosing one starts the cleaning session.
Dismiss / drag down cancels and stays on the album grid.

### Cleaning

Photo dominates the screen.

```text
┌──────────────────────────────┐
│  ←                     37/248│
│                              │
│             PHOTO            │
│                              │
│                              │
│   ✕      [ Review ]      ✓   │
│  delete               keep   │
│            ↶ undo            │
└──────────────────────────────┘
```

Interactions:

- swipe one side = Keep
- swipe the other side = mark for deletion
- Keep / Delete buttons as alternatives to swipe
- center **Review** button opens the current deletion grid
- small undo control
- progress like `37 / 248`
- preserve aspect ratio; do not stretch
- prefer thumbnails / optimized images over full-res when possible

Review is available even if the deletion set is empty (then Review explains nothing is selected yet and offers Continue).

### Review

Opened from Cleaning anytime, or automatically when the album is finished.

- title + `N photos selected`
- 3-column thumbnail grid
- clear selected-for-deletion affordance
- tap thumbnail → full-screen preview (dark background)
- tap photo or background → close preview
- deselect only with the X on the grid tile (not in preview)
- actions:
  - **Continue** — return to Cleaning at the same photo/index (hidden or replaced when the album is fully reviewed)
  - **Delete N photos** — calls the platform delete API (system confirmation dialog)
- if N = 0 and photos remain: `Nothing selected` + `Continue`
- if N = 0 and album finished: `Nothing to delete` + `Start new session`

### Platform deletion confirmation

Do **not** show an in-app confirmation dialog before deletion.

Rely on the platform photo-library confirmation (Android MediaStore / iOS PhotoKit via the photo package).

If the user cancels the system dialog, stay on Review and do not claim success.

### Finished

- simple success state with count removed
- one primary button: **Done** → back to home (album grid)

If deletion was partial/failed, say so clearly.

After deletion succeeds, go to Finished. Returning home starts a fresh path (pick album again); do not auto-resume the leftover album.

---

## States

### Empty album

`No photos to review` + back/home action.

### Nothing to delete

`You kept all the photos in this session.` + start new session.

### Permission

Short explanation + allow access / open settings when permanently denied.
Do not spam permission dialogs.

### Loading / deleting

Subtle loading when needed.
Disable delete CTA while deletion is in progress.

### Errors

User-facing language only. No raw platform exceptions.

---

## Interaction notes

- one-hand friendly controls
- accessible labels on icon buttons
- do not rely on color alone
- animations only when they help (swipe feedback, transitions); keep them short
- Review must feel like an escape hatch, not a dead end
