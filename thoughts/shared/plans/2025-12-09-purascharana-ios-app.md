# Purascharana iOS App Implementation Plan

## Overview

Create an iPhone app called "Purascharana" for tracking daily mantra repetition circles (круги) from 0 to 5556. The app persists state between launches, allows daily increments, manual adjustment via settings, and copying state in Russian format.

## Current State Analysis

This is a **greenfield project** - no existing codebase. We're creating Swift source files that will be imported into a new Xcode SwiftUI project.

## Desired End State

A complete set of Swift files that, when added to a new Xcode SwiftUI project:
- Display current circle count and progress toward 5556
- Accept daily increment input and add to total
- Persist data between app launches using UserDefaults
- Allow manual count adjustment in Settings
- Copy state string in Russian format: `"X круга (Y)"`

### Verification:
1. All Swift files compile without errors in Xcode
2. App runs on iOS Simulator
3. Counter persists after app restart
4. Copy produces correct Russian format string

## What We're NOT Doing

- Xcode project file (.xcodeproj) - user creates this in Xcode
- App Store deployment configuration
- iCloud sync
- Widgets
- History/statistics tracking
- Multiple mantra support
- Notifications

## Implementation Approach

Create 4 Swift files in a logical order:
1. Data model first (CounterState)
2. App entry point (PurascharanaApp)
3. Main UI (ContentView)
4. Settings UI (SettingsView)

---

## Phase 1: Project Structure & Data Model

### Overview
Create directory structure and implement the core data model with persistence.

### Changes Required:

#### 1. Directory Structure
```
Purascharana/
├── Purascharana/
│   ├── Models/
│   │   └── CounterState.swift
│   ├── PurascharanaApp.swift
│   ├── ContentView.swift
│   └── SettingsView.swift
└── thoughts/
    └── shared/
        ├── research/
        └── plans/
```

#### 2. CounterState.swift
**File**: `Purascharana/Models/CounterState.swift`

```swift
import SwiftUI

class CounterState: ObservableObject {
    static let shared = CounterState()
    static let targetCircles = 5556

    @AppStorage("totalCircles") var totalCircles: Int = 0
    @AppStorage("todayIncrement") var todayIncrement: Int = 0

    private init() {}

    func increment(by amount: Int) {
        guard amount > 0 else { return }
        todayIncrement = amount
        totalCircles = min(totalCircles + amount, CounterState.targetCircles)
    }

    func setCount(_ count: Int) {
        totalCircles = max(0, min(count, CounterState.targetCircles))
    }

    func reset() {
        totalCircles = 0
        todayIncrement = 0
    }

    func copyStateString() -> String {
        return "\(todayIncrement) круга (\(totalCircles))"
    }

    var progress: Double {
        return Double(totalCircles) / Double(CounterState.targetCircles)
    }

    var isComplete: Bool {
        return totalCircles >= CounterState.targetCircles
    }
}
```

### Success Criteria:

#### Automated Verification:
- [x] File exists at `Purascharana/Models/CounterState.swift`
- [x] Swift syntax is valid (no compilation errors when added to Xcode)

#### Manual Verification:
- [x] N/A for this phase - tested in later phases

---

## Phase 2: App Entry Point

### Overview
Create the SwiftUI app entry point that initializes the CounterState.

### Changes Required:

#### 1. PurascharanaApp.swift
**File**: `Purascharana/PurascharanaApp.swift`

```swift
import SwiftUI

@main
struct PurascharanaApp: App {
    @StateObject private var counterState = CounterState.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(counterState)
        }
    }
}
```

### Success Criteria:

#### Automated Verification:
- [x] File exists at `Purascharana/PurascharanaApp.swift`
- [x] Contains `@main` attribute

#### Manual Verification:
- [ ] N/A for this phase

---

## Phase 3: Main Screen (ContentView)

### Overview
Build the main counter screen with display, input field, and action buttons.

### Changes Required:

#### 1. ContentView.swift
**File**: `Purascharana/ContentView.swift`

```swift
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var counterState: CounterState
    @State private var inputText: String = ""
    @State private var showSettings = false
    @State private var showCopiedToast = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                Spacer()

                // Counter Display
                VStack(spacing: 8) {
                    Text("\(counterState.totalCircles)")
                        .font(.system(size: 72, weight: .bold, design: .rounded))
                        .foregroundColor(counterState.isComplete ? .green : .primary)

                    Text("из \(CounterState.targetCircles)")
                        .font(.title2)
                        .foregroundColor(.secondary)
                }

                // Progress Bar
                ProgressView(value: counterState.progress)
                    .progressViewStyle(LinearProgressViewStyle(tint: counterState.isComplete ? .green : .blue))
                    .scaleEffect(x: 1, y: 2, anchor: .center)
                    .padding(.horizontal, 40)

                Text("\(Int(counterState.progress * 100))%")
                    .font(.caption)
                    .foregroundColor(.secondary)

                Spacer()

                // Input Section
                VStack(spacing: 16) {
                    TextField("Кругов сегодня", text: $inputText)
                        .keyboardType(.numberPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 200)
                        .multilineTextAlignment(.center)
                        .font(.title2)

                    HStack(spacing: 20) {
                        Button(action: addCircles) {
                            Label("Добавить", systemImage: "plus.circle.fill")
                                .font(.headline)
                                .frame(minWidth: 130)
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(inputText.isEmpty)

                        Button(action: copyState) {
                            Label("Копировать", systemImage: "doc.on.doc")
                                .font(.headline)
                                .frame(minWidth: 130)
                        }
                        .buttonStyle(.bordered)
                    }
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Пурасчарана")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showSettings = true }) {
                        Image(systemName: "gearshape")
                    }
                }
            }
            .sheet(isPresented: $showSettings) {
                SettingsView()
            }
            .overlay(alignment: .bottom) {
                if showCopiedToast {
                    Text("Скопировано!")
                        .padding()
                        .background(Color.green.opacity(0.9))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .padding(.bottom, 50)
                }
            }
        }
    }

    private func addCircles() {
        guard let amount = Int(inputText), amount > 0 else { return }
        counterState.increment(by: amount)
        inputText = ""
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    }

    private func copyState() {
        let stateString = counterState.copyStateString()
        UIPasteboard.general.string = stateString
        UIImpactFeedbackGenerator(style: .light).impactOccurred()

        withAnimation {
            showCopiedToast = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                showCopiedToast = false
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(CounterState.shared)
}
```

### Success Criteria:

#### Automated Verification:
- [ ] File exists at `Purascharana/ContentView.swift`
- [ ] Contains NavigationStack, TextField, Button components

#### Manual Verification:
- [ ] Counter displays correctly (0 / 5556 initially)
- [ ] Progress bar shows 0%
- [ ] Input field accepts numbers
- [ ] "Добавить" button increments counter
- [ ] "Копировать" button copies to clipboard
- [ ] Toast appears after copying
- [ ] Settings gear opens settings sheet

---

## Phase 4: Settings Screen

### Overview
Build the settings screen with manual count adjustment and reset functionality.

### Changes Required:

#### 1. SettingsView.swift
**File**: `Purascharana/SettingsView.swift`

```swift
import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var counterState: CounterState
    @Environment(\.dismiss) var dismiss
    @State private var countText: String = ""
    @State private var showResetAlert = false

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Текущее значение")) {
                    HStack {
                        TextField("Количество кругов", text: $countText)
                            .keyboardType(.numberPad)

                        Button("Сохранить") {
                            if let count = Int(countText) {
                                counterState.setCount(count)
                                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                            }
                        }
                        .disabled(countText.isEmpty)
                    }
                }

                Section(header: Text("Информация")) {
                    HStack {
                        Text("Цель")
                        Spacer()
                        Text("\(CounterState.targetCircles) кругов")
                            .foregroundColor(.secondary)
                    }

                    HStack {
                        Text("Прогресс")
                        Spacer()
                        Text("\(Int(counterState.progress * 100))%")
                            .foregroundColor(.secondary)
                    }

                    HStack {
                        Text("Последнее добавление")
                        Spacer()
                        Text("\(counterState.todayIncrement) кругов")
                            .foregroundColor(.secondary)
                    }
                }

                Section {
                    Button(role: .destructive) {
                        showResetAlert = true
                    } label: {
                        HStack {
                            Spacer()
                            Text("Сбросить счётчик")
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("Настройки")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Готово") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                countText = String(counterState.totalCircles)
            }
            .alert("Сбросить счётчик?", isPresented: $showResetAlert) {
                Button("Отмена", role: .cancel) { }
                Button("Сбросить", role: .destructive) {
                    counterState.reset()
                    countText = "0"
                    UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                }
            } message: {
                Text("Это действие нельзя отменить. Весь прогресс будет потерян.")
            }
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(CounterState.shared)
}
```

### Success Criteria:

#### Automated Verification:
- [ ] File exists at `Purascharana/SettingsView.swift`
- [ ] Contains Form, Section, TextField components

#### Manual Verification:
- [ ] Current count pre-fills in text field
- [ ] Saving updates the counter on main screen
- [ ] Target and progress info display correctly
- [ ] Reset button shows confirmation alert
- [ ] Reset clears counter to 0
- [ ] "Готово" dismisses settings sheet

---

## Phase 5: Final Verification & Documentation

### Overview
Verify all components work together and create usage documentation.

### Changes Required:

#### 1. README.md
**File**: `Purascharana/README.md`

```markdown
# Purascharana

iOS app for tracking mantra repetition circles (круги).

## Features

- Track circles from 0 to 5556
- Daily increment with custom amount
- Persistent state (survives app restart)
- Manual count adjustment in Settings
- Copy state in Russian format: "X круга (Y)"

## Installation

1. Open Xcode
2. Create new iOS App project:
   - Product Name: Purascharana
   - Interface: SwiftUI
   - Language: Swift
3. Delete the auto-generated ContentView.swift
4. Add all .swift files from this folder to the project
5. Build and run

## File Structure

- `PurascharanaApp.swift` - App entry point
- `ContentView.swift` - Main counter screen
- `SettingsView.swift` - Settings screen
- `Models/CounterState.swift` - Data model with persistence

## Requirements

- iOS 15.0+
- Xcode 14.0+
```

### Success Criteria:

#### Automated Verification:
- [ ] All 4 Swift files exist in correct locations
- [ ] README.md exists with setup instructions

#### Manual Verification:
- [ ] Fresh Xcode project with these files compiles
- [ ] App launches on Simulator
- [ ] Add circles → counter updates → quit app → reopen → count persisted
- [ ] Copy button produces string like "16 круга (2524)"
- [ ] Settings allows manual count adjustment
- [ ] Reset clears all data

---

## Testing Strategy

### Unit Tests:
Not included in initial scope - app is simple enough for manual testing.

### Manual Testing Steps:
1. Launch app - verify shows 0 / 5556
2. Enter "10" and tap Добавить - verify shows 10 / 5556
3. Tap Копировать - paste elsewhere - verify "10 круга (10)"
4. Enter "5" and tap Добавить - verify shows 15 / 5556
5. Tap Копировать - verify "5 круга (15)"
6. Quit and relaunch app - verify still shows 15 / 5556
7. Open Settings - verify 15 in text field
8. Change to 100, tap Сохранить - verify main screen shows 100
9. Tap Сбросить счётчик - confirm - verify 0 / 5556

---

## References

- Research document: `thoughts/shared/research/2025-12-09-purascharana-ios-app.md`
