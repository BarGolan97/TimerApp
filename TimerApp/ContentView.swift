//
//  ContentView.swift
//  TimerApp
//
//  Created by Yonatan Golestany on 23/07/2025.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    @Environment(\.openWindow) private var openWindow
    @EnvironmentObject var timerSettings: TimerSettings

    @State private var selectedHours: Int = 0
    @State private var selectedMinutes: Int = 0
    @State private var selectedSeconds: Int = 0

    var body: some View {
        ZStack {
            VStack(spacing: 32) {
                Spacer(minLength: 30)
                Text("Countdown")
                    .font(.system(size: 38, weight: .bold, design: .monospaced))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.top, 24)

                // Pickers Row
                HStack(alignment: .center, spacing: 12) {
                    VStack(spacing: 4) {
                        Text("Sec")
                            .font(.system(.headline, design: .monospaced)).bold()
                            .foregroundColor(.white)
                        Picker("", selection: $selectedSeconds) {
                            ForEach(0..<60) {
                                Text("\($0)")
                                    .font(.system(.body, design: .monospaced))
                                    .tag($0)
                            }
                        }
                        .frame(width: 70, height: 120)
                        .clipped()
                        .pickerStyle(.wheel)
                        .background(Color(.systemGray5).opacity(0.28))
                        .cornerRadius(12)
                    }
                    VStack(spacing: 4) {
                        Text("Min")
                            .font(.system(.headline, design: .monospaced)).bold()
                            .foregroundColor(.white)
                        Picker("", selection: $selectedMinutes) {
                            ForEach(0..<60) {
                                Text("\($0)")
                                    .font(.system(.body, design: .monospaced))
                                    .tag($0)
                            }
                        }
                        .frame(width: 70, height: 120)
                        .clipped()
                        .pickerStyle(.wheel)
                        .background(Color(.systemGray5).opacity(0.28))
                        .cornerRadius(12)
                    }
                    VStack(spacing: 4) {
                        Text("Hour")
                            .font(.system(.headline, design: .monospaced)).bold()
                            .foregroundColor(.white)
                        Picker("", selection: $selectedHours) {
                            ForEach(0..<24) {
                                Text("\($0)")
                                    .font(.system(.body, design: .monospaced))
                                    .tag($0)
                            }
                        }
                        .frame(width: 70, height: 120)
                        .clipped()
                        .pickerStyle(.wheel)
                        .background(Color(.systemGray5).opacity(0.28))
                        .cornerRadius(12)
                    }
                }
                .frame(maxWidth: .infinity)

                // Buttons Row
                HStack {
                    Button(action: {
                        // Start timer (open timerWindow, pass values if needed)
                        print("Starting timer with: \(selectedHours)h \(selectedMinutes)m \(selectedSeconds)s")
                        let totalSeconds = (selectedHours * 3600) + (selectedMinutes * 60) + selectedSeconds
                        if totalSeconds > 0 {
                            timerSettings.initialTime = totalSeconds
                        }
                        timerSettings.autoStart = true
                        openWindow(id: "timerWindow")
                    }) {
                        Text("Start")
                            .font(.system(size: 22, weight: .medium, design: .monospaced))
                            .foregroundColor(.white)
                            .frame(width: 100, height: 70)
                    }
                    .background(Color.green)
                    .cornerRadius(22)
                }
                Spacer()
            }
            .padding(.horizontal, 16)
            .environment(\.layoutDirection, .rightToLeft)
        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
        .preferredColorScheme(.dark)
        .environmentObject(TimerSettings())
}
