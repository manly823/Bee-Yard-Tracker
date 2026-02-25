# Bee Yard Tracker

Complete apiary management toolkit for beekeepers. Track hives, log inspections, record honey harvests, calculate feeding ratios, and follow seasonal task guides — all in one app.

## Features

### Hive Management
- Add unlimited hives with type, location, and detailed notes
- 4 hive types: Langstroth, Top Bar, Warré, Flow Hive
- Queen tracking: status, international marker color, age in days
- Quick health overview from latest inspection

### Inspection Log
- 12-point inspection checklist per hive visit
- Track: queen seen, eggs, larvae, queen cells, brood pattern, honey/pollen stores (1-5 scale), bee mood, varroa mite count, overall health
- Color-coded badges for health, brood, and mood

### Honey Harvest Tracker
- Log harvests with weight, honey type, and tasting notes
- 7 honey varieties with distinct color indicators
- Triple quality rating: taste, clarity, aroma (5-star each)
- Running totals and average quality stats

### Feeding Calculator
- 4 feed types: Light Syrup (1:1), Heavy Syrup (2:1), Fondant, Pollen Patty
- Auto-calculate water and total weight from sugar input
- Seasonal usage guide with color-coded recommendations

### Seasonal Calendar
- 32 detailed tasks across 4 seasons
- Spring: buildup, swarm prevention, splitting
- Summer: supers, harvest, mite monitoring
- Fall: mite treatment, winter prep, feeding
- Winter: stores check, emergency feeding, planning

## Architecture

- **Pattern**: MVVM (Model-View-ViewModel)
- **Persistence**: UserDefaults via generic `Storage` service
- **Navigation**: Enum-based sheet management (`Destination`)
- **Styling**: Reusable `CardStyle` ViewModifier + `Theme` struct
- **UI**: SwiftUI with animated honeycomb menu, spring animations
- **Minimum iOS**: 16.0

## Technical Details

- 16 Swift files, ~1200 lines of code
- 8 enums with computed properties (icons, colors, data)
- 3 core data structures (Hive, InspectionEntry, HarvestEntry)
- Zero third-party dependencies
- All data stored locally on device

## Build

```
xcodebuild -project BeeYardTracker.xcodeproj -scheme BeeYardTracker -destination 'generic/platform=iOS Simulator' build
```
