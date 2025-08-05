import Combine
import Foundation

class WorkoutViewModel: ObservableObject {
    @Published var progress: CGFloat = 0
    @Published var state: WorkoutStage = .initial
    @Published var timeInterval: TimeInterval = 45
    @Published var timeMMSS: String = "00:00"

    @Published var sets: [WorkoutRowViewModel] = [
        WorkoutRowViewModel(id: 1, previousKg: 15, previousReps: 10),
        WorkoutRowViewModel(id: 2, previousKg: 15, previousReps: 10),
        WorkoutRowViewModel(id: 3, previousKg: 15, previousReps: 10)
    ]
    
    private var timer: Timer?
    private var elapsedTime: TimeInterval = 0

    func startWorkout(_ isNewTimer: Bool = false) {
        state = .started
        progress = 1
        guard isNewTimer else { return }
        elapsedTime = 0
        timeMMSS = "00:00"
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.elapsedTime += 1
            self.timeMMSS = self.formatTimeMMSS(self.elapsedTime)
        }
    }
    
    func finishWorkout() {
        // TODO: popup modal summary screen
        state = .initial
        progress = 0
        timer?.invalidate()
        timer = nil
        elapsedTime = 0
        timeMMSS = "00:00"
    }
    
    func pickRestTime() {
        state = .picker
        progress = 1
    }
    
    func startTimer(for restTime: RestTimeSeconds) {
        state = .resting
        progress = 1
    }
    
    private func formatTimeMMSS(_ interval: TimeInterval) -> String {
        let minutes = Int(interval) / 60
        let seconds = Int(interval) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
