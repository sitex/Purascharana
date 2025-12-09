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
