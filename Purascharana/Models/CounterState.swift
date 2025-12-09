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
        return "\(todayIncrement) \(pluralCircles(todayIncrement)) (\(totalCircles))"
    }

    private func pluralCircles(_ n: Int) -> String {
        let lastTwo = n % 100
        let lastOne = n % 10

        if lastTwo >= 11 && lastTwo <= 14 {
            return "кругов"
        }

        switch lastOne {
        case 1:
            return "круг"
        case 2, 3, 4:
            return "круга"
        default:
            return "кругов"
        }
    }

    var progress: Double {
        return Double(totalCircles) / Double(CounterState.targetCircles)
    }

    var isComplete: Bool {
        return totalCircles >= CounterState.targetCircles
    }
}
