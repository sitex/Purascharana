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
