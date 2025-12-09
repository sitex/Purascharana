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
