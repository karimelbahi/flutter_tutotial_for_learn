# Quickstart: Cache-First SSOT Validation

**Feature**: 005-cache-first-ssot

## Prerequisites

- `.env` with valid TMDB `API_KEY`
- Device/emulator with network toggle (airplane mode)
- Branch: `feature/cache-first-ssot-architecture`

## 1. First launch (cache miss)

1. Clear app data / fresh install
2. Open app → home shows loading then movies
3. Confirm carousel and rows populate

**Expected**: Normal loading UX (no cache yet)

## 2. Second launch (cache hit)

1. Kill app fully
2. Reopen with network **on**
3. Observe home appears with movies **immediately** (no full-screen spinner)
4. Data may update subtly when network refresh completes

**Expected**: Instant cached UI; optional brief refresh indicator if implemented

## 3. Offline with cache

1. Browse home + open one movie detail online
2. Enable airplane mode
3. Kill and reopen app
4. Home lists visible; previously opened detail visible

**Expected**: Cached content shown; stale/offline banner if network refresh fails

## 4. Offline without cache

1. Fresh install → airplane mode before first successful fetch
2. Open app

**Expected**: Error state with retry (no fake data)

## 5. Genre tabs

1. Load Action tab online
2. Switch to Comedy online
3. Airplane mode → switch between Action and Comedy

**Expected**: Each tab shows its own cached slice

## 6. Detail revisit

1. Open movie A detail online
2. Back → open movie A again

**Expected**: Detail sections appear instantly from cache

## 7. Search (network-first)

1. Online → search "Batman" → results
2. Airplane mode → search "Superman"

**Expected**: Search error (no cached search results)

## 8. Automated checks

```bash
dart analyze lib/
flutter test
```

All must pass before marking spec complete.
