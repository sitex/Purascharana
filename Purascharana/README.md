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

- iOS 16.0+
- Xcode 14.0+
