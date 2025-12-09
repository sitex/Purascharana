---
date: 2025-12-09T15:55:00+00:00
researcher: Claude
topic: "Purascharana iOS App - Design & Specification"
tags: [research, ios, swiftui, purascharana, mantra-counter]
status: complete
last_updated: 2025-12-09
last_updated_by: Claude
---

# Research: Purascharana iOS App

**Date**: 2025-12-09
**Researcher**: Claude

## Research Question

Create an iPhone app called Purascharana for counting daily mantra repetition circles (круги) from 0 to 5556 with state persistence, daily increment input, settings for manual adjustment, and copy functionality in Russian format.

## Summary

Purascharana (पुरश्चरण) is a Sanskrit term meaning "preparatory practice" - a spiritual discipline in Hindu tradition involving the repetition of a mantra a specific number of times. This app tracks progress toward completing a purascharana of **5556 circles (круги)**.

---

## Detailed Findings

### Core Functionality

1. **Counter Display**
   - Show current total circles completed
   - Display target: 5556
   - Visual progress indicator

2. **Daily Increment**
   - User enters number of circles completed today
   - Tap "Add" to increment total
   - Today's increment is stored for copy feature

3. **State Persistence**
   - Save count between app launches
   - Use UserDefaults/@AppStorage

4. **Settings**
   - Manually set/adjust current count
   - Reset option (with confirmation)

5. **Copy Feature**
   - Copy state in Russian format
   - Format: `"X круга (Y)"`
   - X = today's increment
   - Y = total circles
   - Example: `"16 круга (2524)"`

### Behavior Notes
- No automatic daily reset - today's increment persists until user adds new value
- Count capped at target (5556)
- Count cannot go below 0

---

## Technical Specification

### Platform
- **iOS 15.0+**
- **Swift 5**
- **SwiftUI**

### Architecture
```
Purascharana/
├── PurascharanaApp.swift       # @main entry point
├── ContentView.swift           # Main counter screen
├── SettingsView.swift          # Settings screen
└── Models/
    └── CounterState.swift      # ObservableObject + @AppStorage
```

### Data Model

```swift
class CounterState: ObservableObject {
    static let targetCircles = 5556

    @AppStorage("totalCircles") var totalCircles: Int = 0
    @AppStorage("todayIncrement") var todayIncrement: Int = 0

    func increment(by amount: Int)
    func setCount(_ count: Int)
    func reset()
    func copyStateString() -> String  // Returns "X круга (Y)"
    var progress: Double              // 0.0 to 1.0
}
```

### UI Screens

#### Main Screen (ContentView)
```
┌─────────────────────────────┐
│              ⚙️             │  <- Settings button
│                             │
│         2524 / 5556         │  <- Large counter
│    ════════════════         │  <- Progress bar (45%)
│                             │
│      ┌─────────────┐        │
│      │     16      │        │  <- Input field
│      └─────────────┘        │
│                             │
│   [ Добавить ]  [ Копировать ] │  <- Add / Copy buttons
│                             │
└─────────────────────────────┘
```

#### Settings Screen (SettingsView)
```
┌─────────────────────────────┐
│  ←  Настройки               │
│                             │
│  Текущее значение           │
│  ┌─────────────────────┐    │
│  │       2524          │    │
│  └─────────────────────┘    │
│                             │
│  Цель: 5556 кругов          │
│                             │
│  [ Сбросить счётчик ]       │  <- Reset (red, with alert)
│                             │
└─────────────────────────────┘
```

---

## Localization (Russian)

| Key | Russian |
|-----|---------|
| Add | Добавить |
| Copy | Копировать |
| Settings | Настройки |
| Current value | Текущее значение |
| Target | Цель |
| circles | кругов |
| Reset counter | Сбросить счётчик |
| Reset confirmation | Вы уверены? |
| Cancel | Отмена |
| Reset | Сбросить |
| Copied! | Скопировано! |

---

## Implementation Plan

1. Create Xcode project structure
2. Implement CounterState model
3. Build ContentView (main screen)
4. Build SettingsView
5. Add copy to clipboard functionality
6. Test persistence
7. Polish UI

---

## Usage Instructions

After implementation, user will:
1. Open Xcode on Mac
2. Create new SwiftUI App project named "Purascharana"
3. Replace generated files with our Swift files
4. Build and run on iPhone/Simulator

---

## Future Enhancements (Not in Scope)

- iCloud sync
- Widget for home screen
- History/statistics
- Multiple mantras tracking
- Notifications/reminders
