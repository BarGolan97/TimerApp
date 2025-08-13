import SwiftUI
import AVFoundation

struct TimerView: View {
    let initialTime: Int
    @State private var timeRemaining: Int
    @State private var timerActive: Bool = false
    @State private var timerPaused: Bool = false
    @State private var timerTask: Task<Void, Never>? = nil
    @State private var audioPlayer: AVAudioPlayer? = nil
    
    init(initialTime: Int) {
        self.initialTime = initialTime
        _timeRemaining = State(initialValue: initialTime)
    }
    
    var body: some View {
        VStack(spacing: 32) {
            Text(timeString)
                .font(.system(size: 48, weight: .bold, design: .monospaced))
            if !timerActive {
                Button("Start") {
                    playStartSound()
                    startTimer()
                }
                .font(.title)
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .clipShape(Capsule())
            } else if timerPaused {
                Button("Resume") {
                    resumeTimer()
                }
                .font(.title)
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .clipShape(Capsule())
            } else {
                Button("Stop") {
                    pauseTimer()
                }
                .font(.title)
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .clipShape(Capsule())
            }
        }
        .onDisappear {
            timerTask?.cancel()
        }
    }
    
    private var timeString: String {
        let minutes = timeRemaining / 60
        let seconds = timeRemaining % 60
        return String(format: "%01d:%02d", minutes, seconds)
    }
    
    private func startTimer() {
        timerActive = true
        timerPaused = false
        timerTask = Task {
            while timeRemaining > 0 && !Task.isCancelled {
                try? await Task.sleep(for: .seconds(1))
                if Task.isCancelled { break }
                await MainActor.run {
                    timeRemaining -= 1
                    if timeRemaining == 0 {
                        timerActive = false
                        timerPaused = false
                    }
                }
            }
        }
    }
    
    private func pauseTimer() {
        timerPaused = true
        timerTask?.cancel()
        timerTask = nil
    }
    
    private func resumeTimer() {
        timerPaused = false
        timerTask = Task {
            while timeRemaining > 0 && !Task.isCancelled && !timerPaused {
                try? await Task.sleep(for: .seconds(1))
                if Task.isCancelled || timerPaused { break }
                await MainActor.run {
                    timeRemaining -= 1
                    if timeRemaining == 0 {
                        timerActive = false
                        timerPaused = false
                    }
                }
            }
        }
    }
    
    // A satisfying pop sound will play when the timer starts. Ensure you have a sound file named `Pop.wav` in your Xcode project's main bundle.
    private func playStartSound() {
        guard let url = Bundle.main.url(forResource: "Pop", withExtension: "wav") else { return }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("Could not play sound: \(error.localizedDescription)")
        }
    }
}

#Preview {
    TimerView(initialTime: 5 * 60)
}
