# AGENTS.md

## Project

CleanRoll is a lightweight Flutter photo-cleaning app for Android and iOS.

Core loop: pick an album → pick an order → swipe Keep / Delete → open Review anytime → continue or confirm delete.

Keep the product deliberately small. Do not invent features.

---

## Source of truth

Before implementing or changing behavior, read:

- `docs/product.md` — scope and behavior
- `docs/ux.md` — screens and interactions
- `docs/technical.md` — architecture and implementation rules
- `docs/roadmap.md` — what is in / out of the current phase

If docs conflict with assumptions, the docs win.
If something is ambiguous, choose the simplest solution consistent with the docs.

---

## MVP in one line

Local-only photo cleaner: album + order selection, one-photo swipe, mid-session Review, deferred deletion with confirmation.

Users must never be trapped in a long album: Review is always available during cleaning.

---

## Critical safety rule

NEVER permanently delete a photo during swipe / review / undo.

"Delete" during cleaning means **mark for deletion**.

Real deletion happens only after:

1. the user opens Review (anytime, or at end of album)
2. the user can deselect photos
3. the user taps Delete and completes the **platform** confirmation dialog

Do not show an extra in-app confirmation dialog before calling the platform delete API.

If the app is closed before platform deletion succeeds, photos stay untouched.

---

## Terminology

- **Keep** — user decided to keep the photo
- **Delete** — user marked the photo for deletion
- **Selected for deletion** — photo currently in the deletion set
- **Review** — grid of current deletion candidates; available anytime during cleaning
- **Cleaning session** — one album + order review flow

Do not say a photo was "deleted" until the platform deletion succeeds.

---

## Core principles

Prefer:

- simple architecture
- few dependencies
- in-memory session state
- small widgets
- readable Dart/Flutter code

Avoid:

- backend, login, accounts, cloud
- databases
- ads, subscriptions, analytics
- AI, duplicates, similarity
- editors, filters, albums management beyond selection
- Clean Architecture / Bloc / Riverpod unless already present and needed
- speculative features

---

## Implementation workflow

1. Inspect existing project structure
2. Read the relevant docs
3. Implement the smallest change that works
4. Reuse existing code
5. Format / analyze / test when available
6. Consider both Android and iOS photo-library behavior

Do not rewrite working code without a reason.
Do not add a dependency without a clear need.

---

## Definition of done

A feature is done when:

- behavior matches `docs/product.md`
- UI matches `docs/ux.md`
- errors are handled
- no photo can be permanently deleted before confirmation
- code is formatted and analyzer/tests pass where applicable
